# frozen_string_literal: true

require 'mixlib/shellout'
require_relative '../helpers/pipelines_helper'

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
    @config = nil

    begin
      begin_run
      cleanup_old_runs unless ENV['CLEANUP_KEEP_LATEST_RUNS'].nil?
      create_work_directory
      clone_repository
      read_config
      build_image
      remove_container if @config.remove_existing
      run_container if @config.run
      complete_run
    rescue StandardError => e
      fail_run e.message
    end
  end

  private

  def begin_run
    log 'Getting started...'
  end

  def cleanup_old_runs
    runs_to_keep = Integer ENV['CLEANUP_KEEP_LATEST_RUNS']
    if @pipeline.runs.count > runs_to_keep
      log "Cleaning up old runs (only keeping the #{runs_to_keep} latest)..."
      latest = @pipeline.latest_runs(runs_to_keep)
      Run.where("id NOT IN (#{latest.pluck(:id).join(', ')})").destroy_all
    end
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

  def read_config
    log "Reading configuration..."
    @config = PipelinesHelper::PipelineConfiguration.new(
      path: "#{@run.work_directory}/#{DOCKERFILE}",
      name: @run.docker_tag
    )
    log "Configuration:"
    log @config.to_s
  end

  def build_image
    log "Building image #{@run.docker_tag}..."
    run_command "docker build \\
#{@build_args} \\
-f #{DOCKERFILE} \\
-t #{@run.docker_tag} .", @run.work_directory
  end

  def remove_container
    name = @config.name || @run.docker_tag
    log "Stopping image #{name}..."
    run_command "docker stop #{name}", @run.work_directory, fail_on_error: false
    log "Removing image #{name}..."
    run_command "docker rm #{name}", @run.work_directory, fail_on_error: false
  end

  def run_container
    name = @config.name
    log "Running image #{name}..."
    run_command "docker run --name #{name} \\
#{@env_vars} \\
#{@config.run_args} \\
-t #{@run.docker_tag}", @run.work_directory
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

  def generate_vars_seq(flag)
    @secrets.map do |secret|
      "#{flag} #{secret.name}='#{secret.value}'"
    end.join(' \\
')
  end

  def fail_run(reason)
    log 'Failed!'
    log reason
    @run.failed_at = DateTime.now
    @run.save!
  end

  def run_command(command, working_directory, fail_on_error: true)
    log command
    cmd = Mixlib::ShellOut.new(command, cwd: working_directory)
    cmd.run_command
    if cmd.error?
      log cmd.stdout.force_encoding(Encoding::UTF_8)
      if fail_on_error
        cmd.error!
      else
        log cmd.stderr.force_encoding(Encoding::UTF_8)
      end
    end
  end

  def log(content)
    @secrets.each do |secret|
      puts secret.name
      content = content.gsub secret.value, secret.hidden_value
    end

    output = @run.output || ''
    unless output == ''
      output += '
'
    end
    output += content
    @run.output = output
    @run.save!
  end
end
