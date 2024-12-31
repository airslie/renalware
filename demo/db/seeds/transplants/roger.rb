module Renalware
  # Set the current DB connection
  connection = ActiveRecord::Base.connection()

  # transplant_recipient_operations
  # transplant_recipient_workups
  # transplant_registrations
  # transplant_registration_statuses

  Rails.benchmark "SQL INSERT Transplant Registration for Roger RABBIT" do
    connection.execute(<<-SQL)
      INSERT INTO transplant_registrations
      (patient_id, referred_on, assessed_on, entered_on,
      contact, notes, document, created_at, updated_at)
      VALUES
      (1, '2016-12-06', '2017-02-13', '2017-02-15',
      'Sister: JESSICA RABBIT 0123 777 888 999', 'Extremely anxious',
      '{"crf": {"latest": {"result": "67", "recorded_on": "2017-02-15"},
      "highest": {"result": "93", "recorded_on": "2017-02-01"}},
      "hla": {"a": {"value_1": "ASDF", "value_2": "JLHJK"},
      "b": {"value_1": "ASFA", "value_2": "DFSDA"},
      "cw": {"value_1": "ADFA", "value_2": "DSFFS"},
      "dq": {"value_1": "SASDF", "value_2": "DFSFS"},
      "dr": {"value_1": "DFSA", "value_2": "FDSDF"},
      "drq": {"value_1": "FDAFS", "value_2": "WEWRE"},
      "drw": {"value_1": "FADSFA", "value_2": "FSFSD"},
      "type": "DFAJ;LSKJ;FKJAS;DKJF;LASJ;FDKJAS;K", "recorded_on": "2017-02-13"},
      "codes": {"uk_transplant_centre_code": "X123",
      "uk_transplant_patient_recipient_number": "987654"},
      "organs": {"rejection_risk": "standard", "transplant_type": "kidney_pancreas",
      "pancreas_only_type": "solid_organ", "also_listed_for_kidney_only": "no",
      "to_be_listed_for_other_organs": "no",
      "received_previous_kidney_or_pancreas_grafts": "no"},
      "transplant": {"blood_group": {"group": "A", "rhesus": "positive"},
      "sens_status": "SADF;LJ;K", "nb_of_previous_grafts": 0}}', '2017-02-23 13:34:24.618171',
      '2017-02-23 13:34:24.618171');
    SQL
  end

  # Note this status seeding causes an error when the next subsequent status
  # is added. I think we need to revert to using AR to create seeds in order to run
  # validations and be more sure data integrity.
  # The error was that Rails could not 'see' this added status for some reason
  # so the next one it tries to add it does so with id=1 and thus we get a duplicate
  # index error from pg.
  # Rails.benchmark "SQL INSERT Transplant Registration Status for Roger RABBIT" do

  #   connection.execute(<<-SQL)
  #     INSERT INTO transplant_registration_statuses
  #     (id, registration_id, description_id, started_on, terminated_on, created_by_id,
  #     updated_by_id, created_at, updated_at)
  #     VALUES
  #     (1, 1, 1, '2017-02-23', NULL, 9, 9,
  #     '2017-02-23 13:34:24.626362', '2017-02-23 13:34:24.626362');
  #   SQL
  # end

  Rails.benchmark "SQL INSERT Transplant Recipient Workup for Roger RABBIT" do
    # Execute a sql statement
    connection.execute(<<-SQL)
      INSERT INTO transplant_recipient_workups
      (patient_id, document, created_at, updated_at, created_by_id, updated_by_id)
      VALUES (1, '{"scores": {
      "prisma": { "result": 2, "recorded_on": "2017-03-24" },
      "karnofsky": { "result": 1, "recorded_on": "2017-03-23" } },
      "hla_data": "FASDF;KJASFDAHSDFKSHFDHASOUOW",
      "education": {"cancer": "yes", "followup": "yes", "infection": "yes",
      "procedure": "yes", "rejection": "yes", "recurrence": "yes",
      "success_rate": "yes", "waiting_list": "yes", "drugs_longterm": "yes",
      "drugs_shortterm": "yes", "transport_benefits": "yes"},
      "examination": {"heart_sounds": "NAD",
      "carotid_bruit": {"left": "no", "right": "no"},
      "femoral_bruit": {"left": "no", "right": "no"},
      "femoral_pulse": {"left": "yes", "right": "yes"},
      "dorsalis_pedis_pulse": {"left": "yes", "right": "yes"},
      "posterior_tibial_pulse": {"left": "yes", "right": "yes"}},
      "historicals": {"tb": "no", "dvt": "no", "reflux": "yes",
      "recurrent_utis": "no", "family_diabetes": "no",
      "neurogenic_bladder": "no"},
      "obstetrics_and_gynaecology": {
        "pregnancies_count": 0,
        "cervical_smear": {"result": "", "recorded_on": ""}},
      "consent": {"value": "full", "full_name": "JANE SUMISU", "consented_on": "2017-02-22"},
      "marginal_consent": {"value": "yes", "full_name": "JANE SUMISU","consented_on": "2017-02-22"},
      "nhb_consent": {"value": "no", "full_name": "JANE SUMISU", "consented_on": "2017-02-21"}}',
      '2017-02-23 13:36:44.271472', '2017-02-23 13:36:44.271472', 1,1);
    SQL
  end

  Rails.benchmark "SQL INSERT Transplant Recipient Operation for Roger RABBIT" do
    connection.execute(<<-SQL)
      INSERT INTO transplant_recipient_operations
      (patient_id, performed_on, theatre_case_start_time, donor_kidney_removed_from_ice_at,
      operation_type, hospital_centre_id, kidney_perfused_with_blood_at, cold_ischaemic_time,
      warm_ischaemic_time, notes, document, created_at, updated_at)
      VALUES (1, '2017-02-23', '08:15:00', '2017-02-23 07:07:00', 'kidney_pancreas', 51,
      '2017-02-23 09:15:00', 5100, 5520, 'Uneventful Tx.', '{"donor":
      {"age": {"unit": "years", "amount": 36}, "hla": "DASFS", "type":
      "cadaver", "gender": "male", "asystolic": "yes",
      "cmv_status": "unknown", "blood_group": {"group": "B", "rhesus": "positive"},
      "kidney_side": "left",
      "hla_mismatch": "WWERW", "kidney_weight": 234, "ethnic_category": "other_european",
      "ukt_notified_at": "2017-02-22T06:07:00.000+00:00", "ukt_donor_number": "54321",
      "organ_donor_register_checked": "yes"},
      "bk_virus": {"notes": "BKV notes here", "results": "NEGATIVE",
      "tested_on": "2017-02-22"}, "recipient": {"cmv_status": "negative",
      "blood_group": {"group": "B", "rhesus": "positive"}, "last_dialysis_on": "2017-02-21",
      "operation_number": 12345},
      "cadaveric_donor": {"death_certified_at": "2017-02-22T19:19:00.000+00:00",
      "ukt_cause_of_death": "trauma_rta_pushbike",
      "cadaveric_donor_type": "non_heart_beating",
      "ukt_cause_of_death_other": "", "warm_ischaemic_time_in_minutes": null},
      "donor_specific_antibodies": {"notes": "DSA notes here", "results": "NEGATIVE",
      "tested_on": "2017-02-22"}}', '2017-02-23 13:41:34.499713',
      '2017-02-23 13:41:34.499713');
    SQL
  end
end
