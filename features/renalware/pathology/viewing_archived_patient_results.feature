Feature: Viewing archived pathology results for a patient

  A doctor views the archived pathology results for a patient to determine
  trends in physiological parameters over time.

  @wip
  Scenario: Multiple observation results recorded
    Given Patty is a patient
    And the following observations were recorded
      | WBC         | 6.09   |         | 2009-11-11 20:26:00 +0000 |
    Then the doctor views the following archived pathology result report:
      | date       | WBC  |
      | 2009-11-11 | 6.09 |
