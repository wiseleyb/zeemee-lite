# frozen_string_literal: true

class User < ApplicationRecord
  has_many :feed_items, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :followed_users, through: :follows
  has_many :followers, through: :follows, source: :followed_user
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :user_orgs, dependent: :destroy
  has_many :orgs, through: :user_orgs
end
