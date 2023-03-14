# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_230_324_225_713) do
  create_table 'ad_units', force: :cascade do |t|
    t.string 'ad'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'events', force: :cascade do |t|
    t.integer 'org_id'
    t.string 'title'
    t.string 'description'
    t.datetime 'event_date'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['org_id'], name: 'index_events_on_org_id'
  end

  create_table 'feed_items', force: :cascade do |t|
    t.integer 'user_id'
    t.integer 'feedable_id'
    t.string 'feedable_type'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[feedable_id feedable_type], name: 'fi1'
    t.index %w[user_id feedable_id feedable_type], name: 'fi2'
    t.index ['user_id'], name: 'index_feed_items_on_user_id'
  end

  create_table 'follows', force: :cascade do |t|
    t.integer 'user_id'
    t.integer 'followed_user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['followed_user_id'], name: 'index_follows_on_followed_user_id'
    t.index ['user_id'], name: 'index_follows_on_user_id'
  end

  create_table 'notifications', force: :cascade do |t|
    t.string 'notification'
    t.integer 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_notifications_on_user_id'
  end

  create_table 'orgs', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'post_comments', force: :cascade do |t|
    t.integer 'post_id'
    t.string 'comment'
    t.integer 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['post_id'], name: 'index_post_comments_on_post_id'
    t.index ['user_id'], name: 'index_post_comments_on_user_id'
  end

  create_table 'posts', force: :cascade do |t|
    t.string 'title'
    t.string 'body'
    t.integer 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_posts_on_user_id'
  end

  create_table 'user_orgs', force: :cascade do |t|
    t.integer 'user_id'
    t.integer 'org_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['org_id'], name: 'index_user_orgs_on_org_id'
    t.index ['user_id'], name: 'index_user_orgs_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
