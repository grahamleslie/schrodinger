# frozen_string_literal: true

# == Schema Information
#
# Table name: pipelines
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  repo       :string
#  triggers   :string
#  domain     :string
#
class Pipeline < ApplicationRecord
  has_many :runs, dependent: :destroy, foreign_key: 'pipeline_id'

  validates :name, presence: true
  validates :repo, presence: true,
                   format: {
                     with: /git\@(.*).git/,
                     message: 'please enter a valid git repository'
                   }

  scope :with_triggers, -> { where('triggers IS NOT NULL') }

  def self.pretty_activity(days: 14)
    runs_per_day = (0..days).to_a.reverse.
      map { |num| 
        day = DateTime.now.days_ago(num)
        Run.where('created_at < ? AND created_at > ?', day.end_of_day, day.beginning_of_day).count(:id)
      }
    Sparkr.sparkline(runs_per_day)
  end

  def average_duration_seconds 
    durations = runs.limit(64).
      map(&:duration_seconds).
      compact
    durations.inject{ |sum, el| sum + el }.to_f / durations.size
  end

  def pretty_average_duration
    if average_duration_seconds.nil? 
      ""
    end
    
    minutes = (average_duration_seconds / 60).floor
    seconds = (average_duration_seconds % 60).round
    "#{minutes}m #{seconds}s"
  end

  def pretty_activity(days: 7)
    runs_per_day = (0..days).to_a.reverse.
      map { |num| 
        day = DateTime.now.days_ago(num)
        runs.where('created_at < ? AND created_at > ?', day.end_of_day, day.beginning_of_day).count(:id)
      }
    Sparkr.sparkline(runs_per_day)
  end

  def next_run_num
    if latest = latest_run
      latest.num + 1
    else
      1
    end
  end

  def latest_runs(limit)
    runs.order(created_at: :desc).limit(limit)
  end

  def latest_run
    latest_runs(1).first
  end

  def latest_run_by_branch(branch)
    runs.where('branch = ?', branch)
        .order(created_at: :desc)
        .first
  end

  def branches
    if triggers.nil?
      []
    else
      triggers.gsub(/(\r)?\n/, '\n').split(/\\n/).uniq
    end
  end
end
