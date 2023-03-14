# frozen_string_literal: true

class CreateAdUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :ad_units do |t|
      t.string :ad

      t.timestamps
    end
  end
end
