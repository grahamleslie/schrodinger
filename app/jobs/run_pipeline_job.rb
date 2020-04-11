require 'mixlib/shellout'

class RunPipelineJob < ApplicationJob
  DOCKERFILE = 'Dockerfile.schrodinger'

  def perform(run_id)
    @run = Run.find run_id
    @pipeline = @run.pipeline
    @branch = "master"
    
    begin
      begin_run
      create_work_directory
      clone_repository
      build_image
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
  end

  def build_image
    log "Building image #{@run.docker_tag}..."
    
    exec_build = Mixlib::ShellOut.new("docker build -f #{DOCKERFILE} -t #{@run.docker_tag} .", cwd: @run.work_directory)
    exec_build.run_command
    exec_build.error!
    log exec_build.stdout

    log "Built image."
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
