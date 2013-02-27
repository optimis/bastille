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
        max_number_of_spaces = store.keys.sort { |a,b| a.length <=> b.length }.last.length + 1
        store.each do |key, value|
          say "  #{key}#{' ' * (max_number_of_spaces - key.length)}: #{value}"
        end
      end

    end
  end
end
