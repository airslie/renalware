Feature: Planning an HD treatment

  A clinician plans an HD treatment for a patient by recording a profile and a set
  of preferences.

  Background:
    Given Clyde is a clinician
    And Patty is a patient
    And Patty has the HD modality

  @web
  Scenario: A clinician recorded the HD preferences of a patient
    When Clyde records the HD preferences of Patty
    Then Patty has new HD preferences

  @web
  Scenario: A clinician updated the HD preferences of a patient
    Given Patty has recorded HD preferences
    Then Clyde can update Patty's HD preferences

  @web
  Scenario: A clinician recorded an HD profile for a patient
    When Clyde records an HD profile for Patty
    Then Patty has a new HD profile

  @web
  Scenario: A clinician updated the HD profile of a patient
    Given Patty has a recorded HD profile
    Then Clyde can update Patty's HD profile

  @web
  Scenario: A clinician submitted an erroneous HD profile for a patient
    When Clyde submits an erroneous HD profile
    Then the HD profile is not accepted
