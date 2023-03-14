# frozen_string_literal: true

module Feedable
  extend ActiveSupport::Concern

  included do
    has_many :feed_items, as: :feedable
  end

  class_methods do
  end
end
