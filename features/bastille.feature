Feature: Run `bastille`
  In order to view the commands available for this application
  As a user
  I want to have the `bastille` command print a lising of the subcommands it supports

  Scenario: list all subcommands
    When I run `bastille`
    Then the output should contain:
    """
    Tasks:
      bastille help [TASK]   # Describe available tasks or one specific task
      bastille token [TASK]  # Provides the user with tools to create and view th...
      bastille vault [TASK]  # Provides access to your vaults
    """
