module Bastille
  class Server < Sinatra::Base

    get '/vaults' do
      # vaults = {
      #   'optimis' => [
      #     'optimis',
      #     'watchman',
      #     'insight'
      #   ],
      #   'ryanmoran' => [
      #     'banana',
      #     'recon'
      #   ]
      # }
      vaults = { :error => 'We could not authenticate you against these credentials.' }
      status 401
      MultiJson.dump(vaults)
    end

  end
end
