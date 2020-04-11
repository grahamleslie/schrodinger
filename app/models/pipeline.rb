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
class Pipeline < ApplicationRecord
    validates :name, presence: true
end
