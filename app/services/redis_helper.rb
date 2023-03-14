# frozen_string_literal: true

# Simple wrapper for Redis - to use shared connections
# List of redis commands: https://redis.io/commands/'
# Usage:
#   RedisHelper.get('some-key')
#   RedisHelper.put('some-key', 'some-value')
class RedisHelper
  class << self
    def method_missing(cmd, *args)
      runcmd(cmd, *args)
    end

    def exists?(key)
      runcmd(:exists, key)
    end

    def runcmd(cmd, *args)
      REDIS.with do |rconn|
        rconn.send(cmd, *args)
      end
    end
  end
end
