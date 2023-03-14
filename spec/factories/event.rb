# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    title { FFaker::Game.title }
    description { FFaker::BaconIpsum.sentence }
    event_date { rand(4).days.from_now + rand(12).hours }
  end
end
