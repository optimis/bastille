module Bastille
  module CLI
    class Token < Thor
      include Common

      def self.usage
        'token [TASK]'
      end

      def self.description
        'Provides the user with tools to create and view their bastille token'
      end

      desc :new, 'Generates an OAuth token from github to authenticate against Bastille'
      def new
        if store.exist?
          say 'Found a local token in ~/.bastille. Aborting new token generation. Run `bastille token delete` and run this command again to generate a new token.', :yellow
        else
          if yes? 'This action will require you to authenticate with Github. Are you sure you want to generate a new token?', :red
            username = ask 'Github username: '
            password = ask 'Password: ' do |q|
              q.echo = false
            end
            domain = ask 'Where is the bastille server?: '
            name   = ask 'What should we call this bastille token? This can be anything: '
            if store.generate(username, password, domain, name)
              say 'Your token has been generated and authorized with github. It is stored in ~/.bastille. <3', :green
            else
              say 'The username and password entered do not match. Sorry. :(', :red
            end
          end
        end
      end

      desc :show, 'Prints your credentials out to the commandline'
      def show
        if store.exist?
          max_number_of_spaces = store.keys.map(&:to_s).sort { |a,b| a.length <=> b.length }.last.length + 1
          store.each do |key, value|
            say "  #{key}#{' ' * (max_number_of_spaces - key.length)}: #{value}"
          end
        else
          say 'There is no token.', :red
        end
      end

      desc :delete, 'Deletes the token'
      def delete
        if yes? 'Are you sure you want to delete your token? This cannot be undone.'
          store.delete!
        end
      end

      desc :validate, 'Validates your token with the bastille server.'
      def validate
        if store.exist?
          say 'Validating your token with the bastille server...', :green
          if store.authenticate
            say 'Your token is valid. \m/', :green
          else
            say "Github says you aren't who you say you are. o_O", :red
          end
        else
          say 'Could not validate your token. There is no token at ~/.bastille. Try running `bastille token new` to generate a new token.', :red
        end
      end
    end
  end
end
