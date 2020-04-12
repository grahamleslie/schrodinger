# frozen_string_literal: true

class AddBranchToRun < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :branch, :string
  end
end
