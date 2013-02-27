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
        if (response = Client.vaults).success?
          response.body.each do |owner, vaults|
            say "  #{owner}:"
            vaults.each do |vault|
              say "    #{vault}"
            end
          end
        else
          say response.body.fetch(:error), :red
        end
      end

    end
  end
end
