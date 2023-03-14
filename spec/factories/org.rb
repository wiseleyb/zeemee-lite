# frozen_string_literal: true

FactoryBot.define do
  factory :org do
    name { FFaker::Venue.name }
  end
end
