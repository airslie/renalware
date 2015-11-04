Feature: Record the transplant registration for a patient

  A patient requires the transplant of one or many organs: kidney, pancreas or liver. To
  receive a transplant a patient needs to be registered on a wait list.

  Background:
    Given the transplants module is configured
    And Clyde is a clinician
    And Patty is a patient

  @web
  Scenario: A clinician registered a patient on the transplant wait list
    When Clyde registers Patty on the wait list with status "Active" starting on "24-10-2015"
    Then Patty has an active transplant registration since "24-10-2015"

  @web
  Scenario: A clinician updated a patient's registration
    Given Patty is registered on the wait list
    Then Clyde can update Patty's transplant registration

  @web
  Scenario: A clinician submitted an erroneous registration
    When Clyde submits an erroneous registration
    Then the registration is not accepted by the system
    And Clyde is notified of the registration errors
