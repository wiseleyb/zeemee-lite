# frozen_string_literal: true

pool = ENV['REDIS_POOL'] || 20

REDIS = ConnectionPool.new(size: pool) do
  Redis.new # (host: host, port: port)
end
