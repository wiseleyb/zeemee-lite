# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.integer :org_id, index: true
      t.string :title
      t.string :description
      t.datetime :event_date

      t.timestamps
    end
  end
end
