# frozen_string_literal: true

class AddRepoToPipeline < ActiveRecord::Migration[6.0]
  def change
    add_column :pipelines, :repo, :string
  end
end
