Feature: A user views a patient's demographics
#@wip
  Scenario: User views a patient's demograhics
    Given I have a patient in the database
      And that I'm logged in
      And I've searched for a patient
      And I've selected the patient from the search results
    Then I should see the patient's demographics on their profile page