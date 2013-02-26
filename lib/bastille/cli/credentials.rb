module Bastille
  module CLI
    class Credentials < Thor
      include Common
      default_task :credentials

      def self.usage
        'credentials'
      end

      def self.description
        'Prints your credentials out to the commandline'
      end

      desc usage, description
      def credentials
        say("Username: #{store.username}")
        say("Token: #{store.token}")
      end

    end
  end
end
