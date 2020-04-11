class RunPipelineJob < ApplicationJob
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
    log "Created #{@run.work_directory}"
  end

  def clone_repository
    git = Git.clone(@pipeline.repo, @pipeline.name, path: @run.work_directory)
    log "Cloned repository #{@pipeline.repo}"
  end

  def build_image
    log "Building image #{@run.docker_tag}..."
    cmd = "
cd #{@run.work_directory}
docker build -t #{@run.docker_tag} .
"
    cmd = "ls -la"
    output = fork { exec(cmd) }

    log "#{output}"
    log "Finished building #{@run.docker_tag}."
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
