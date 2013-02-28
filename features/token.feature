Feature: Run `bastille tokenize`
  In order to generate a valid token set for authenticating with the bastille server
  As a user
  I want to have the `bastille tokenize` command prompt me to authenticate with Github
  And then serialize this the resulting OAuth token and data from Github
  And store that data in a file at ~/.bastille

  @announce
  Scenario: run `token new`, `token show`, and `token delete`
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
    When I run `bastille token show`
    Then the output should contain:
      """
        username : mister.happy
        token    : abc123
        domain   : http://localhost:9000
        name     : banana
      """
    Then the exit status should be 0
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

  Scenario: decide not to generate new token
    When I run `bastille token new` interactively
    And I wait for output to contain "Are you sure you want to generate a new token?"
    And I type "no"
    Then the output should not contain "Github username"
    And the exit status should be 0

