# frozen_string_literal: true

FactoryBot.define do
  factory :post_comment do
    post { create(:post) }
    comment { FFaker::HipsterIpsum.sentence }
    user { create(:user) }
  end
end
