require 'bastille/cli/common'
require 'bastille/cli/authenticate'
require 'bastille/cli/credentials'
require 'bastille/cli/tokenize'

module Bastille
  module CLI
    class Executable < Thor
      register Authenticate, :authenticate, Authenticate.usage, Authenticate.description
      register Credentials,  :credentials,  Credentials.usage,  Credentials.description
      register Tokenize,     :tokenize,     Tokenize.usage,     Tokenize.description
    end
  end
end
