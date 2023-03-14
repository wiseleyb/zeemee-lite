# frozen_string_literal: true

FactoryBot.define do
  factory :user_org do
    user { create(:user) }
    org { create(:org) }
  end
end
