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
require 'test_helper'

class RunTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
