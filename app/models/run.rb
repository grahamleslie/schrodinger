# == Schema Information
#
# Table name: runs
#
#  id           :integer          not null, primary key
#  num          :integer
#  completed_at :datetime
#  failed_at    :datetime
#  output       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  pipeline_id  :integer
#
# Indexes
#
#  index_runs_on_pipeline_id  (pipeline_id)
#
class Run < ApplicationRecord
    belongs_to :pipeline, class_name: 'Pipeline'
end
