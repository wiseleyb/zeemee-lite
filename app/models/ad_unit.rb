# frozen_string_literal: true

class AdUnit < ApplicationRecord
  include Feedable

  INTERVAL = 5 # insert an add after X feed_items for a user

  def company
    ad.split(':').first
  end

  def pitch
    ad.split(':').last
  end
end
