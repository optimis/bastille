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

    def organizations
      client.organizations.collect(&:login)
    end

    private

    def client
      raise Octokit::Unauthorized unless @login && @oauth
      @client ||= Octokit::Client.new(:login => @login, :oauth_token => @oauth)
    end

  end
end
