module Bastille
  class Store

    def exist?
      pathname.exist?
    end

    def generate(username, password)
      @client = Octokit::Client.new(:login => username, :password => password)
      auth = @client.create_authorization(:scopes => [], :note => 'Bastille', :note_url => 'https://optimis-bastille.herokuapp.com')
      record_token(username, auth.token)
      true
    rescue Octokit::Unauthorized
      false
    end

    def record_token(username, token)
      hash = { :username => username, :token => token }
      pathname.open('w+') do |f|
        f.write(YAML.dump(hash))
      end
    end

    def authenticate
      client
      true
    rescue Octokit::Unauthorized
      false
    end

    def member?(organization)
      client.organization_member?(organization, username)
    end

    def client
      @client ||= Octokit::Client.new(:login => username, :oauth => token)
    end

    def username
      store[:username]
    end

    def token
      store[:token]
    end

    def store
      @store ||= begin
        pathname.open('r') do |f|
          YAML.load(f.read)
        end
      end
    end

    def pathname
      @pathname ||= Pathname.new(path)
    end

    def path
      "#{ENV['HOME']}/.bastille"
    end

  end
end
