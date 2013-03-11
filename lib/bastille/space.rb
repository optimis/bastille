module Bastille
  class Space

    def initialize(space)
      @space = space
    end

    def all
      redis.keys
    end

    def get(vault)
      redis.get(vault)
    end

    def set(vault, contents)
      redis.set(vault, contents)
    end

    def delete(vault)
      redis.del(vault)
    end

    def redis
      host = ENV['REDIS_HOST'] || 'localhost'
      port = ENV['REDIS_PORT'] || 6379
      @redis ||= Redis::Namespace.new("BASTILLE:#{@space}", :redis => Redis.new(:host => host, :port => port))
    end

  end
end
