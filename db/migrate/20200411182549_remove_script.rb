# frozen_string_literal: true

class RemoveScript < ActiveRecord::Migration[6.0]
  def change
    remove_column :pipelines, :script
  end
end
