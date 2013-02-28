Feature: Run `bastille tokenize`
  In order to generate a valid token set for authenticating with the bastille server
  As a user
  I want to have the `bastille tokenize` command prompt me to authenticate with Github
  And then serialize this the resulting OAuth token and data from Github
  And store that data in a file at ~/.bastille

  Background:
    Given a file named ".bastille" with:
      """
      ---
      :username: mister.happy
      :token: abc123
      :domain: http://localhost:9000
      :name: banana
      """

  Scenario: list subcommands
    When I run `bastille vault`
    Then the output should contain:
      """
      Tasks:
        bastille vault delete [SPACE]:[VAULT] (KEY)       # Deletes the given vault...
        bastille vault get [SPACE]:[VAULT]                # Retrieves the contents ...
        bastille vault help [COMMAND]                     # Describe subcommands or...
        bastille vault list                               # List out existing vaults
        bastille vault set [SPACE]:[VAULT] [KEY]=[VALUE]  # Sets a key in the given...
      """

  Scenario: list existing vaults
    When I run `bastille vault list`
    Then the output should contain:
      """
        mister.happy:
        something:
      """

  Scenario: set and get a key from a vault, list vaults, delete vault
    When I run `bastille vault set mister.happy:test RAILS_ENV=production`
    Then the output should contain:
      """
      "RAILS_ENV => production" has been added to the mister.happy:test vault.
      """
    When I run `bastille vault get mister.happy:test`
    Then the output should contain:
      """
      RAILS_ENV=production
      """
    When I run `bastille vault list`
    Then the output should contain:
      """
        mister.happy:
          test
        something:
      """
    When I run `bastille vault delete mister.happy:test` interactively
    And I wait for output to contain "Are you sure you want to delete the mister.happy:test vault?"
    And I type "yes"
    Then the output should contain "OK!"
    When I run `bastille vault list`
    Then the output should contain:
      """
        mister.happy:
        something:
      """
