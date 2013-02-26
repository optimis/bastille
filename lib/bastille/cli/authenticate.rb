module Bastille
  module CLI
    class Authenticate < Thor
      include Common
      default_task :authenticate

      def self.usage
        'authenticate'
      end

      def self.description
        'Authenticates your user with Github'
      end

      desc usage, description
      def authenticate
        if store.exist?
          say 'Authenticating your user with Github...', :green
          organization = nil
          if yes? 'Would you like to authenticate against a specific organization?'
            organization = ask 'Organization: '
          end
          if store.authenticate
            say 'Successfully authenticated with Github. \m/', :green
            if organization
              if store.member?(organization)
                say 'And looks like you are a member for this organization too.', :green
              else
                say "...but, you aren't a member of this organization", :red
              end
            end
          else
            say "Github says you aren't who you say you are. o_O", :red
          end
        else
          say 'Could not authenticate you with Github. There is no token at ~/.bastille. Try running `bastille tokenize` to generate a new token.', :red
        end
      end
    end
  end
end
