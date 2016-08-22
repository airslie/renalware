Feature: Revising a letter

  A letter may be revised when in "draft" to "typed" state.

  Background:
    Given Nathalie is a nurse
    And Patty is a patient
    And Doug is Patty's doctor

  @web
  Scenario: A nurse revised a letter
    Given Patty has a recorded letter
    Then Nathalie can revise Patty's letter

  @web
  Scenario: A doctor revised a typed letter
    Given Patty has a typed letter
    Then Doug can revise the letter

  Scenario: A doctor marked a typed letter as draft
    Given Patty has a typed letter
    Then Doug can mark the letter as draft
