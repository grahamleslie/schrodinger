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
class Secret < ApplicationRecord
end
