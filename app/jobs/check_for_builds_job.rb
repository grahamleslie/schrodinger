# frozen_string_literal: true

class CheckForBuildsJob < ApplicationJob
  queue_as :default

  def perform
    Pipeline.with_triggers.each { |pipeline| check_for_new_commit pipeline }
  end

  def check_for_new_commit(pipeline)
    cwd = random_work_directory
    Dir.mkdir cwd
    git = Git.clone(pipeline.repo, './', path: cwd, bare: true)
    git.fetch
    pipeline.branches.each do |branch|
      latest = pipeline.latest_run_by_branch(branch)
      object = git.object(branch.to_s)

      next unless !latest.present? || latest.commit_sha != object.sha

      pipeline.runs.create({
                             num: pipeline.runs.count + 1,
                             branch: branch,
                             triggered_by: 'scan'
                           })
    end
  rescue StandardError => e
    Rails.logger.warn "Failure during CheckForBuildsJob:\n#{e.message}"
    Rails.logger.flush
  end

  private

  def random_work_directory
    "#{Rails.root}/tmp/check_#{SecureRandom.uuid}"
  end
end
