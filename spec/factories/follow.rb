# frozen_string_literal: true

FactoryBot.define do
  factory :follow do
    user { create(:user) }
    followed_user { create(:user) }
  end
end
