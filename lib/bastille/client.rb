module Bastille
  class Client

    def initialize(store)
      @store = store
    end

    def vaults
      http Request.new(:get, '/vaults')
    end

    def set(space, vault, key, value)
      check_for_cipher!(space, vault)
      contents = get(space, vault).body || {}
      contents.merge!(key => value)
      request  = Request.new(:put, "/vaults/#{space}/#{vault}", @store.key(space, vault), contents)
      http request
    end

    def get(space, vault)
      check_for_cipher!(space, vault)
      key = @store.key(space, vault)
      http Request.new(:get, "/vaults/#{space}/#{vault}", key), key
    end

    def delete(space, vault, key)
      check_for_cipher!(space, vault)
      if key
        contents = get(space, vault).body || {}
        contents.delete(key)
        request  = Request.new(:put, "/vaults/#{space}/#{vault}", @store.key(space, vault), contents)
        http request
      else
        http Request.new(:delete, "/vaults/#{space}/#{vault}")
      end
    end

    def authenticate!
      http Request.new(:get, '/authenticate')
    end

    private

    def check_for_cipher!(space, vault)
      existing_vaults = vaults.body
      if existing_vaults[space] && existing_vaults[space].index(vault) && !@store.key(space, vault, :test)
        raise 'You are trying to access a vault that you do not have a key for. Try adding the cipher to the cipher list in ~/.bastille'
      end
    end

    def http(request, key = nil)
      if [:get, :post, :put, :delete].include?(request.method)
        url = domain + request.path
        options = request.options.merge!(:headers => headers)
        respond_to HTTParty.send(request.method, url, options), key
      end
    end

    def headers
      {
        'X-BASTILLE-USERNAME' => @store.username,
        'X-BASTILLE-TOKEN'    => @store.token
      }
    end

    def domain
      @store.domain
    end

    def respond_to(response, key)
      Response.new(response, key)
    end
  end

  class Request
    attr_reader :method, :path

    def initialize(method, path, key = nil, contents = nil)
      @method   = method
      @path     = path
      @key      = key
      @contents = contents
    end

    def options
      if @contents
        if @key
          cipher   = Gibberish::AES.new(@key)
          contents = MultiJson.dump(@contents)
          contents = cipher.encrypt(contents)
          contents = Base64.encode64(contents)
        end
        { :body => { :contents => contents } }
      else
        {}
      end
    end

  end

  class Response
    SUCCESS_CODES = 200..299

    def initialize(response, key = nil)
      @response = response
      @key      = key
    end

    def body
      contents = @response.body
      if @key && success? && !@response.body.empty?
        cipher   = Gibberish::AES.new(@key)
        contents = Base64.decode64(@response.body)
        contents = cipher.decrypt(contents)
      end
      @body ||= MultiJson.load(contents) unless contents.empty?
    end

    def body=(body)
      @body = body
    end

    def success?
      SUCCESS_CODES.include?(@response.code.to_i)
    end

    def error_message
      body.fetch('error')
    end
  end
end
