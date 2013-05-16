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
          response.body.sort.each do |owner, vaults|
            say "  #{owner}:"
            vaults.sort.each do |vault|
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
        response = Client.new(store).set(space, vault, key, value)
        if response.success?
          say "\"#{key} => #{value}\" has been added to the #{space}:#{vault} vault.", :green
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
          if response.body.empty?
            say 'There are no keys in this vault.', :yellow
          else
            response.body.sort.each do |key, value|
              say "#{key}=#{value}"
            end
          end
        else
          say response.error_message, :red
        end
      end

      desc 'delete [SPACE]:[VAULT] (KEY)', 'Deletes the given vault, or removes the key from this vault if given.'
      def delete(space_vault, key = nil)
        space, vault = space_vault.split(':')
        return say('Expected a : delimited space and vault argument (ie. defunkt:resque)', :red) unless space && vault

        question = if key.nil?
          "Are you sure you want to delete the #{space}:#{vault} vault?"
        else
          "Are you sure you want to remove the #{key} key from the #{space}:#{vault} vault?"
        end

        if yes?(question)
          response = Client.new(store).delete(space, vault, key)
          if response.success?
            say response.body, :green
          else
            say response.error_message, :red
          end
        else
          say 'OK, nothing was deleted.', :green
        end
      end

    end
  end
end
