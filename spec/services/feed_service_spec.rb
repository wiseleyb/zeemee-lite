# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedService, type: :service do
  let(:org) { create(:org) }

  let(:current_user) do
    u = create(:user)
    # follow an org
    create(:user_org, user: u, org: org)
    u
  end

  let!(:friend_user) do
    u = create(:user)
    # follow an org
    create(:user_org, user: u, org: org)
    # add friends in both directions
    create(:follow, user: current_user, followed_user: u)
    create(:follow, user: u, followed_user: current_user)
    u
  end

  describe 'FeedService' do
    it 'has basic data setup' do
      expect(current_user.orgs.count).to eq(1)
      expect(current_user.orgs.first).to eq(org)
      expect(current_user.followed_users.count).to eq(1)
      expect(current_user.followed_users.first).to eq(friend_user)

      expect(friend_user.orgs.count).to eq(1)
      expect(friend_user.orgs.first).to eq(org)
      expect(friend_user.followed_users.count).to eq(1)
      expect(friend_user.followed_users.first).to eq(current_user)
    end

    context 'for AdUnits' do
      before do
        13.times { create(:event, org: org) }
        2.times { create(:ad_unit) }
      end

      context 'when feed changes' do
        it 'inserts an ad every FeedService::AD_INTERVAL' do
          i = FeedService::AD_INTERVAL
          feed_items = FeedService.new(current_user.id).feed_items
          expect(feed_items.class.name).to eq('ActiveRecord::Relation')
          expect(feed_items[i].ad_unit?).to be_truthy
          expect(feed_items[i + FeedService::AD_INTERVAL + 1].ad_unit?).to \
            be_truthy
          ficnt = feed_items.select do |r|
            r.feedable_type == 'AdUnit'
          end.size
          expect(ficnt).to eq(2)
        end
      end

      context 'when ad is deleted' do
        # NOTE: we should probably figure out to regenerate all feeds to the
        # ads are correct again - but that seems out of scope for this
        # exercise but might be interesting to discuss in the code
        # review/interview
        it 'removes ad from feed' do
          # check for exisence and find ad to destroy
          feed_items = FeedService.new(current_user.id).feed_items
          ad = feed_items.select { |fi| fi.feedable_type == 'AdUnit' }.first
          expect(ad).to_not be_nil

          # destroy and check it was removed
          ad.destroy
          expect(FeedItem.where(feedable: ad).count).to eq(0)
        end
      end
    end

    context 'for Events' do
      context 'when an org as user follows' do
        let!(:event) { create(:event, org: org) }

        let(:current_user_feed_item) do
          FeedItem.find_feed_item(current_user.id, event)
        end

        let(:friend_user_feed_item) do
          FeedItem.find_feed_item(friend_user.id, event)
        end

        context 'creates an event' do
          it 'shows up in the feed for all users following org' do
            expect(current_user.reload.feed_items).to \
              include(current_user_feed_item)
            expect(friend_user.reload.feed_items).to \
              include(friend_user_feed_item)
          end
        end

        context 'deletes an event' do
          it 'removes event from the feed for all users following org' do
            expect(current_user.reload.feed_items).to \
              include(current_user_feed_item)
            expect(friend_user.reload.feed_items).to \
              include(friend_user_feed_item)
            event.destroy
            expect(FeedItem.find_feed_item(current_user.id, event)).to be_nil
            expect(FeedItem.find_feed_item(friend_user.id, event)).to be_nil
          end
        end
      end
    end

    context 'for Follow' do
      let(:new_user) { create(:user) }
      let(:new_follower) do
        build(:follow, user: new_user, followed_user: current_user)
      end

      context 'when someone follows a user' do
        it 'adds to their feed' do
          expect(current_user.followers).to_not include(new_follower)
          new_follower.save!
          expect(current_user.reload.followers).to_not include(new_follower)

          fi = FeedItem.find_feed_item(current_user.id, new_follower)
          expect(fi).to_not be_nil
        end
      end

      context 'when someone unfollows a user' do
        it 'removes follow from feed of followed user' do
          # setup/create follow
          expect(current_user.followers).to_not include(new_follower)
          new_follower.save!
          expect(current_user.reload.followers).to_not include(new_follower)
          fi = FeedItem.find_feed_item(current_user.id, new_follower)
          expect(fi).to_not be_nil

          new_follower.destroy
          fi = FeedItem.find_feed_item(current_user.id, new_follower)
          expect(fi).to be_nil
        end
      end
    end

    context 'for Notifications' do
      let(:notification) { build(:notification, user: current_user) }

      context 'when a notification is created for current_user' do
        it 'adds the notification to the current_users feed' do
          # ensure it doesn't already exist
          fi = FeedItem.where(user_id: current_user.id,
                              feedable_type: 'Notification').first
          expect(fi).to be_nil

          # create the notification
          notification.save!

          # check that it was added to the feed
          fi = FeedItem.find_feed_item(current_user.id, notification)
          expect(fi).to_not be_nil
        end
      end

      context 'when a notification is deleted for current_user' do
        it 'removes it from the current_users feed' do
          # ensure it doesn't already exist
          fi = FeedItem.where(user_id: current_user.id,
                              feedable_type: 'Notification').first
          expect(fi).to be_nil

          # create notification
          notification.save!

          # check that it was added to the feed
          fi = FeedItem.find_feed_item(current_user.id, notification)
          expect(fi).to_not be_nil

          # remove notification and recheck
          notification.destroy
          fi = FeedItem.find_feed_item(current_user.id, notification)
          expect(fi).to be_nil
        end
      end
    end

    context 'for Posts' do
      let(:post) { build(:post, user: friend_user) }

      before do
        # ensure friends
        expect(current_user.followers).to include(friend_user)
      end

      context 'when user creates a post' do
        it 'adds post to followers feeds' do
          # ensure it doesn't already exist
          fi = FeedItem.where(user_id: current_user.id,
                              feedable_type: 'Post').first
          expect(fi).to be_nil

          # create the post
          post.save!

          # check that it was added to the feed
          fi = FeedItem.find_feed_item(current_user.id, post)
          expect(fi).to_not be_nil
        end
      end

      context 'when user deletes a post' do
        it 'removes post from followers feeds' do
          # ensure it doesn't already exist
          fi = FeedItem.where(user_id: current_user.id,
                              feedable_type: 'Post').first
          expect(fi).to be_nil

          # create notification
          post.save!

          # check that it was added to the feed
          fi = FeedItem.find_feed_item(current_user.id, post)
          expect(fi).to_not be_nil

          # remove post and recheck
          post.destroy
          fi = FeedItem.find_feed_item(current_user.id, post)
          expect(fi).to be_nil
        end
      end
    end

    context 'for PostComments' do
      let!(:post) { create(:post, user: current_user) }
      let!(:commenter) { create(:user) }
      let(:post_comment) { build(:post_comment, post: post, user: commenter) }

      context 'when user adds a comment' do
        it 'adds post comment to posters feed' do
          # ensure it doesn't already exist
          fi = FeedItem.where(user_id: current_user.id,
                              feedable_type: 'PostComment').first
          expect(fi).to be_nil

          # create the post_comment
          post_comment.save!

          # check that it was added to the feed
          fi = FeedItem.find_feed_item(current_user.id, post_comment)
          expect(fi).to_not be_nil
        end
      end

      context 'when user deletes a post' do
        it 'removes post from followers feeds' do
          # ensure it doesn't already exist
          fi = FeedItem.where(user_id: current_user.id,
                              feedable_type: 'PostComment').first
          expect(fi).to be_nil

          # create the post_comment
          post_comment.save!

          # check that it was added to the feed
          fi = FeedItem.find_feed_item(current_user.id, post_comment)
          expect(fi).to_not be_nil

          # remove post and recheck
          post_comment.destroy
          fi = FeedItem.find_feed_item(current_user.id, post_comment)
          expect(fi).to be_nil
        end
      end
    end
  end
end
