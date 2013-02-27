require 'multi_json'
require 'octokit'
require 'redis'
require 'redis/namespace'
require 'sinatra'

require 'bastille/hub'
require 'bastille/vault'

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
      json = {}
      vault_spaces.each do |space|
        json[space] = Vault.new(space).all
      end
      MultiJson.dump(json)
    end

    private

    def authenticated?
      logger.info "Authenticating #{username} with Github"
      hub.authenticate!
    end

    def hub
      @hub ||= Hub.new(username, token)
    end

    def username
      @username ||= env['HTTP_X_BASTILLE_USERNAME']
    end

    def token
      @token ||= env['HTTP_X_BASTILLE_TOKEN']
    end

    def vault_spaces
      @vault_spaces ||= [username] + hub.organizations
    end

  end
end
