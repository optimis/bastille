module Bastille
  class Hub

    def initialize(username, token)
      @login = username
      @oauth = token
    end

    def authenticate!
      client.ratelimit
      true
    rescue Octokit::Unauthorized
      false
    end

    def spaces
      [@login] + client.organizations.collect(&:login)
    end

    def member_of_space?(space)
      spaces.include?(space)
    end

    private

    def client
      raise Octokit::Unauthorized unless @login && @oauth
      @client ||= Octokit::Client.new(:login => @login, :oauth_token => @oauth)
    end

  end
end
