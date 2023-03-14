# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    notification { Notification.rnd_title }
    user { create(:user) }
  end
end
