module Bastille
  class Client

    def initialize(store)
      @store = store
    end

    def vaults
      http :get, '/vaults'
    end

    def set(space, vault, key, value)
      cipher = Gibberish::AES.new(@store.key)
      key    = Base64.encode64(cipher.encrypt(key))
      value  = Base64.encode64(cipher.encrypt(value))
      http :put, "/vaults/#{space}/#{vault}", :body => { :key => key, :value => value }
    end

    def get(space, vault)
      response = http :get, "/vaults/#{space}/#{vault}"
      if response.success?
        decoded = {}
        response.body.each do |key, value|
          cipher = Gibberish::AES.new(@store.key)
          key    = cipher.decrypt(Base64.decode64(key))
          value  = cipher.decrypt(Base64.decode64(value))
          decoded[key] = value
        end
        response.body = decoded
      end
      response
    end

    def delete(space, vault, key)
      if key
        decoded = {}
        response = http :get, "/vaults/#{space}/#{vault}"
        if response.success?
          response.body.each do |k, _|
            cipher = Gibberish::AES.new(@store.key)
            d_key  = cipher.decrypt(Base64.decode64(k))
            decoded[d_key] = k
          end
          response.body = decoded
        end
      end
      options = key ? { :body => { :key => response.body[key] } } : {}
      http :delete, "/vaults/#{space}/#{vault}", options
    end

    def authenticate!
      http :get, '/authenticate'
    end

    private

    def http(method, path, options = {})
      if [:get, :post, :put, :delete].include?(method)
        url = domain + path
        options.merge!(:headers => headers)
        respond_to HTTParty.send(method, url, options)
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

    def respond_to(response)
      Response.new(response)
    end
  end

  class Response
    SUCCESS_CODES = 200..299

    def initialize(response)
      @response = response
    end

    def body
      @body ||= MultiJson.load(@response.body)
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
