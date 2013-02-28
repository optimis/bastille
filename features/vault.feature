Feature: Run `bastille tokenize`
  In order to generate a valid token set for authenticating with the bastille server
  As a user
  I want to have the `bastille tokenize` command prompt me to authenticate with Github
  And then serialize this the resulting OAuth token and data from Github
  And store that data in a file at ~/.bastille

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
