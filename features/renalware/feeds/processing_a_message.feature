Feature: Processing a message

  "Health Level-7 or HL7 refers to a set of international standards for
  transfer of clinical and administrative data between software applications
  used by various healthcare providers" -- Wikipedia

  HL7 messages are structured using the following format:

  - segments, one per line
  - fields delimetered by `|`
  - components delimetered by `^`
  - sub components delimitered by `&`

  References:

  - https://corepointhealth.com/resource-center/hl7-resources
  - http://en.wikipedia.org/wiki/Health_Level_7#HL7_version_2.x

  An HL7 message is processed, extracting the pathology results to inform doctors
  about physiological parameters of the patient under their care. An HL7 message
  is sent containing the observation results on completion of the set of observations.

  HL7 messages related to pathology contain:

  - a patient identification
  - an observation request
  - multiple observation results

  After an HL7 message is processed the following records are created:
  - the raw message for future debugging processes
  - the patient if they don't already exist
  - the observation request
  - the observation results related to that request

  Note, this implementation assumes only pathology messages are being sent to the
  application and does not filter other message types.

  @wip
  Scenario: An HL7 message was received
    Given the following HL7 message:
"""
MSH|^~\&|HM|LBE|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||
PID|||Z999990^^^PAS Number||RABBIT^JESSICA^^^MS||19880924|F|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
PV1||Inpatient|NIBC^^^^^^^^|||||MID^KINGS MIDWIVES||||||||||NHS|HXF888888^^^Visit Number|||||||||
ORC|RE|^PCS|09B0099478^LA||CM||||200911111841|||MID^KINGS MIDWIVES|||||||
OBR|1|^PCS|09B0099478^LA|FBC^FULL BLOOD COUNT^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
OBX|1|TX|WBC^WBC^MB||6.09||||||F|||200911112026||BBKA^Kenneth AMENYAH|
OBX|2|TX|RBC^RBC^MB||4.00||||||F|||200911112026||BBKA^Kenneth AMENYAH|
OBX|3|TX|HB^Hb^MB||11.8||||||F|||200911112026||BBKA^Kenneth AMENYAH|
"""
    When the message is processed
    Then the HL7 message is recorded
    And the patient is created with the following attributes:
      | nhs_number       |            |
      | local_patient_id | Z999990    |
      | family_name      | RABBIT     |
      | given_name       | JESSICA    |
      | sex              | Female     |
      | born_on          | 1988-09-24 |
    And an observation request is created with the following attributes:
      | description      | FBC                       |
      | pcs_code         |                           |
      | requestor_name   | MID^KINGS MIDWIVES        |
      | observed_at      | 2009-11-11 18:41:00 +0000 |
    And an observations are created with the following attributes:
      | description | result | comment | observed_at               |
      | WBC         | 6.09   | 6.09    | 2009-11-11 20:26:00 +0000 |
      | RBC         | 4.00   | 4.00    | 2009-11-11 20:26:00 +0000 |
      | HB          | 11.8   | 11.8    | 2009-11-11 20:26:00 +0000 |
