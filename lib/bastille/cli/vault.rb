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
        Client.vaults.each do |owner, vaults|
          say owner
          vaults.each do |vault|
            say "\t#{vault}"
          end
        end
      end

    end
  end
end
