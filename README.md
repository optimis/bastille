# Bastille
Bastille is a fortress for your configuration. It is a way to store environment variables
that you can use in your application in a distributable and secure way. Bastille consists
of a few pieces, a server, a command-line client, and a Ruby API that give you the ability
to store and retrieve these environment variables in a simple fashion.

## Installation
Add this line to your application's Gemfile:
    gem 'bastille'

And then execute:
    $ bundle

Or install it yourself as:
    $ gem install bastille

## Usage
Here is what you can do with bastille:

    $ bastille token new
    This action will require you to authenticate with Github. Are you sure you want to generate a new token? yes
    Github username: ryanmoran
    Password:
    Where is the bastille server?: http://localhost:9000
    What should we call this bastille token? This can be anything: bastille
    Your token has been generated and authorized with github. It is stored in ~/.bastille. <3

    $ bastille token show
    username : ryanmoran
    token    : abc123
    domain   : http://localhost:9000
    name     : bastille
    key      : sekret

    $ bastille token validate
    Validating your token with the bastille server...
    Your token is valid. \m/

    $ bastille vault list
    ryanmoran:
    optimis:

    $ bastille vault set ryanmoran:bastille KEY=value
    "KEY => value" has been added to the ryanmoran:bastille vault.

    $ bastille vault list
    ryanmoran:
      bastille
    optimis:

    $ bastille vault get ryanmoran:bastille
    KEY=value

    $ bastille vault set ryanmoran:bastille RAILS_ENV=production
    "RAILS_ENV => production" has been added to the ryanmoran:bastille vault.

    $ bastille vault get ryanmoran:bastille
    KEY=value
    RAILS_ENV=production

    $ bastille vault delete ryanmoran:bastille KEY
    Are you sure you want to remove the KEY key from the ryanmoran:bastille vault? yes
    OK!

    $ bastille vault get ryanmoran:bastille
    RAILS_ENV=production

    $ bastille vault delete ryanmoran:bastille
    Are you sure you want to delete the ryanmoran:bastille vault? yes
    OK!

    $ bastille vault list
    ryanmoran:
    optimis:

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
