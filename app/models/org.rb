# frozen_string_literal: true

class Org < ApplicationRecord
  has_many :events, dependent: :destroy
  has_many :user_orgs, dependent: :destroy
  has_many :users, through: :user_orgs
end
