class RunPipelineJob < ApplicationJob
  def perform(run_id)
    @run = Run.find run_id
    log "Getting started..."
    log "Finished!"
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
