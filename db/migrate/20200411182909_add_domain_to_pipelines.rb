# frozen_string_literal: true

class AddDomainToPipelines < ActiveRecord::Migration[6.0]
  def change
    add_column :pipelines, :domain, :string
  end
end
