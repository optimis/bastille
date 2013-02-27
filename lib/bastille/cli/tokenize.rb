module Bastille
  module CLI
    class Tokenize < Thor
      include Common
      default_task :tokenize

      def self.usage
        'tokenize'
      end

      def self.description
        'Generates an OAuth token from github to authenticate against Bastille'
      end

      desc usage, description
      def tokenize
        say 'Searching for local token...', :green
        if store.exist?
          say 'Found a local token in ~/.bastille. Aborting new token generation. Delete ~/.bastille and run this command again to generate a new token.', :yellow
        else
          say "No local token found. Let's make a new one :)", :yellow
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
    end
  end
end
