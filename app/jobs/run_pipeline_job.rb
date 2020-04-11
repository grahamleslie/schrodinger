require 'mixlib/shellout'

class RunPipelineJob < ApplicationJob
  DOCKERFILE = 'Dockerfile.schrodinger'

  def perform(run_id)
    @run = Run.find run_id
    @pipeline = @run.pipeline
    @branch = @run.branch
    
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
    log "Getting started..."
  end

  def create_work_directory
    Dir.mkdir @run.work_directory
    log "Created work directory #{@run.work_directory}."
  end

  def clone_repository
    log "Cloning repository #{@pipeline.repo}..."
    git = Git.clone(@pipeline.repo, './', path: @run.work_directory)
    log "Cloned repository."
    log "Checking out #{@branch}..."
    git.checkout @branch
    log "Checked out branch."
    commit = git.log[0]
    @run.commit_sha = commit.sha
    @run.commit_message = commit.message
    @run.save!
    log "Commit is #{commit.sha} (#{commit.message}) by #{commit.author.email} at #{commit.date.strftime("%m-%d-%y")}"
  end

  def build_image
    log "Building image #{@run.docker_tag}..."
    log run_command "docker build -f #{DOCKERFILE} -t #{@run.docker_tag} .", @run.work_directory
    log "Built image."
  end

  def run_image
    log "Running image #{@run.docker_tag}..."
    log run_command "docker run -t #{@run.docker_tag}", @run.work_directory
    log "Ran image."
  end

  def complete_run
    log "Finished!"
    @run.completed_at = DateTime.now
    @run.save!
  end

  def fail_run reason
    log "Failed!"
    log reason
    @run.failed_at = DateTime.now
    @run.save!
  end

  def run_command(command, working_directory)
    cmd = Mixlib::ShellOut.new(command, cwd: working_directory)
    cmd.run_command
    cmd.error!
    cmd.stdout
  end

  def log(content)
    output = @run.output || ""
    unless output == ""
      output += "<br />"
    end
    output += content
    @run.output = output
    @run.save!
  end
end
