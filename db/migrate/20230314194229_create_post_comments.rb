# frozen_string_literal: true

class CreatePostComments < ActiveRecord::Migration[7.0]
  def change
    create_table :post_comments do |t|
      t.integer :post_id, index: true
      t.string :comment
      t.integer :user_id, index: true

      t.timestamps
    end
  end
end
