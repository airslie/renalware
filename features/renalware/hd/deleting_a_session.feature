Feature: Deleting an HD session

  A nurse deletes an HD Session if she finds a duplicate has accidentally been created.

  A session can only be deleted if it not yet signed off.

  Background:
    Given Nathalie is a nurse
    And Patty is a patient

  @web
  Scenario: A nurse deleted an open session
    Given Patty has a recorded HD session with has not yet been signed off
    When Nathalie deletes the session
    Then the session is removed
    And the rolling session statistics for the patient are regenerated

  @web
  Scenario: A nurse deleted a DNA session
    Given Patty has a recorded DNA session
    And the session was created less than 6 hours ago
    When Nathalie deletes the session
    Then the session is removed
    And the rolling session statistics for the patient are regenerated
