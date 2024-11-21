@legacy @web
Feature: Set the patient's modality to death

  Background:
    Given Clyde is a clinician
    And that I'm logged in
    And Patty is a patient
    And Patty has the HD modality
    And Patty has a recorded HD profile

  @javascript
  Scenario: Doctor adds a death modality for a patient
    Given I choose to add a modality
    When I select death modality
    Then the patient's HD profile should be deactivated
