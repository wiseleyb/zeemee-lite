# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :ad_units
    resources :events
    resources :feed_items
    resources :follows
    resources :notifications
    resources :orgs
    resources :posts
    resources :post_comments
    resources :users
    resources :user_orgs

    root to: 'ad_units#index'
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :feed_example

  root 'welcome#index'
end
