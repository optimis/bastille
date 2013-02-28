Feature: Run `bastille tokenize`
  In order to generate a valid token set for authenticating with the bastille server
  As a user
  I want to have the `bastille tokenize` command prompt me to authenticate with Github
  And then serialize this the resulting OAuth token and data from Github
  And store that data in a file at ~/.bastille

  @announce
  Scenario: generate a valid token
    When I run `bastille tokenize` interactively
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
    And a file named ".bastille" should exist
    And the file ".bastille" should contain ":username: mister.happy"
    And the file ".bastille" should contain ":token: abc123"
    And the file ".bastille" should contain ":domain: http://localhost:9000"
    And the file ".bastille" should contain ":name: banana"

