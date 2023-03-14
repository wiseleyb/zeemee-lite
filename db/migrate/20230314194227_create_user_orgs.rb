# frozen_string_literal: true

class CreateUserOrgs < ActiveRecord::Migration[7.0]
  def change
    create_table :user_orgs do |t|
      t.integer :user_id, index: true
      t.integer :org_id, index: true

      t.timestamps
    end
  end
end
