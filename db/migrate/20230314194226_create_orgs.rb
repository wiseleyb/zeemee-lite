# frozen_string_literal: true

class CreateOrgs < ActiveRecord::Migration[7.0]
  def change
    create_table :orgs do |t|
      t.string :name

      t.timestamps
    end
  end
end
