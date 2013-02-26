module Bastille
  module CLI
    class Vault < Thor
      include Common

      def self.usage
        'vault [TASK]'
      end

      def self.description
        'Provides access to your vaults'
      end

      desc :list, 'List out existing vaults'
      def list
        say 'Listing your vaults...'
      end

    end
  end
end
