# frozen_string_literal: true

# Simple class to make seed code usable outside db:seeds
require 'csv'

class Seeder
  attr_accessor :steps, :step, :user_count

  def initialize
    @steps = 8
    @step = 0
    @user_count = 10
  end

  def self.run!
    Seeder.new.run!
  end

  def run!
    colleges
    users
    followers
    ads
    events
    notifications
    posts
    feeds
    report
  end

  def colleges
    # Colleges
    puts "#{step_up} Creating Colleges"
    CSV.read('data/colleges.csv').flatten[1..].sample(16).each do |n|
      Org.where(name: n).first_or_create
    end
  end

  def users
    # Users / UserOrgs
    puts "#{step_up} Creating Users/User-Orgs"
    user_count.times do
      u = FactoryBot.create(:user)
      orgs = Org.order('random()').limit(rand(1..4))
      orgs.each do |org|
        rndt = random_date
        uo = UserOrg.where(user_id: u.id, org_id: org.id).first_or_initialize
        uo.created_at = rndt
        uo.updated_at = rndt
        uo.save!
      end
    end
  end

  def followers
    # Friends
    puts "#{step_up} Creating Follow"
    User.find_each do |u|
      friends = User.where.not(id: u.id).order('random()').limit(rand(1..3))
      friends.each do |friend|
        rndt = random_date
        f = Follow.where(user_id: u.id,
                         followed_user_id: friend.id).first_or_initialize
        f.created_at = rndt
        f.updated_at = rndt
        f.save!
      end
    end
  end

  def ads
    # Ad Units
    puts "#{step_up} Creating Ad Units"
    20.times { FactoryBot.create(:ad_unit) }
  end

  def events
    # Events
    puts "#{step_up} Creating Events"
    Org.all.each do |org|
      rand(2..5).times do
        rndt = random_date
        FactoryBot.create(:event,
                          org: org,
                          event_date: rndt,
                          created_at: rndt,
                          updated_at: rndt)
      end
    end
  end

  def notifications
    # Notifications
    puts "#{step_up} Creating Notifications"
    User.find_each do |u|
      rndt = random_date
      FactoryBot.create(:notification,
                        user: u,
                        created_at: rndt,
                        updated_at: rndt)
    end
  end

  def posts
    # Posts / Comments
    puts "#{step_up} Creating Posts/PostComments"
    User.find_each do |u|
      rand(1..4).times do
        rndt = random_date
        p = FactoryBot.create(:post,
                              user: u,
                              created_at: rndt,
                              updated_at: rndt)
        User.order('random()').limit(rand(1..2)).each do |u2|
          rndt2 = Time.at(rndt.to_i + rand(3.days.to_i))
          FactoryBot.create(:post_comment,
                            post: p,
                            user: u2,
                            created_at: rndt2,
                            updated_at: rndt2)
        end
      end
    end
  end

  def feeds
    # Feed Item
    puts "#{step_up} Creating FeedItems"
    FeedService.generate_feeds
  end

  def report
    puts 'Done: Counts...'
    [AdUnit,
     Event,
     FeedItem,
     Follow,
     Notification,
     Org,
     PostComment,
     Post,
     UserOrg,
     User].each do |tbl|
      puts "#{tbl.name}: #{tbl.count}"
    end
  end

  def random_date
    Time.at(0.days.ago.to_i - rand(0.days.ago.to_i - 7.days.ago.to_i))
  end

  def step_up
    self.step += 1
    "#{step}/#{steps}"
  end
end
