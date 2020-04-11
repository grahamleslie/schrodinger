# == Schema Information
#
# Table name: pipelines
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  script     :string
#  repo       :string
#
require 'test_helper'

class PipelineTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
