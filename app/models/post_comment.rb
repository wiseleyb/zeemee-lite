# frozen_string_literal: true

class PostComment < ApplicationRecord
  include Feedable

  belongs_to :post
  belongs_to :user
end
