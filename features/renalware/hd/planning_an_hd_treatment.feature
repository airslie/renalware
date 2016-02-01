@wip
Feature: Planning an HD treatment

  A clinician plans an HD treatment for a patient by recording a profile and a set
  of preferences.

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web
  Scenario: A clinician recorded an HD profile for a patient
    When Clyde records an HD profile for Patty
    Then Patty has a new HD profile

  @web
  Scenario: A clinician udpated the HD profile of a patient
    Given Patty has an HD profile
    Then Clyde can update Patty's HD profile

  @web
  Scenario: A clinician submitted an erroneous HD profile for a patient
    When Clyde submits an erroneous HD profile
    Then the HD profile is not accepted