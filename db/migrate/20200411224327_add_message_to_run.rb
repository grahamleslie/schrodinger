class AddMessageToRun < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :commit_message, :string
  end
end
