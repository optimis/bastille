module Bastille
  class Server < Sinatra::Base
    configure :production, :development do
      enable :logging
    end

    before do
      if authenticated?
        pass
      else
        halt 401, MultiJson.dump(:error => "Github is saying that you aren't who you say you are. Try checking your credentials.")
      end
    end

    get '/vaults' do
      json = {
        'optimis' => [
          'optimis',
          'watchman',
          'insight'
        ],
        'ryanmoran' => [
          'banana',
          'recon'
        ]
      }

      MultiJson.dump(json)
    end

    private

    def authenticated?
      username = env['HTTP_X_BASTILLE_USERNAME']
      token    = env['HTTP_X_BASTILLE_TOKEN']

      logger.info "Authenticating #{username} with Github"
      Authenticator.new(username, token).authenticate!
    end

  end

  class Authenticator

    def initialize(username, token)
      @login = username
      @oauth = token
    end

    def authenticate!
      client.ratelimit
    rescue Octokit::Unauthorized
      false
    end

    def client
      raise Octokit::Unauthorized unless @login && @oauth
      @client ||= Octokit::Client.new(:login => @login, :oauth_token => @oauth)
    end

  end
end
