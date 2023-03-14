# frozen_string_literal: true

class FeedItem < ApplicationRecord
  belongs_to :feedable, polymorphic: true

  paginates_per 5

  def self.new_feed_item(user_id, obj)
    FeedItem.where(user_id: user_id, feedable: obj).first_or_create
  end

  def self.new_random_ad(user_id)
    FeedItem.create(user_id: user_id,
                    feedable: AdUnit.all.order('random()').first)
  end

  def self.find_feed_item(user_id, obj)
    FeedItem.where(user_id: user_id, feedable: obj).first
  end

  def ad_unit?
    feedable_type == 'AdUnit'
  end
end
