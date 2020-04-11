class AddStepToPipeline < ActiveRecord::Migration[6.0]
  def change
    add_column :pipelines, :step, :pipeline
  end
end
