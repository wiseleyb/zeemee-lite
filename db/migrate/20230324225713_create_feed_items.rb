# frozen_string_literal: true

class CreateFeedItems < ActiveRecord::Migration[7.0]
  def change
    create_table :feed_items do |t|
      t.integer :user_id, index: true
      t.integer :feedable_id
      t.string :feedable_type
      t.timestamps
    end

    add_index :feed_items,
              %i[feedable_id feedable_type],
              name: :fi1
    add_index :feed_items,
              %i[user_id feedable_id feedable_type],
              name: :fi2
  end
end
