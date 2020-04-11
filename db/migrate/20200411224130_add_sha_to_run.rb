class AddShaToRun < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :commit_sha, :string
  end
end
