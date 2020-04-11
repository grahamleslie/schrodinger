class AddRunsToPipeline < ActiveRecord::Migration[6.0]
  def change
    add_reference :runs, :pipeline, foreign_key: { to_table: :pipelines }
  end
end
