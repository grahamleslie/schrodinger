# frozen_string_literal: true

class CreateSecrets < ActiveRecord::Migration[6.0]
  def change
    create_table :secrets do |t|
      t.string :name
      t.string :value
      t.string :domain

      t.timestamps
    end
  end
end
