require 'multi_json'
require 'octokit'
require 'redis'
require 'redis/namespace'
require 'sinatra'

require 'bastille/hub'
require 'bastille/space'

module Bastille
  class Server < Sinatra::Base
    configure :production, :development do
      enable :logging
      set :raise_errors, Proc.new { false }
      set :show_exceptions, false
    end

    before do
      if authenticated?
        pass
      else
        halt 401, MultiJson.dump(:error => "Github is saying that you aren't who you say you are. Try checking your credentials.")
      end
    end

    not_found do
      status 404
      MultiJson.dump(:error => "Could not find this action on the Bastille server.")
    end

    error do
      MultiJson.dump(:error => "We're sorry. Looks like there was an error processing your request.")
    end

    get '/vaults' do
      json = {}
      spaces.each do |space|
        json[space] = Space.new(space).all
      end
      MultiJson.dump(json)
    end

    put '/vaults/:space/:vault' do
      space = params.fetch('space')
      vault = params.fetch('vault')
      key   = params.fetch('key')
      value = params.fetch('value')

      authorize_space_access!(space)

      space = Space.new(space)
      contents = space.get(vault)
      json = space.set(vault, contents.merge(key => value))
      MultiJson.dump(json)
    end

    get '/vaults/:space/:vault' do
      space = params.fetch('space')
      vault = params.fetch('vault')

      authorize_space_access!(space)

      space = Space.new(space)
      contents = space.get(vault)
      MultiJson.dump(contents)
    end

    delete '/vaults/:space/:vault' do
      space = params.fetch('space')
      vault = params.fetch('vault')
      key   = params['key']

      authorize_space_access!(space)

      space = Space.new(space)
      space.delete(vault, key)
      MultiJson.dump('OK!')
    end

    get '/authenticate' do
      MultiJson.dump('OK!')
    end

    private

    def authenticated?
      logger.info "Authenticating #{username} with Github"
      hub.authenticate!
    end

    def authorize_space_access!(space)
      unless hub.member_of_space?(space)
        error = <<-RESPONSE.gsub(/\s+/, ' ').strip
          Github is saying that you are not the owner of this space.
          Your spaces are #{spaces.inspect}
        RESPONSE

        halt 401, MultiJson.dump(:error => error)
      end
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

    def spaces
      @spaces ||= hub.spaces
    end

  end
end
