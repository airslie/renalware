Feature: Identifying a problem

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web @javascript
  Scenario: A clinician identified a problem
    When Clyde records a problem for Patty
    And records a note for the problem
    Then a problem is recorded for Patty

  @web @javascript
  Scenario: A clinician revised a problem
    Given Clyde recorded a problem for Patty
    Then Clyde can revise the problem

  @web @javascript
  Scenario: A clinician added a note to a problem
    Given Clyde recorded a problem for Patty
    Then Clyde can add a note to the problem
