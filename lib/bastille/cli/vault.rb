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
        if (response = Client.new(store).vaults).success?
          response.body.each do |owner, vaults|
            say "  #{owner}:"
            vaults.each do |vault|
              say "    #{vault}"
            end
          end
        else
          say response.error_message, :red
        end
      end

      desc 'set [SPACE]:[VAULT] [KEY]=[VALUE]', 'Sets a key in the given vault'
      def set(space_vault, key_value)
        space, vault = space_vault.split(':')
        return say('Expected a : delimited space and vault argument (ie. defunkt:resque)', :red) unless space && vault
        key, value = key_value.split('=')
        return say('Expected a key=value argument (ie. RAILS_ENV=production)', :red) unless key && value

        response = Client.new(store).set(space, vault, key, value)
        if response.success?
          say "\"#{key} => #{response.body.fetch(key)}\" has been added to the #{space}:#{vault} vault.", :green
        else
          say response.error_message, :red
        end
      end

      desc 'get [SPACE]:[VAULT]', 'Retrieves the contents of a given vault'
      def get(space_vault)
        space, vault = space_vault.split(':')
        return say('Expected a : delimited space and vault argument (ie. defunkt:resque)', :red) unless space && vault

        response = Client.new(store).get(space, vault)
        if response.success?
          response.body.sort.each do |key, value|
            say "#{key}=#{value}"
          end
        else
          say response.error_message, :red
        end
      end

    end
  end
end
