# frozen_string_literal: true

class FeedService
  attr_accessor :user

  # colors from https://colorhunt.co/palette/eb5353f9d92336ae7c187498
  # #EB5353 #F9D923 #36AE7C #187498
  COLORS = {
    AdUnit: '#EB5353',
    Event: '#F9D923',
    Follow: '#3F979B',
    Notification: '#36AE7C',
    Post: '#187498',
    PostComment: '#8F43EE'
  }.freeze

  AD_INTERVAL = 5

  def initialize(user_id)
    @user = User.find(user_id)
  end

  def feed_items
    fis = FeedItem.where(user_id: user.id)
                  .order('created_at desc')
    inject_ads(fis)
  end

  # NOTE: This is a hard problem - don't kill yourself - but this is a good
  #       place to show something interesting
  # TODO: Figure out some way to dynamically add AdUnits into the feed
  #
  # Returns a ActiveRecord Relation with ads inserted every AD_INTERNAL posts
  #
  # Consider issues like:
  # * if the user has 10,000 items in their feed
  # * maintaining paging
  # * what happens when an AdUnit is deleted
  # * maintaining AREL return instead of an Array so this will work with
  #   ActiveRecord Relations dependent things like GQL, paging gems, etc.
  # * should we periodically clean out AdUnits from feeds?
  # * If we want an ad every AD_INTERNAL posts do we need to rework this
  #   when FeedItems are added/removed?
  # * the rest of the feed is date oriented - so inserting AdUnits should
  #   consider that. Is there a solution that doesn't involve dates here?
  def inject_ads(feed_items)
    # TODO: Implement
    feed_items
  end

  # This is a terrible solution - this is just to get some data to play
  # around with
  def generate_feed
    uorg_ids = user.orgs.map(&:id)
    ufollowed_ids = user.followed_users.map(&:id)
    uids = [ufollowed_ids, user.id].flatten

    events = Event.where(org_id: uorg_ids)
    follows = Follow.where(followed_user_id: user.id)
    notifications =
      Notification.where(user_id: user.id)
    posts = Post.where(user_id: uids)
    post_comments = PostComment.where(post: posts)

    [events,
     notifications,
     posts,
     post_comments,
     follows].flatten.sort_by(&:created_at).each_with_index do |obj, _idx|
      FeedItem.create(feedable: obj,
                      user_id: user.id,
                      created_at: obj.created_at,
                      updated_at: obj.updated_at)

      # throw in a random ad (terrible idea - just for data model testing)
      # next unless (idx % 5).zero?
      # ad = AdUnit.order('random()').first
      # FeedItem.create(feedable: ad,
      #                 user_id: user.id,
      #                 created_at: obj.created_at + 10,
      #                 updated_at: obj.updated_at + 10)
    end
  end

  def self.generate_feeds
    User.all.each do |u|
      FeedService.new(u.id).generate_feed
    end
  end

  def self.border_color(feed_item)
    FeedService::COLORS[feed_item.feedable.class.name.to_sym]
  end
end
