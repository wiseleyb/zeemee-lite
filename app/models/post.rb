# frozen_string_literal: true

class Post < ApplicationRecord
  include Feedable

  belongs_to :user
  has_many :post_comments, dependent: :destroy
end
