require 'highline'
require 'httparty'
require 'multi_json'
require 'octokit'
require 'thor'
require 'yaml'

require 'bastille/client'
require 'bastille/store'

require 'bastille/cli/common'
require 'bastille/cli/authenticate'
require 'bastille/cli/credentials'
require 'bastille/cli/tokenize'
require 'bastille/cli/vault'

module Bastille
  module CLI
    class Executable < Thor
      register Authenticate, :authenticate, Authenticate.usage, Authenticate.description
      register Credentials,  :credentials,  Credentials.usage,  Credentials.description
      register Tokenize,     :tokenize,     Tokenize.usage,     Tokenize.description
      register Vault,        :vault,        Vault.usage,        Vault.description
    end
  end
end
