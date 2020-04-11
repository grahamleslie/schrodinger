class CreateRuns < ActiveRecord::Migration[6.0]
  def change
    create_table :runs do |t|
      t.integer :num
      t.datetime :completed_at
      t.datetime :failed_at
      t.string :output

      t.timestamps
    end
  end
end
