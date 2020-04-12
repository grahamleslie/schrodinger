# frozen_string_literal: true

# == Schema Information
#
# Table name: secrets
#
#  id         :integer          not null, primary key
#  name       :string
#  value      :string
#  domain     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class SecretTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
