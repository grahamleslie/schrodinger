class AddBranchTriggers < ActiveRecord::Migration[6.0]
  def change
    add_column :pipelines, :triggers, :string
  end
end
