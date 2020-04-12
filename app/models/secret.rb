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
  validates :name, presence: true, format: /[A-Z0-9_]+/
  validates :value, presence: true
  validates :domain, presence: true

  scope :by_domain, ->(domain) { where("domain = ?", domain) }

  def hidden_value
    value.gsub(/./, '*')
  end
end
