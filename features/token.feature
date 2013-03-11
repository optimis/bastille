Feature: Run `bastille token`
  In order to generate a valid token set for authenticating with the bastille server
  As a user
  I want to have the `bastille tokenize` command prompt me to authenticate with Github
  And then serialize this the resulting OAuth token and data from Github
  And store that data in a file at ~/.bastille

  Scenario: list token subcommands
    When I run `bastille token`
    Then the output should contain:
      """
      Tasks:
        bastille token delete          # Deletes the token
        bastille token help [COMMAND]  # Describe subcommands or one specific subco...
        bastille token new             # Generates an OAuth token from github to au...
        bastille token show            # Prints your credentials out to the command...
        bastille token validate        # Validates your token with the bastille ser...
      """

  Scenario: run `token new`, `token validate`, and `token delete`
    When I run `bastille token new` interactively
    And I wait for output to contain "Are you sure you want to generate a new token?"
    And I type "yes"
    And I wait for output to contain "Github username:"
    And I type "mister.happy"
    And I wait for output to contain "Password:"
    And I type "sekret"
    And I wait for output to contain "Where is the bastille server?"
    And I type "http://localhost:9000"
    And I wait for output to contain "What should we call this bastille token?"
    And I type "banana"
    Then the output should not contain "The username and password entered do not match."
    And the exit status should be 0
    And a file named ".bastille" should exist
    When I run `bastille token validate`
    Then the output should contain:
      """
      Validating your token with the bastille server...
      Your token is valid. \m/
      """
    When I run `bastille token delete` interactively
    And I wait for output to contain "Are you sure you want to delete your token? This cannot be undone."
    And I type "yes"
    Then a file named ".bastille" should not exist

  Scenario: run `token show`
    Given a file named ".bastille" with:
      """
      ---
      :username: mister.happy
      :token: abc123
      :domain: http://localhost:9000
      :name: banana
      :key: VTJGc2RHVmtYMTgwMHYzYVowNn
      """
    When I run `bastille token show`
    Then the output should contain:
      """
        domain   : http://localhost:9000
        key      : VTJGc2RHVmtYMTgwMHYzYVowNn
        name     : banana
        token    : abc123
        username : mister.happy
      """
    Then the exit status should be 0

  Scenario: decide not to generate new token
    When I run `bastille token new` interactively
    And I wait for output to contain "Are you sure you want to generate a new token?"
    And I type "no"
    Then the output should not contain "Github username"
    And the exit status should be 0

