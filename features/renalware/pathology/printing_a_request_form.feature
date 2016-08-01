Feature: Printing a request form

  A clinician prints a request form and the details of the request are saved.

  The recorded requests are used by the request algorithm to determine if observations are
  required based on the amount of time passed since the last request.

  Background:
    Given Clyde is a clinician
    And Patty is a patient
    And the global rule sets:
      | request_description_code | clinic     | frequency_type |
      | BFF                      | Transplant | Always         |
      | MAL                      | Transplant | Always         |
    And Patty has a recorded patient rule:
      | lab              | Biochemistry  |
      | test_description | Test for HepB |
      | frequency_type   | Always        |
    And Patty has a request form generated with parameters:
      | clinic     | Transplant |
      | consultant | Dr Hibbert |
      | telephone  | 0161932263 |

  Scenario: A clinician prints a request form
    When Clyde prints Patty's request form
    Then Patty has the request recorded:
      | clinic               | Transplant    |
      | consultant           | Dr Hibbert    |
      | telephone            | 0161932263    |
      | request_descriptions | BFF, MAL      |
      | patient_rules        | Test for HepB |
      | created_by           | Clyde         |
