# frozen_string_literal: true

class AddScriptToPipeline < ActiveRecord::Migration[6.0]
  def change
    add_column :pipelines, :script, :string
  end
end
