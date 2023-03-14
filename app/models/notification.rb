# frozen_string_literal: true

class Notification < ApplicationRecord
  include Feedable
  belongs_to :user

  def self.rnd_title
    u = User.order('random()').first
    action = %w[created updated removed].sample
    item = ['an event',
            'a party',
            'a communist rally',
            'a circus freak show',
            'a horrible dull activity'].sample
    "#{u.name} #{action} #{item}"
  end
end
