# frozen_string_literal: true

require 'mixlib/shellout'

class RunPipelineJob < ApplicationJob
  queue_as :default

  DOCKERFILE = 'Dockerfile.schrodinger'

  def perform(run_id)
    @run = Run.find run_id
    @pipeline = @run.pipeline
    @branch = @run.branch
    @secrets = Secret.by_domain(@pipeline.domain, include_globals: true)
    @build_args = generate_build_args
    @env_vars = generate_env_vars

    begin
      begin_run
      create_work_directory
      clone_repository
      build_image
      run_image
      complete_run
    rescue StandardError => e
      fail_run e.message
    end
  end

  private

  def begin_run
    log 'Getting started...'
  end

  def create_work_directory
    Dir.mkdir @run.work_directory
    log "Created work directory #{@run.work_directory}."
  end

  def clone_repository
    log "Cloning repository #{@pipeline.repo}..."
    git = Git.clone(@pipeline.repo, './', path: @run.work_directory)
    log "Checking out #{@branch}..."
    git.checkout @branch
    commit = git.log[0]
    @run.commit_sha = commit.sha
    @run.commit_message = commit.message
    @run.save!
    log "Commit is #{commit.sha} (#{commit.message}) by #{commit.author.email} at #{commit.date.strftime('%m-%d-%y')}"
  end

  def build_image
    log "Building image #{@run.docker_tag}..."
    run_command "docker build #{@build_args} -f #{DOCKERFILE} -t #{@run.docker_tag} .", @run.work_directory
  end

  def run_image
    log "Running image #{@run.docker_tag}..."
    run_command "docker run --name #{@run.docker_tag} #{@env_vars} -t #{@run.docker_tag}", @run.work_directory
  end

  def complete_run
    log 'Finished!'
    @run.completed_at = DateTime.now
    @run.save!
  end

  def generate_build_args
    generate_vars_seq '--build-arg'
  end

  def generate_env_vars
    generate_vars_seq '-e'
  end

  def generate_vars_seq flag
    @secrets.map { |secret|
      "#{flag} #{secret.name}='#{secret.value}'"
    }.join(" ")
  end

  def fail_run(reason)
    log 'Failed!'
    log reason
    @run.failed_at = DateTime.now
    @run.save!
  end

  def run_command(command, working_directory)
    log command
    cmd = Mixlib::ShellOut.new(command, cwd: working_directory)
    cmd.run_command
    cmd.error!
    log cmd.stdout
  end

  def log(content)
    @secrets.each { |secret|
      puts secret.name
      content = content.gsub secret.value, secret.hidden_value
    }

    output = @run.output || ''
    output += '
' unless output == ''
    output += content
    @run.output = output
    @run.save!
  end
end
