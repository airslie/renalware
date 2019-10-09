Feature: Changing the wait list status

  Status changes to a wait list registration are recorded providing a historical log.

  Background:
    Given Clyde is a clinician
    And Chloe is a clinician
    And Patty is a patient
    And Patty is registered on the wait list with this status history
      | status       | start_date  | termination_date | by       |
      | Suspended    | 15-Aug-2015 |                   | Chloe    |
      | Active       | 15-Jul-2015 | 15-Aug-2015       | Chloe    |
      | Transfer Out | 15-Jun-2015 | 15-Jul-2015       | Chloe    |

  @web
  Scenario: A clinician changed the current status of a registration
    When Clyde sets the registration status to "Transplanted" and the start date to "15-Sep-2015"
    Then the registration status history is
      | status       | start_date  | by      | termination_date |
      | Transplanted | 15-Sep-2015 | Clyde   |                  |
      | Suspended    | 15-Aug-2015 | Chloe   | 15-Sep-2015       |
      | Active       | 15-Jul-2015 | Chloe   | 15-Aug-2015       |
      | Transfer Out | 15-Jun-2015 | Chloe   | 15-Jul-2015       |

  Scenario: A clinician recorded retroactively a registration status
    When Clyde sets the registration status to "Died" and the start date to "11-08-2015"
    Then the transplant current status stays "Suspended" since "15-Aug-2015"
    And the status history has the following revised termination dates
      | status       | start_date  | termination_date  |
      | Died         | 11-Aug-2015 | 15-Aug-2015       |
      | Active       | 15-Jul-2015 | 11-Aug-2015       |

  @web
  Scenario: A clinician submitted an erroneous registration status
    When Clyde submits an erroneous registration status
    Then the registration status is not accepted

  Scenario: A clinician submitted a pre-dated registration
    When Clyde submits an pre-dated registration status
    Then the registration status is not accepted
