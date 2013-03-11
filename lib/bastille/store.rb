module Bastille
  class Store

    def generate(username, password, domain, name)
      @client = Octokit::Client.new(:login => username, :password => password)
      auth = @client.create_authorization(:scopes => [], :note => name, :note_url => domain)
      self.username = username
      self.token    = auth['token']
      self.domain   = domain
      self.name     = name
      self.key      = generate_key
      freeze!
      true
    rescue Octokit::Unauthorized
      false
    end

    def generate_key
      Gibberish::SHA512("#{username}#{Time.now}")
    end

    def authenticate
      response = Client.new(self).authenticate!
      response.success?
    end

    def username
      store.fetch(:username) { raise_key_error :username }
    end

    def username=(username)
      store[:username] = username
    end

    def token
      store.fetch(:token) { raise_key_error :token }
    end

    def token=(token)
      store[:token] = token
    end

    def domain
      store.fetch(:domain) { raise_key_error :domain }
    end

    def domain=(domain)
      store[:domain] = domain
    end

    def name
      store.fetch(:name) { raise_key_error :name }
    end

    def name=(name)
      store[:name] = name
    end

    def key
      store.fetch(:key) { raise_key_error :key }
    end

    def key=(key)
      store[:key] = key
    end

    def freeze!
      pathname.open('w+') do |f|
        f.write(YAML.dump(@store))
      end
      @store = nil
    end

    def thaw!
      exist? ? pathname.open('r') { |f| YAML.load(f.read) } : {}
    end

    def delete!
      pathname.delete
    end

    def raise_key_error(key)
      raise KeyError, "There is no :#{key} key in the ~/.bastille store. Try running `bastille tokenize` to generate a new store with the correct tokens."
    end

    def store
      @store ||= thaw!
    end

    def each(&block)
      store.sort { |(a, _), (b, _)| a.to_s <=> b.to_s }.each(&block)
    end

    def keys
      store.keys
    end

    def pathname
      @pathname ||= Pathname.new(path)
    end

    def exist?
      pathname.exist?
    end

    def path
      ENV['BASTILLE_STORE'] || "#{ENV['HOME']}/.bastille"
    end

  end
end
