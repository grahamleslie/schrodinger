# frozen_string_literal: true

class AddTriggeredByToRun < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :triggered_by, :string
  end
end
