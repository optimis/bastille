module Bastille
  module Client
    extend self

    def vaults
      {
        'optimis' => [
          'optimis',
          'watchman',
          'insight'
        ]
      }
    end
  end
end
