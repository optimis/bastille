module Bastille
  module Client
    extend self

    def vaults
      get '/vaults'
    end

    private

    def get(path)
      http :get, path
    end

    def http(method, path)
      if [:get, :post, :put, :delete].include?(method)
        url = domain + path
        respond_to HTTParty.send(method, url)
      end
    end

    def domain
      'http://localhost:9000'
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
      symbolize_keys MultiJson.load(@response.body)
    end

    def success?
      SUCCESS_CODES.include?(@response.code.to_i)
    end

    private

    def symbolize_keys(hash)
      symbolized_keys = hash.keys.map(&:to_sym)
      Hash[symbolized_keys.zip(hash.values)]
    end

  end
end
