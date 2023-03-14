# frozen_string_literal: true

# just does some nonsense to test if Sidekiq is working
class TestSidekiqJob
  include Sidekiq::Worker

  # just adds Time.to_f.to_s to specified user-name
  # example
  #   u = User.first
  #   TestSidekiqJob.perform_async(u.id)
  #   puts u.reload.name
  def perform(user_id)
    u = User.find(user_id)
    names = u.name.to_s.split(' ')[0..1]
    names << Time.now.to_f.to_s
    u.name = names.join(' ')
    u.save
  end
end
