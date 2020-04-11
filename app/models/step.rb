class Step < ApplicationRecord
    belongs_to :pipeline

    validates :name, presence: true
end
