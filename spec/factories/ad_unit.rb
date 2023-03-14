# frozen_string_literal: true

FactoryBot.define do
  factory :ad_unit do
    ad { "#{FFaker::Company.name}: #{FFaker::Company.bs}" }
  end
end
