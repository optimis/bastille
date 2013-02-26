module Bastille
  class CLI < Thor
    desc :tokenize, 'Generates an OAuth token from github to authenticate against Bastille'
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
          if store.generate(username, password)
            say 'Your token has been generated and authorized with github. It is stored in ~/.bastille. <3', :green
          else
            say 'The username and password entered do not match. Sorry. :(', :red
          end
        end
      end
    end

    desc :authenticate, 'Authenticates your user with Github'
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

    desc :credentials, 'Prints your credentials out to the commandline'
    def credentials
      say("Username: #{store.username}")
      say("Token: #{store.token}")
    end

    private

    def ask(*args, &block)
      highline.ask(*args, &block)
    end

    def store
      @store ||= Store.new
    end

    def highline
      @highline ||= HighLine.new
    end

  end
end
