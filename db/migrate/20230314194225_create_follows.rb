# frozen_string_literal: true

class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows do |t|
      t.integer :user_id, index: true
      t.integer :followed_user_id, index: true

      t.timestamps
    end
  end
end
