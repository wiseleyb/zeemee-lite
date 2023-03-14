# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { FFaker::Venue.name }
    body { FFaker::Tweet.tweet }
    user { create(:user) }
  end
end
