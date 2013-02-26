module Bastille
  module CLI
    module Common
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
end
