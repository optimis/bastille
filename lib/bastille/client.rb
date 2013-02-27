module Bastille
  class Client

    def initialize(store)
      @store = store
    end

    def vaults
      http :get, '/vaults'
    end

    def set(space, vault, key, value)
      http :put, "/vaults/#{space}/#{vault}", :body => { :key => key, :value => value }
    end

    def get(space, vault)
      http :get, "/vaults/#{space}/#{vault}"
    end

    def delete(space, vault, key)
      options = key ? { :body => { :key => key } } : {}
      http :delete, "/vaults/#{space}/#{vault}", options
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
      MultiJson.load(@response.body)
    end

    def success?
      SUCCESS_CODES.include?(@response.code.to_i)
    end

    def error_message
      body.fetch('error')
    end
  end
end
