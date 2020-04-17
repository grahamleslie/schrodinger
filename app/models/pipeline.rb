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

  scope :with_triggers, -> { where('triggers is not null') }

  def next_run_num
    if latest = latest_run
      latest.num + 1
    else
      1
    end
  end

  def latest_run
    runs.order(created_at: :desc)
    .first
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
