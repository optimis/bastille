module Bastille
  class Server < Sinatra::Base

    get '/vaults' do
      vaults = {
        'optimis' => [
          'optimis',
          'watchman',
          'insight'
        ],
        'ryanmoran' => [
          'banana',
          'recon'
        ]
      }
      MultiJson.dump(vaults)
    end

  end
end
