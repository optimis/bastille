module Bastille
  class Vault

    def initialize(space)
      @space = space
    end

    def all
      redis.keys
    end

    def get(vault)
      json = redis.get(vault)
      MultiJson.dump(json)
    end

    def set(vault, contents)
      json = MultiJson.load(json)
      redis.set(vault, json)
    end

    def redis
      host = ENV['REDIS_HOST'] || 'localhost'
      port = ENV['REDIS_PORT'] || 6379
      @redis ||= Redis::Namespace.new("BASTILLE:#{@space}", :redis => Redis.new(:host => host, :port => port))
    end

  end
end
