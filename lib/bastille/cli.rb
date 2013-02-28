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
require 'bastille/cli/token'
require 'bastille/cli/vault'

module Bastille
  module CLI
    class Executable < Thor
      register Authenticate, :authenticate, Authenticate.usage, Authenticate.description
      register Token,        :token,        Token.usage,        Token.description
      register Vault,        :vault,        Vault.usage,        Vault.description
    end
  end
end
