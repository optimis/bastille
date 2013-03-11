module Bastille
  class Client

    def initialize(store)
      @store = store
    end

    def vaults
      http Request.new(@store, :get, '/vaults')
    end

    def set(space, vault, key, value)
      contents = get(space, vault).body || {}
      contents.merge!(key => value)
      request  = Request.new(@store, :put, "/vaults/#{space}/#{vault}", contents)
      http request
    end

    def get(space, vault)
      http(Request.new(@store, :get, "/vaults/#{space}/#{vault}"), true)
    end

    def delete(space, vault, key)
      if key
        contents = get(space, vault).body || {}
        contents.delete(key)
        request  = Request.new(@store, :put, "/vaults/#{space}/#{vault}", contents)
        http request
      else
        http Request.new(@store, :delete, "/vaults/#{space}/#{vault}")
      end
    end

    def authenticate!
      http Request.new(@store, :get, '/authenticate')
    end

    private

    def http(request, decrypt = false)
      if [:get, :post, :put, :delete].include?(request.method)
        url = domain + request.path
        options = request.options.merge!(:headers => headers)
        respond_to HTTParty.send(request.method, url, options), decrypt
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

    def respond_to(response, decrypt)
      Response.new(@store, response, decrypt)
    end
  end

  class Request
    attr_reader :method, :path

    def initialize(store, method, path, contents = nil)
      @store    = store
      @method   = method
      @path     = path
      @contents = contents
    end

    def options
      if @contents
        cipher   = Gibberish::AES.new(@store.key)
        contents = MultiJson.dump(@contents)
        contents = cipher.encrypt(contents)
        contents = Base64.encode64(contents)
        { :body => { :contents => contents } }
      else
        {}
      end
    end

  end

  class Response
    SUCCESS_CODES = 200..299

    def initialize(store, response, decrypt = false)
      @store    = store
      @response = response
      @decrypt  = decrypt
    end

    def body
      contents = @response.body
      if @decrypt && success? && !@response.body.empty?
        puts @store.key
        cipher   = Gibberish::AES.new(@store.key)
        puts @response.body.inspect
        contents = Base64.decode64(@response.body)
        puts contents
        contents = cipher.decrypt(contents)
        puts contents
      end
      @body ||= MultiJson.load(contents)
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
