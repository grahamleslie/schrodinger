class CreatePipelines < ActiveRecord::Migration[6.0]
  def change
    create_table :pipelines do |t|
      t.string :name

      t.timestamps
    end
  end
end
