# frozen_string_literal: true

class Event < ApplicationRecord
  include Feedable

  belongs_to :org
end
