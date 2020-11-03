# frozen_string_literal: true

# == Schema Information
#
# Table name: runs
#
#  id             :integer          not null, primary key
#  num            :integer
#  completed_at   :datetime
#  failed_at      :datetime
#  output         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  pipeline_id    :integer
#  commit_sha     :string
#  commit_message :string
#  branch         :string
#  triggered_by   :string
#
# Indexes
#
#  index_runs_on_pipeline_id  (pipeline_id)
#
class Run < ApplicationRecord
  belongs_to :pipeline, class_name: 'Pipeline'

  after_create :run

  def run
    RunPipelineJob.perform_later id
  end

  def docker_tag
    I18n.transliterate("schrodinger_#{pipeline.name}_#{num}_#{created_at}")
        .gsub(/[^\w_]/, '_')
        .tr(' ', '_')
        .downcase
  end

  def work_directory
    "#{Rails.root}/tmp/#{docker_tag}"
  end

  def commit_sha_short
    sha = commit_sha
    return if sha.nil? || sha.length < 7

    sha[0..7]
  end

  def in_progress?
    completed_at.nil? && failed_at.nil?
  end

  def finished?
    !in_progress?
  end

  def completed?
    !completed_at.nil?
  end

  def failed?
    !failed_at.nil?
  end

  def status
    if in_progress?
      "🚧 #{branch} in Progress..."
    elsif completed_at?
      "✅ Completed #{branch}"
    elsif failed_at?
      "☠️ Failed #{branch}"
    end
  end

  def duration_seconds
    finished_at = completed_at || failed_at

    finished? ? ((finished_at - created_at)).to_i : nil
  end

  def pretty_duration
    if duration_seconds.nil?
      ''
    else
      minutes = (duration_seconds / 60).floor
      seconds = (duration_seconds % 60).round
      "#{minutes}m #{seconds}s"
    end
  end

  def to_json(*)
    super(methods: %i[
      in_progress?
      finished?
      completed?
      failed?
      status
      docker_tag
      commit_sha_short
    ])
  end
end
