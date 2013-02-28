Feature: Run `bastille`
  In order to view the commands available for this application
  As a user
  I want to have the `bastille` command print a lising of the subcommands it supports

  Scenario: list all subcommands
    When I run `bastille`
    Then the output should contain "bastille authenticate"
    And the output should contain "bastille credentials"
    And the output should contain "bastille help"
    And the output should contain "bastille token [TASK]"
    And the output should contain "bastille vault [TASK]"
