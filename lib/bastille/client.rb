module Bastille
  module Client
    extend self

    def vaults
      response = get '/vaults'
      MultiJson.load(response.body)
    end

    private

    def get(path)
      http :get, path
    end

    def http(method, path)
      if [:get, :post, :put, :delete].include?(method)
        url = domain + path
        HTTParty.send(method, url)
      end
    end

    def domain
      'http://localhost:9000'
    end
  end
end
