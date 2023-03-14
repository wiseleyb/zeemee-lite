# frozen_string_literal: true

class Follow < ApplicationRecord
  include Feedable

  belongs_to :user
  belongs_to :followed_user, class_name: 'User', foreign_key: :followed_user_id

  validates :user_id, uniqueness: { scope: :followed_user_id }
end
