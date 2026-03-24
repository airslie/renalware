# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_24_112837) do
  create_schema "renalware"

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "public.btree_gist"
  enable_extension "public.intarray"
  enable_extension "public.tablefunc"
  enable_extension "public.uuid-ossp"

  create_enum :access_needling_assessment_difficulties, [
    "easy",
    "moderate",
    "hard",
  ], force: :cascade

  create_enum :background_job_status, [
    "queued",
    "processing",
    "success",
    "failure",
  ], force: :cascade

  create_enum :clinical_body_composition_pre_post_hd, [
    "pre",
    "post",
  ], force: :cascade

  create_enum :duration, [
    "minute",
    "hour",
    "day",
    "week",
    "month",
    "year",
  ], force: :cascade

  create_enum :enum_colour_name, [
    "slate",
    "gray",
    "zinc",
    "neutral",
    "stone",
    "red",
    "orange",
    "amber",
    "yellow",
    "lime",
    "green",
    "emerald",
    "teal",
    "cyan",
    "sky",
    "blue",
    "indigo",
    "violet",
    "purple",
    "fuchsia",
    "pink",
    "rose",
  ], force: :cascade

  create_enum :enum_confidentiality, [
    "normal",
    "restricted",
  ], force: :cascade

  create_enum :enum_feed_log_reason, [
    "number_hit_dob_miss",
  ], force: :cascade

  create_enum :enum_feed_log_type, [
    "close_match",
  ], force: :cascade

  create_enum :enum_hd_slot_request_urgency, [
    "routine",
    "urgent",
    "highly_urgent",
    "allocated",
  ], force: :cascade

  create_enum :enum_hl7_observation_result_status_codes, [
    "C",
    "D",
    "F",
    "I",
    "N",
    "O",
    "P",
    "IP",
    "R",
    "S",
    "U",
    "W",
    "X",
  ], force: :cascade

  create_enum :enum_hl7_orc_order_status, [
    "A",
    "CA",
    "CM",
    "DC",
    "ER",
    "HD",
    "I",
    "IP",
    "RP",
    "SC",
  ], force: :cascade

  create_enum :enum_letters_gp_send_status, [
    "not_applicable",
    "pending",
    "success",
    "failure",
  ], force: :cascade

  create_enum :enum_mesh_api_action, [
    "endpointlookup",
    "handshake",
    "check_inbox",
    "download_message",
    "acknowledge_message",
    "send_message",
  ], force: :cascade

  create_enum :enum_mesh_itk3_response_type, [
    "inf",
    "bus",
    "unknown",
  ], force: :cascade

  create_enum :enum_mesh_message_direction, [
    "outbound",
    "inbound",
  ], force: :cascade

  create_enum :enum_mesh_transmission_status, [
    "pending",
    "success",
    "failure",
    "cancelled",
  ], force: :cascade

  create_enum :enum_patient_landing_page, [
    "accesses",
    "admissions",
    "akcc",
    "clinic_visits",
    "clinical",
    "clinical_summary",
    "demographics",
    "events",
    "hd",
    "letters",
    "low_clearance",
    "modalities",
    "pathology",
    "pd",
    "prescriptions",
    "problems",
    "renal",
    "transplants_donor",
    "transplants_recipient",
    "virology",
  ], force: :cascade

  create_enum :feed_outgoing_document_state, [
    "queued",
    "errored",
    "processed",
  ], force: :cascade

  create_enum :hd_vnd_risk_level_itemised, [
    "0_very_low",
    "0_low",
    "1_low",
    "1_medium",
    "2_medium",
    "2_high",
  ], force: :cascade

  create_enum :hd_vnd_risk_level_overall, [
    "low",
    "medium",
    "high",
  ], force: :cascade

  create_enum :hl7_event_type, [
    "A01",
    "A02",
    "A03",
    "A04",
    "A05",
    "A06",
    "A07",
    "A08",
    "A09",
    "A10",
    "A11",
    "A12",
    "A13",
    "A14",
    "A15",
    "A16",
    "A17",
    "A18",
    "A19",
    "A20",
    "A21",
    "A22",
    "A23",
    "A24",
    "A25",
    "A26",
    "A27",
    "A28",
    "A29",
    "A30",
    "A31",
    "A32",
    "A33",
    "A34",
    "A35",
    "A36",
    "A37",
    "A38",
    "A39",
    "A40",
    "A41",
    "A42",
    "A43",
    "A44",
    "A45",
    "A46",
    "A47",
    "A48",
    "A49",
    "A50",
    "A51",
    "A52",
    "A53",
    "A54",
    "A55",
    "A60",
    "A61",
    "A62",
    "B01",
    "B02",
    "B03",
    "B04",
    "B05",
    "B06",
    "B07",
    "B08",
    "C01",
    "C02",
    "C03",
    "C04",
    "C05",
    "C06",
    "C07",
    "C08",
    "C09",
    "C10",
    "C11",
    "C12",
    "E01",
    "E02",
    "E03",
    "E04",
    "E10",
    "E12",
    "E13",
    "E15",
    "E20",
    "E21",
    "E22",
    "E24",
    "E30",
    "E31",
    "I01",
    "I02",
    "I03",
    "I04",
    "I05",
    "I06",
    "I07",
    "I08",
    "I09",
    "I10",
    "I11",
    "I12",
    "I13",
    "I14",
    "I15",
    "I16",
    "I17",
    "I18",
    "I19",
    "I20",
    "I21",
    "I22",
    "J01",
    "J02",
    "K11",
    "K13",
    "K15",
    "K21",
    "K22",
    "K23",
    "K24",
    "K25",
    "K31",
    "K32",
    "M01",
    "M02",
    "M03",
    "M04",
    "M05",
    "M06",
    "M07",
    "M08",
    "M09",
    "M10",
    "M11",
    "M12",
    "M13",
    "M14",
    "M15",
    "M16",
    "M17",
    "N01",
    "N02",
    "O01",
    "O02",
    "O03",
    "O04",
    "O05",
    "O06",
    "O07",
    "O08",
    "O09",
    "O10",
    "O11",
    "O12",
    "O13",
    "O14",
    "O15",
    "O16",
    "O17",
    "O18",
    "O19",
    "O20",
    "O21",
    "O22",
    "O23",
    "O24",
    "O25",
    "O26",
    "O27",
    "O28",
    "O29",
    "O30",
    "O31",
    "O32",
    "O33",
    "O34",
    "O35",
    "O36",
    "O37",
    "O38",
    "O39",
    "O40",
    "P01",
    "P02",
    "P03",
    "P04",
    "P05",
    "P06",
    "P07",
    "P08",
    "P09",
    "P10",
    "P11",
    "P12",
    "PC1",
    "PC2",
    "PC3",
    "PC4",
    "PC5",
    "PC6",
    "PC7",
    "PC8",
    "PC9",
    "PCA",
    "PCB",
    "PCC",
    "PCD",
    "PCE",
    "PCF",
    "PCG",
    "PCH",
    "PCJ",
    "PCK",
    "PCL",
    "Q01",
    "Q02",
    "Q03",
    "Q05",
    "Q06",
    "Q11",
    "Q13",
    "Q15",
    "Q16",
    "Q17",
    "Q21",
    "Q22",
    "Q23",
    "Q24",
    "Q25",
    "Q26",
    "Q27",
    "Q28",
    "Q29",
    "Q30",
    "Q31",
    "Q32",
    "R01",
    "R02",
    "R04",
    "R21",
    "R22",
    "R23",
    "R24",
    "R25",
    "R26",
    "R30",
    "R31",
    "R32",
    "R33",
    "ROR",
    "S01",
    "S02",
    "S03",
    "S04",
    "S05",
    "S06",
    "S07",
    "S08",
    "S09",
    "S10",
    "S11",
    "S12",
    "S13",
    "S14",
    "S15",
    "S16",
    "S17",
    "S18",
    "S19",
    "S20",
    "S21",
    "S22",
    "S23",
    "S24",
    "S25",
    "S26",
    "S27",
    "S28",
    "S29",
    "S30",
    "S31",
    "S32",
    "S33",
    "S34",
    "S35",
    "S36",
    "S37",
    "T01",
    "T02",
    "T03",
    "T04",
    "T05",
    "T06",
    "T07",
    "T08",
    "T09",
    "T10",
    "T11",
    "T12",
    "U01",
    "U02",
    "U03",
    "U04",
    "U05",
    "U06",
    "U07",
    "U08",
    "U09",
    "U10",
    "U11",
    "U12",
    "U13",
    "V01",
    "V02",
    "V03",
    "V04",
    "W01",
    "W02",
    "Z01",
    "Z02",
    "Z73",
    "Z74",
    "Z75",
    "Z76",
    "Z77",
    "Z78",
    "Z79",
    "Z80",
    "Z81",
    "Z82",
    "Z83",
    "Z84",
    "Z85",
    "Z86",
    "Z87",
    "Z88",
    "Z89",
    "Z90",
    "Z91",
    "Z92",
    "Z93",
    "Z94",
    "Z95",
    "Z96",
    "Z97",
    "Z98",
    "Z99",
  ], force: :cascade

  create_enum :hl7_message_type, [
    "ACK",
    "ADR",
    "ADT",
    "BAR",
    "BPS",
    "BRP",
    "BRT",
    "BTS",
    "CCF",
    "CCI",
    "CCM",
    "CCQ",
    "CCU",
    "CQU",
    "CRM",
    "CSU",
    "DFT",
    "DOC",
    "DSR",
    "EAC",
    "EAN",
    "EAR",
    "EHC",
    "ESR",
    "ESU",
    "INR",
    "INU",
    "LSR",
    "LSU",
    "MDM",
    "MFD",
    "MFK",
    "MFN",
    "MFQ",
    "MFR",
    "NMD",
    "NMQ",
    "NMR",
    "OMB",
    "OMD",
    "OMG",
    "OMI",
    "OML",
    "OMN",
    "OMP",
    "OMS",
    "OPL",
    "OPR",
    "OPU",
    "ORA",
    "ORB",
    "ORD",
    "ORF",
    "ORG",
    "ORI",
    "ORL",
    "ORM",
    "ORN",
    "ORP",
    "ORR",
    "ORS",
    "ORU",
    "OSM",
    "OSQ",
    "OSR",
    "OUL",
    "PEX",
    "PGL",
    "PIN",
    "PMU",
    "PPG",
    "PPP",
    "PPR",
    "PPT",
    "PPV",
    "PRR",
    "PTR",
    "QBP",
    "QCK",
    "QCN",
    "QRY",
    "QSB",
    "QSX",
    "QVR",
    "RAR",
    "RAS",
    "RCI",
    "RCL",
    "RDE",
    "RDR",
    "RDS",
    "RDY",
    "REF",
    "RER",
    "RGR",
    "RGV",
    "ROR",
    "RPA",
    "RPI",
    "RPL",
    "RPR",
    "RQA",
    "RQC",
    "RQI",
    "RQP",
    "RRA",
    "RRD",
    "RRE",
    "RRG",
    "RRI",
    "RSP",
    "RTB",
    "SCN",
    "SDN",
    "SDR",
    "SIU",
    "SLN",
    "SLR",
    "SMD",
    "SQM",
    "SQR",
    "SRM",
    "SRR",
    "SSR",
    "SSU",
    "STC",
    "STI",
    "SUR",
    "TBR",
    "TCR",
    "TCU",
    "UDM",
    "VXQ",
    "VXR",
    "VXU",
    "VXX",
  ], force: :cascade

  create_enum :nursing_experience_level_enum, [
    "very_low",
    "low",
    "medium",
    "high",
    "very_high",
  ], force: :cascade

  create_enum :pathology_chart_axis, [
    "y1",
    "y2",
  ], force: :cascade

  create_enum :patient_merge_message_types, [
    "A34",
    "A40",
    "manual",
  ], force: :cascade

  create_enum :patient_merge_sources, [
    "HL7",
    "manual",
  ], force: :cascade

  create_enum :patient_merge_statuses, [
    "in_progress",
    "completed",
    "failed",
  ], force: :cascade

  create_enum :pd_pet_type, [
    "full",
    "fast",
  ], force: :cascade

  create_enum :problem_date_display_style_enum, [
    "y",
    "my",
    "dmy",
  ], force: :cascade

  create_enum :system_log_group, [
    "users",
    "admin",
    "superadmin",
    "developer",
  ], force: :cascade

  create_enum :system_log_severity, [
    "info",
    "warning",
    "error",
  ], force: :cascade

  create_enum :system_nag_definition_scope, [
    "patient",
    "user",
  ], force: :cascade

  create_enum :system_nag_severity, [
    "none",
    "info",
    "low",
    "medium",
    "high",
  ], force: :cascade

  create_enum :system_view_category, [
    "mdm",
    "report",
  ], force: :cascade

  create_enum :system_view_display_type, [
    "tabular",
  ], force: :cascade

  create_enum :tristate_type, [
    "unknown",
    "no",
    "yes",
  ], force: :cascade

  create_enum :access_needling_assessment_difficulties, [
    "easy",
    "moderate",
    "hard",
  ], force: :cascade

  create_enum :background_job_status, [
    "queued",
    "processing",
    "success",
    "failure",
  ], force: :cascade

  create_enum :clinical_body_composition_pre_post_hd, [
    "pre",
    "post",
  ], force: :cascade

  create_enum :duration, [
    "minute",
    "hour",
    "day",
    "week",
    "month",
    "year",
  ], force: :cascade

  create_enum :enum_colour_name, [
    "slate",
    "gray",
    "zinc",
    "neutral",
    "stone",
    "red",
    "orange",
    "amber",
    "yellow",
    "lime",
    "green",
    "emerald",
    "teal",
    "cyan",
    "sky",
    "blue",
    "indigo",
    "violet",
    "purple",
    "fuchsia",
    "pink",
    "rose",
  ], force: :cascade

  create_enum :enum_confidentiality, [
    "normal",
    "restricted",
  ], force: :cascade

  create_enum :enum_feed_log_reason, [
    "number_hit_dob_miss",
  ], force: :cascade

  create_enum :enum_feed_log_type, [
    "close_match",
  ], force: :cascade

  create_enum :enum_hd_slot_request_urgency, [
    "routine",
    "urgent",
    "highly_urgent",
    "allocated",
  ], force: :cascade

  create_enum :enum_hl7_observation_result_status_codes, [
    "C",
    "D",
    "F",
    "I",
    "N",
    "O",
    "P",
    "IP",
    "R",
    "S",
    "U",
    "W",
    "X",
  ], force: :cascade

  create_enum :enum_hl7_orc_order_status, [
    "A",
    "CA",
    "CM",
    "DC",
    "ER",
    "HD",
    "I",
    "IP",
    "RP",
    "SC",
  ], force: :cascade

  create_enum :enum_letters_gp_send_status, [
    "not_applicable",
    "pending",
    "success",
    "failure",
  ], force: :cascade

  create_enum :enum_mesh_api_action, [
    "endpointlookup",
    "handshake",
    "check_inbox",
    "download_message",
    "acknowledge_message",
    "send_message",
  ], force: :cascade

  create_enum :enum_mesh_itk3_response_type, [
    "inf",
    "bus",
    "unknown",
  ], force: :cascade

  create_enum :enum_mesh_message_direction, [
    "outbound",
    "inbound",
  ], force: :cascade

  create_enum :enum_mesh_transmission_status, [
    "pending",
    "success",
    "failure",
    "cancelled",
  ], force: :cascade

  create_enum :enum_patient_landing_page, [
    "accesses",
    "admissions",
    "akcc",
    "clinic_visits",
    "clinical",
    "clinical_summary",
    "demographics",
    "events",
    "hd",
    "letters",
    "low_clearance",
    "modalities",
    "pathology",
    "pd",
    "prescriptions",
    "problems",
    "renal",
    "transplants_donor",
    "transplants_recipient",
    "virology",
  ], force: :cascade

  create_enum :feed_outgoing_document_state, [
    "queued",
    "errored",
    "processed",
  ], force: :cascade

  create_enum :hd_vnd_risk_level_itemised, [
    "0_very_low",
    "0_low",
    "1_low",
    "1_medium",
    "2_medium",
    "2_high",
  ], force: :cascade

  create_enum :hd_vnd_risk_level_overall, [
    "low",
    "medium",
    "high",
  ], force: :cascade

  create_enum :hl7_event_type, [
    "A01",
    "A02",
    "A03",
    "A04",
    "A05",
    "A06",
    "A07",
    "A08",
    "A09",
    "A10",
    "A11",
    "A12",
    "A13",
    "A14",
    "A15",
    "A16",
    "A17",
    "A18",
    "A19",
    "A20",
    "A21",
    "A22",
    "A23",
    "A24",
    "A25",
    "A26",
    "A27",
    "A28",
    "A29",
    "A30",
    "A31",
    "A32",
    "A33",
    "A34",
    "A35",
    "A36",
    "A37",
    "A38",
    "A39",
    "A40",
    "A41",
    "A42",
    "A43",
    "A44",
    "A45",
    "A46",
    "A47",
    "A48",
    "A49",
    "A50",
    "A51",
    "A52",
    "A53",
    "A54",
    "A55",
    "A60",
    "A61",
    "A62",
    "B01",
    "B02",
    "B03",
    "B04",
    "B05",
    "B06",
    "B07",
    "B08",
    "C01",
    "C02",
    "C03",
    "C04",
    "C05",
    "C06",
    "C07",
    "C08",
    "C09",
    "C10",
    "C11",
    "C12",
    "E01",
    "E02",
    "E03",
    "E04",
    "E10",
    "E12",
    "E13",
    "E15",
    "E20",
    "E21",
    "E22",
    "E24",
    "E30",
    "E31",
    "I01",
    "I02",
    "I03",
    "I04",
    "I05",
    "I06",
    "I07",
    "I08",
    "I09",
    "I10",
    "I11",
    "I12",
    "I13",
    "I14",
    "I15",
    "I16",
    "I17",
    "I18",
    "I19",
    "I20",
    "I21",
    "I22",
    "J01",
    "J02",
    "K11",
    "K13",
    "K15",
    "K21",
    "K22",
    "K23",
    "K24",
    "K25",
    "K31",
    "K32",
    "M01",
    "M02",
    "M03",
    "M04",
    "M05",
    "M06",
    "M07",
    "M08",
    "M09",
    "M10",
    "M11",
    "M12",
    "M13",
    "M14",
    "M15",
    "M16",
    "M17",
    "N01",
    "N02",
    "O01",
    "O02",
    "O03",
    "O04",
    "O05",
    "O06",
    "O07",
    "O08",
    "O09",
    "O10",
    "O11",
    "O12",
    "O13",
    "O14",
    "O15",
    "O16",
    "O17",
    "O18",
    "O19",
    "O20",
    "O21",
    "O22",
    "O23",
    "O24",
    "O25",
    "O26",
    "O27",
    "O28",
    "O29",
    "O30",
    "O31",
    "O32",
    "O33",
    "O34",
    "O35",
    "O36",
    "O37",
    "O38",
    "O39",
    "O40",
    "P01",
    "P02",
    "P03",
    "P04",
    "P05",
    "P06",
    "P07",
    "P08",
    "P09",
    "P10",
    "P11",
    "P12",
    "PC1",
    "PC2",
    "PC3",
    "PC4",
    "PC5",
    "PC6",
    "PC7",
    "PC8",
    "PC9",
    "PCA",
    "PCB",
    "PCC",
    "PCD",
    "PCE",
    "PCF",
    "PCG",
    "PCH",
    "PCJ",
    "PCK",
    "PCL",
    "Q01",
    "Q02",
    "Q03",
    "Q05",
    "Q06",
    "Q11",
    "Q13",
    "Q15",
    "Q16",
    "Q17",
    "Q21",
    "Q22",
    "Q23",
    "Q24",
    "Q25",
    "Q26",
    "Q27",
    "Q28",
    "Q29",
    "Q30",
    "Q31",
    "Q32",
    "R01",
    "R02",
    "R04",
    "R21",
    "R22",
    "R23",
    "R24",
    "R25",
    "R26",
    "R30",
    "R31",
    "R32",
    "R33",
    "ROR",
    "S01",
    "S02",
    "S03",
    "S04",
    "S05",
    "S06",
    "S07",
    "S08",
    "S09",
    "S10",
    "S11",
    "S12",
    "S13",
    "S14",
    "S15",
    "S16",
    "S17",
    "S18",
    "S19",
    "S20",
    "S21",
    "S22",
    "S23",
    "S24",
    "S25",
    "S26",
    "S27",
    "S28",
    "S29",
    "S30",
    "S31",
    "S32",
    "S33",
    "S34",
    "S35",
    "S36",
    "S37",
    "T01",
    "T02",
    "T03",
    "T04",
    "T05",
    "T06",
    "T07",
    "T08",
    "T09",
    "T10",
    "T11",
    "T12",
    "U01",
    "U02",
    "U03",
    "U04",
    "U05",
    "U06",
    "U07",
    "U08",
    "U09",
    "U10",
    "U11",
    "U12",
    "U13",
    "V01",
    "V02",
    "V03",
    "V04",
    "W01",
    "W02",
    "Z01",
    "Z02",
    "Z73",
    "Z74",
    "Z75",
    "Z76",
    "Z77",
    "Z78",
    "Z79",
    "Z80",
    "Z81",
    "Z82",
    "Z83",
    "Z84",
    "Z85",
    "Z86",
    "Z87",
    "Z88",
    "Z89",
    "Z90",
    "Z91",
    "Z92",
    "Z93",
    "Z94",
    "Z95",
    "Z96",
    "Z97",
    "Z98",
    "Z99",
  ], force: :cascade

  create_enum :hl7_message_type, [
    "ACK",
    "ADR",
    "ADT",
    "BAR",
    "BPS",
    "BRP",
    "BRT",
    "BTS",
    "CCF",
    "CCI",
    "CCM",
    "CCQ",
    "CCU",
    "CQU",
    "CRM",
    "CSU",
    "DFT",
    "DOC",
    "DSR",
    "EAC",
    "EAN",
    "EAR",
    "EHC",
    "ESR",
    "ESU",
    "INR",
    "INU",
    "LSR",
    "LSU",
    "MDM",
    "MFD",
    "MFK",
    "MFN",
    "MFQ",
    "MFR",
    "NMD",
    "NMQ",
    "NMR",
    "OMB",
    "OMD",
    "OMG",
    "OMI",
    "OML",
    "OMN",
    "OMP",
    "OMS",
    "OPL",
    "OPR",
    "OPU",
    "ORA",
    "ORB",
    "ORD",
    "ORF",
    "ORG",
    "ORI",
    "ORL",
    "ORM",
    "ORN",
    "ORP",
    "ORR",
    "ORS",
    "ORU",
    "OSM",
    "OSQ",
    "OSR",
    "OUL",
    "PEX",
    "PGL",
    "PIN",
    "PMU",
    "PPG",
    "PPP",
    "PPR",
    "PPT",
    "PPV",
    "PRR",
    "PTR",
    "QBP",
    "QCK",
    "QCN",
    "QRY",
    "QSB",
    "QSX",
    "QVR",
    "RAR",
    "RAS",
    "RCI",
    "RCL",
    "RDE",
    "RDR",
    "RDS",
    "RDY",
    "REF",
    "RER",
    "RGR",
    "RGV",
    "ROR",
    "RPA",
    "RPI",
    "RPL",
    "RPR",
    "RQA",
    "RQC",
    "RQI",
    "RQP",
    "RRA",
    "RRD",
    "RRE",
    "RRG",
    "RRI",
    "RSP",
    "RTB",
    "SCN",
    "SDN",
    "SDR",
    "SIU",
    "SLN",
    "SLR",
    "SMD",
    "SQM",
    "SQR",
    "SRM",
    "SRR",
    "SSR",
    "SSU",
    "STC",
    "STI",
    "SUR",
    "TBR",
    "TCR",
    "TCU",
    "UDM",
    "VXQ",
    "VXR",
    "VXU",
    "VXX",
  ], force: :cascade

  create_enum :nursing_experience_level_enum, [
    "very_low",
    "low",
    "medium",
    "high",
    "very_high",
  ], force: :cascade

  create_enum :pathology_chart_axis, [
    "y1",
    "y2",
  ], force: :cascade

  create_enum :patient_merge_message_types, [
    "A34",
    "A40",
    "manual",
  ], force: :cascade

  create_enum :patient_merge_sources, [
    "HL7",
    "manual",
  ], force: :cascade

  create_enum :patient_merge_statuses, [
    "in_progress",
    "completed",
    "failed",
  ], force: :cascade

  create_enum :pd_pet_type, [
    "full",
    "fast",
  ], force: :cascade

  create_enum :problem_date_display_style_enum, [
    "y",
    "my",
    "dmy",
  ], force: :cascade

  create_enum :system_log_group, [
    "users",
    "admin",
    "superadmin",
    "developer",
  ], force: :cascade

  create_enum :system_log_severity, [
    "info",
    "warning",
    "error",
  ], force: :cascade

  create_enum :system_nag_definition_scope, [
    "patient",
    "user",
  ], force: :cascade

  create_enum :system_nag_severity, [
    "none",
    "info",
    "low",
    "medium",
    "high",
  ], force: :cascade

  create_enum :system_view_category, [
    "mdm",
    "report",
  ], force: :cascade

  create_enum :system_view_display_type, [
    "tabular",
  ], force: :cascade

  create_enum :tristate_type, [
    "unknown",
    "no",
    "yes",
  ], force: :cascade


  create_view "medication_current_prescriptions", sql_definition: <<-SQL
      SELECT mp.id,
      mp.patient_id,
      mp.drug_id,
      mp.treatable_type,
      mp.treatable_id,
      mp.dose_amount,
      mp.dose_unit,
      mp.medication_route_id,
      mp.route_description,
      mp.frequency,
      mp.notes,
      mp.prescribed_on,
      mp.provider,
      mp.created_at,
      mp.updated_at,
      mp.created_by_id,
      mp.updated_by_id,
      mp.administer_on_hd,
      mp.last_delivery_date,
      drugs.name AS drug_name,
      drug_types.code AS drug_type_code,
      drug_types.name AS drug_type_name
     FROM ((((renalware.medication_prescriptions mp
       FULL JOIN renalware.medication_prescription_terminations mpt ON ((mpt.prescription_id = mp.id)))
       JOIN renalware.drugs ON ((drugs.id = mp.drug_id)))
       FULL JOIN renalware.drug_types_drugs ON ((drug_types_drugs.drug_id = drugs.id)))
       FULL JOIN renalware.drug_types ON (((drug_types_drugs.drug_type_id = drug_types.id) AND ((mpt.terminated_on IS NULL) OR (mpt.terminated_on > now())))));
  SQL
  create_view "pathology_current_observations", sql_definition: <<-SQL
      SELECT DISTINCT ON (pathology_observation_requests.patient_id, pathology_observation_descriptions.id) pathology_observations.id,
      pathology_observations.result,
      pathology_observations.comment,
      pathology_observations.observed_at,
      pathology_observations.description_id,
      pathology_observations.request_id,
      pathology_observation_descriptions.code AS description_code,
      pathology_observation_descriptions.name AS description_name,
      pathology_observation_requests.patient_id
     FROM ((renalware.pathology_observations
       LEFT JOIN renalware.pathology_observation_requests ON ((pathology_observations.request_id = pathology_observation_requests.id)))
       LEFT JOIN renalware.pathology_observation_descriptions ON ((pathology_observations.description_id = pathology_observation_descriptions.id)))
    ORDER BY pathology_observation_requests.patient_id, pathology_observation_descriptions.id, pathology_observations.observed_at DESC;
  SQL
  create_view "reporting_pd_audit", sql_definition: <<-SQL
      WITH pd_patients AS (
           SELECT patients.id
             FROM ((renalware.patients
               JOIN renalware.modality_modalities current_modality ON ((current_modality.patient_id = patients.id)))
               JOIN renalware.modality_descriptions current_modality_description ON ((current_modality_description.id = current_modality.description_id)))
            WHERE ((current_modality.ended_on IS NULL) AND (current_modality.started_on <= CURRENT_DATE) AND ((current_modality_description.name)::text = 'PD'::text))
          ), current_regimes AS (
           SELECT pd_regimes.id,
              pd_regimes.patient_id,
              pd_regimes.start_date,
              pd_regimes.end_date,
              pd_regimes.treatment,
              pd_regimes.type,
              pd_regimes.glucose_volume_low_strength,
              pd_regimes.glucose_volume_medium_strength,
              pd_regimes.glucose_volume_high_strength,
              pd_regimes.amino_acid_volume,
              pd_regimes.icodextrin_volume,
              pd_regimes.add_hd,
              pd_regimes.last_fill_volume,
              pd_regimes.tidal_indicator,
              pd_regimes.tidal_percentage,
              pd_regimes.no_cycles_per_apd,
              pd_regimes.overnight_volume,
              pd_regimes.apd_machine_pac,
              pd_regimes.created_at,
              pd_regimes.updated_at,
              pd_regimes.therapy_time,
              pd_regimes.fill_volume,
              pd_regimes.delivery_interval,
              pd_regimes.system_id,
              pd_regimes.additional_manual_exchange_volume,
              pd_regimes.tidal_full_drain_every_three_cycles,
              pd_regimes.daily_volume,
              pd_regimes.assistance_type
             FROM renalware.pd_regimes
            WHERE ((pd_regimes.start_date >= CURRENT_DATE) AND (pd_regimes.end_date IS NULL))
          ), current_apd_regimes AS (
           SELECT current_regimes.id,
              current_regimes.patient_id,
              current_regimes.start_date,
              current_regimes.end_date,
              current_regimes.treatment,
              current_regimes.type,
              current_regimes.glucose_volume_low_strength,
              current_regimes.glucose_volume_medium_strength,
              current_regimes.glucose_volume_high_strength,
              current_regimes.amino_acid_volume,
              current_regimes.icodextrin_volume,
              current_regimes.add_hd,
              current_regimes.last_fill_volume,
              current_regimes.tidal_indicator,
              current_regimes.tidal_percentage,
              current_regimes.no_cycles_per_apd,
              current_regimes.overnight_volume,
              current_regimes.apd_machine_pac,
              current_regimes.created_at,
              current_regimes.updated_at,
              current_regimes.therapy_time,
              current_regimes.fill_volume,
              current_regimes.delivery_interval,
              current_regimes.system_id,
              current_regimes.additional_manual_exchange_volume,
              current_regimes.tidal_full_drain_every_three_cycles,
              current_regimes.daily_volume,
              current_regimes.assistance_type
             FROM current_regimes
            WHERE ((current_regimes.type)::text ~~ '%::APD%'::text)
          ), current_capd_regimes AS (
           SELECT current_regimes.id,
              current_regimes.patient_id,
              current_regimes.start_date,
              current_regimes.end_date,
              current_regimes.treatment,
              current_regimes.type,
              current_regimes.glucose_volume_low_strength,
              current_regimes.glucose_volume_medium_strength,
              current_regimes.glucose_volume_high_strength,
              current_regimes.amino_acid_volume,
              current_regimes.icodextrin_volume,
              current_regimes.add_hd,
              current_regimes.last_fill_volume,
              current_regimes.tidal_indicator,
              current_regimes.tidal_percentage,
              current_regimes.no_cycles_per_apd,
              current_regimes.overnight_volume,
              current_regimes.apd_machine_pac,
              current_regimes.created_at,
              current_regimes.updated_at,
              current_regimes.therapy_time,
              current_regimes.fill_volume,
              current_regimes.delivery_interval,
              current_regimes.system_id,
              current_regimes.additional_manual_exchange_volume,
              current_regimes.tidal_full_drain_every_three_cycles,
              current_regimes.daily_volume,
              current_regimes.assistance_type
             FROM current_regimes
            WHERE ((current_regimes.type)::text ~~ '%::CAPD%'::text)
          )
   SELECT 'APD'::text AS pd_type,
      count(current_apd_regimes.patient_id) AS patient_count,
      0 AS avg_hgb,
      0 AS pct_hgb_gt_100,
      0 AS pct_on_epo,
      0 AS pct_pth_gt_500,
      0 AS pct_phosphate_gt_1_8,
      0 AS pct_strong_medium_bag_gt_1l
     FROM current_apd_regimes
  UNION ALL
   SELECT 'CAPD'::text AS pd_type,
      count(current_capd_regimes.patient_id) AS patient_count,
      0 AS avg_hgb,
      0 AS pct_hgb_gt_100,
      0 AS pct_on_epo,
      0 AS pct_pth_gt_500,
      0 AS pct_phosphate_gt_1_8,
      0 AS pct_strong_medium_bag_gt_1l
     FROM current_capd_regimes
  UNION ALL
   SELECT 'PD'::text AS pd_type,
      count(pd_patients.id) AS patient_count,
      0 AS avg_hgb,
      0 AS pct_hgb_gt_100,
      0 AS pct_on_epo,
      0 AS pct_pth_gt_500,
      0 AS pct_phosphate_gt_1_8,
      0 AS pct_strong_medium_bag_gt_1l
     FROM pd_patients;
  SQL

  create_table "renalware.access_assessments", id: :serial, force: :cascade do |t|
    t.text "comments"
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.jsonb "document"
    t.integer "patient_id"
    t.date "performed_on", null: false
    t.date "procedure_on"
    t.string "side", null: false
    t.integer "type_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_access_assessments_on_created_by_id"
    t.index ["document"], name: "index_access_assessments_on_document", using: :gin
    t.index ["patient_id"], name: "index_access_assessments_on_patient_id"
    t.index ["type_id"], name: "index_access_assessments_on_type_id"
    t.index ["updated_by_id"], name: "index_access_assessments_on_updated_by_id"
  end

  create_table "renalware.access_catheter_insertion_techniques", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "description", null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "renalware.access_needling_assessments", comment: "Stores 'Ease of Needling Vascular Access' aka MAGIC score - see enum", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.enum "difficulty", null: false, enum_type: "access_needling_assessment_difficulties"
    t.bigint "patient_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_access_needling_assessments_on_created_by_id"
    t.index ["patient_id", "created_at"], name: "index_access_needling_assessments_on_patient_id_and_created_at"
    t.index ["patient_id"], name: "index_access_needling_assessments_on_patient_id"
    t.index ["updated_by_id"], name: "index_access_needling_assessments_on_updated_by_id"
  end

  create_table "renalware.access_plan_types", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_access_plan_types_on_deleted_at"
    t.index ["position"], name: "index_access_plan_types_on_position"
  end

  create_table "renalware.access_plans", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.integer "decided_by_id"
    t.text "notes"
    t.integer "patient_id", null: false
    t.integer "plan_type_id", null: false
    t.datetime "terminated_at", precision: nil
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index "patient_id, COALESCE(terminated_at, '1970-01-01 00:00:00'::timestamp without time zone)", name: "access_plan_uniqueness", unique: true
    t.index ["created_by_id"], name: "index_access_plans_on_created_by_id"
    t.index ["decided_by_id"], name: "index_access_plans_on_decided_by_id"
    t.index ["patient_id"], name: "index_access_plans_on_patient_id"
    t.index ["plan_type_id"], name: "index_access_plans_on_plan_type_id"
    t.index ["terminated_at"], name: "index_access_plans_on_terminated_at"
    t.index ["updated_by_id"], name: "index_access_plans_on_updated_by_id"
  end

  create_table "renalware.access_procedures", id: :serial, force: :cascade do |t|
    t.string "catheter_lot_no"
    t.string "catheter_make"
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.date "failed_on"
    t.boolean "first_procedure"
    t.date "first_used_on"
    t.text "notes"
    t.text "outcome"
    t.integer "patient_id"
    t.integer "pd_catheter_insertion_technique_id"
    t.string "performed_by"
    t.date "performed_on", null: false
    t.string "side"
    t.integer "type_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_access_procedures_on_created_by_id"
    t.index ["patient_id"], name: "index_access_procedures_on_patient_id"
    t.index ["pd_catheter_insertion_technique_id"], name: "access_procedure_pd_catheter_tech_idx"
    t.index ["performed_by"], name: "index_access_procedures_on_performed_by"
    t.index ["type_id"], name: "index_access_procedures_on_type_id"
    t.index ["updated_by_id"], name: "index_access_procedures_on_updated_by_id"
  end

  create_table "renalware.access_profiles", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.integer "decided_by_id"
    t.date "formed_on", null: false
    t.text "notes"
    t.integer "patient_id"
    t.string "side", null: false
    t.date "started_on"
    t.date "terminated_on"
    t.integer "type_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_access_profiles_on_created_by_id"
    t.index ["decided_by_id"], name: "index_access_profiles_on_decided_by_id"
    t.index ["patient_id"], name: "index_access_profiles_on_patient_id"
    t.index ["started_on"], name: "index_access_profiles_on_started_on"
    t.index ["terminated_on"], name: "index_access_profiles_on_terminated_on"
    t.index ["type_id"], name: "index_access_profiles_on_type_id"
    t.index ["updated_by_id"], name: "index_access_profiles_on_updated_by_id"
  end

  create_table "renalware.access_sites", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "renalware.access_types", id: :serial, force: :cascade do |t|
    t.string "abbreviation"
    t.datetime "created_at", precision: nil, null: false
    t.boolean "hd_vascular", default: true, null: false
    t.string "name", null: false
    t.string "rr02_code"
    t.string "rr41_code"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "renalware.access_versions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "access_versions_type_id"
  end

  create_table "renalware.active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "renalware.active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.string "content_type"
    t.datetime "created_at", precision: nil, null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "renalware.active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "renalware.activesupport_cache_entries", primary_key: "key", id: :binary, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "expires_at", precision: nil
    t.binary "value", null: false
    t.string "version"
    t.index ["created_at"], name: "index_activesupport_cache_entries_on_created_at"
    t.index ["expires_at"], name: "index_activesupport_cache_entries_on_expires_at"
    t.index ["version"], name: "index_activesupport_cache_entries_on_version"
  end

  create_table "renalware.address_versions", force: :cascade do |t|
    t.datetime "created_at"
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_address_versions_on_item_type_and_item_id"
  end

  create_table "renalware.addresses", id: :serial, force: :cascade do |t|
    t.integer "addressable_id", null: false
    t.string "addressable_type", null: false
    t.integer "country_id"
    t.string "county"
    t.datetime "created_at", precision: nil, null: false
    t.string "email"
    t.string "name"
    t.string "organisation_name"
    t.string "postcode"
    t.text "region"
    t.string "street_1"
    t.string "street_2"
    t.string "street_3"
    t.string "telephone"
    t.string "town"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["addressable_id"], name: "index_addresses_on_addressable_id"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id", unique: true
    t.index ["country_id"], name: "index_addresses_on_country_id"
  end

  create_table "renalware.admission_admissions", force: :cascade do |t|
    t.string "admission_type", null: false
    t.date "admitted_on", null: false
    t.string "bed"
    t.string "building"
    t.string "consultant"
    t.string "consultant_code"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.string "destination_notes"
    t.string "discharge_destination"
    t.text "discharge_summary"
    t.date "discharged_on"
    t.string "feed_id"
    t.string "floor"
    t.bigint "hospital_ward_id", null: false
    t.bigint "modality_at_admission_id"
    t.text "notes"
    t.bigint "patient_id", null: false
    t.text "reason_for_admission", null: false
    t.string "room"
    t.bigint "summarised_by_id"
    t.date "summarised_on"
    t.date "transferred_on"
    t.string "transferred_to"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id", null: false
    t.text "visit_number"
    t.index ["admitted_on"], name: "index_admission_admissions_on_admitted_on"
    t.index ["created_by_id"], name: "index_admission_admissions_on_created_by_id"
    t.index ["deleted_at"], name: "index_admission_admissions_on_deleted_at"
    t.index ["discharged_on"], name: "index_admission_admissions_on_discharged_on"
    t.index ["hospital_ward_id"], name: "index_admission_admissions_on_hospital_ward_id"
    t.index ["modality_at_admission_id"], name: "index_admission_admissions_on_modality_at_admission_id"
    t.index ["patient_id"], name: "index_admission_admissions_on_patient_id"
    t.index ["summarised_by_id"], name: "index_admission_admissions_on_summarised_by_id"
    t.index ["updated_by_id"], name: "index_admission_admissions_on_updated_by_id"
    t.index ["visit_number"], name: "index_admission_admissions_on_visit_number"
  end

  create_table "renalware.admission_consult_sites", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_admission_consult_sites_on_name"
  end

  create_table "renalware.admission_consults", force: :cascade do |t|
    t.string "aki_risk"
    t.bigint "consult_site_id"
    t.string "consult_type"
    t.string "contact_number"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id", null: false
    t.date "decided_on"
    t.text "description"
    t.boolean "e_alert", default: false, null: false
    t.date "ended_on"
    t.bigint "hospital_ward_id"
    t.string "other_site_or_ward"
    t.bigint "patient_id", null: false
    t.integer "priority"
    t.boolean "requires_aki_nurse", default: false, null: false
    t.boolean "rrt", default: false, null: false
    t.bigint "seen_by_id"
    t.bigint "specialty_id"
    t.date "started_on"
    t.string "transfer_priority"
    t.date "transferred_on"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id", null: false
    t.index ["consult_site_id"], name: "index_admission_consults_on_consult_site_id"
    t.index ["created_by_id"], name: "index_admission_consults_on_created_by_id"
    t.index ["hospital_ward_id"], name: "index_admission_consults_on_hospital_ward_id"
    t.index ["patient_id"], name: "index_admission_consults_on_patient_id"
    t.index ["priority"], name: "index_admission_consults_on_priority"
    t.index ["seen_by_id"], name: "index_admission_consults_on_seen_by_id"
    t.index ["specialty_id"], name: "index_admission_consults_on_specialty_id"
    t.index ["updated_by_id"], name: "index_admission_consults_on_updated_by_id"
  end

  create_table "renalware.admission_request_reasons", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "description", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_admission_request_reasons_on_deleted_at"
  end

  create_table "renalware.admission_requests", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.bigint "hospital_unit_id"
    t.text "notes"
    t.bigint "patient_id", null: false
    t.integer "position", default: 0, null: false
    t.string "priority", null: false
    t.integer "reason_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_admission_requests_on_created_by_id"
    t.index ["deleted_at"], name: "index_admission_requests_on_deleted_at"
    t.index ["hospital_unit_id"], name: "index_admission_requests_on_hospital_unit_id"
    t.index ["patient_id", "deleted_at"], name: "index_admission_requests_on_patient_id_and_deleted_at", unique: true
    t.index ["position"], name: "index_admission_requests_on_position"
    t.index ["reason_id"], name: "index_admission_requests_on_reason_id"
    t.index ["updated_by_id"], name: "index_admission_requests_on_updated_by_id"
  end

  create_table "renalware.admission_specialties", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_admission_specialties_on_name", unique: true
  end

  create_table "renalware.admission_versions", force: :cascade do |t|
    t.datetime "created_at"
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_admission_versions_on_item_type_and_item_id"
  end

  create_table "renalware.clinic_appointments", id: :serial, force: :cascade do |t|
    t.integer "becomes_visit_id"
    t.text "clinic_description"
    t.integer "clinic_id", null: false
    t.bigint "consultant_id"
    t.datetime "created_at", precision: nil
    t.bigint "created_by_id"
    t.text "dna_notes"
    t.datetime "ends_at"
    t.string "feed_id"
    t.text "outcome_notes"
    t.integer "patient_id", null: false
    t.text "source_clinic_name", comment: "The name of the clinic in the source system"
    t.datetime "starts_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil
    t.bigint "updated_by_id"
    t.text "visit_number"
    t.index ["clinic_id"], name: "index_clinic_appointments_on_clinic_id"
    t.index ["consultant_id"], name: "index_clinic_appointments_on_consultant_id"
    t.index ["created_by_id"], name: "index_clinic_appointments_on_created_by_id"
    t.index ["patient_id"], name: "index_clinic_appointments_on_patient_id"
    t.index ["updated_by_id"], name: "index_clinic_appointments_on_updated_by_id"
    t.index ["visit_number"], name: "index_clinic_appointments_on_visit_number"
  end

  create_table "renalware.clinic_clinics", id: :serial, force: :cascade do |t|
    t.integer "appointments_count", default: 0
    t.integer "clinic_visits_count", default: 0
    t.string "code"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id"
    t.bigint "default_modality_description_id"
    t.datetime "deleted_at", precision: nil
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id"
    t.integer "user_id"
    t.string "visit_class_name"
    t.index ["code"], name: "index_clinic_clinics_on_code", unique: true, where: "(deleted_at IS NULL)"
    t.index ["created_by_id"], name: "index_clinic_clinics_on_created_by_id"
    t.index ["default_modality_description_id"], name: "index_clinic_clinics_on_default_modality_description_id"
    t.index ["deleted_at"], name: "index_clinic_clinics_on_deleted_at"
    t.index ["updated_by_id"], name: "index_clinic_clinics_on_updated_by_id"
    t.index ["user_id"], name: "index_clinic_clinics_on_user_id"
  end

  create_table "renalware.clinic_consultants", force: :cascade do |t|
    t.integer "appointments_count", default: 0
    t.string "code"
    t.bigint "created_by_id"
    t.datetime "deleted_at", precision: nil
    t.string "name"
    t.string "sds_user_id_deprecated", comment: "Spine Directory Service User ID"
    t.string "telephone"
    t.bigint "updated_by_id"
    t.index ["code"], name: "index_clinic_consultants_on_code", unique: true, where: "(deleted_at IS NULL)"
    t.index ["created_by_id"], name: "index_clinic_consultants_on_created_by_id"
    t.index ["deleted_at"], name: "index_clinic_consultants_on_deleted_at"
    t.index ["name"], name: "index_clinic_consultants_on_name", unique: true, where: "(deleted_at IS NULL)"
    t.index ["sds_user_id_deprecated"], name: "index_clinic_consultants_on_sds_user_id_deprecated", unique: true, where: "(deleted_at IS NULL)"
    t.index ["updated_by_id"], name: "index_clinic_consultants_on_updated_by_id"
  end

  create_table "renalware.clinic_mappings", force: :cascade do |t|
    t.bigint "clinic_id"
    t.datetime "created_at", null: false
    t.boolean "default_clinic", default: false, null: false
    t.string "name_in_feed", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name_in_feed)::text)", name: "index_clinic_mappings_lower_name_in_feed", unique: true, comment: "Case insensitive index on HL7 clinic name"
    t.index ["clinic_id"], name: "index_clinic_mappings_on_clinic_id"
    t.index ["default_clinic"], name: "index_clinic_mappings_on_default_true", unique: true, where: "(default_clinic = true)", comment: "Enforces that there can only be one default clinic"
  end

  create_table "renalware.clinic_versions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "clinic_versions_type_id"
  end

  create_table "renalware.clinic_visit_locations", force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "created_by_id", null: false
    t.boolean "default_location", default: false, null: false
    t.datetime "deleted_at"
    t.string "name", null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_clinic_visit_locations_on_created_by_id"
    t.index ["default_location"], name: "index_clinic_visit_locations_on_default_location", unique: true, where: "((default_location = true) AND (deleted_at IS NULL))"
    t.index ["deleted_at"], name: "index_clinic_visit_locations_on_deleted_at"
    t.index ["name"], name: "index_clinic_visit_locations_on_name", unique: true
    t.index ["updated_by_id"], name: "index_clinic_visit_locations_on_updated_by_id"
  end

  create_table "renalware.clinic_visits", id: :serial, force: :cascade do |t|
    t.text "admin_notes"
    t.decimal "bmi", precision: 10, scale: 1, comment: "Body Mass Index calculated using a before_save when the clinic visit is updated"
    t.decimal "body_surface_area", precision: 8, scale: 2
    t.integer "clinic_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.date "date", null: false
    t.integer "diastolic_bp"
    t.boolean "did_not_attend", default: false, null: false
    t.jsonb "document", default: {}, null: false
    t.float "height"
    t.bigint "location_id"
    t.text "notes"
    t.integer "patient_id"
    t.integer "pulse"
    t.integer "standing_diastolic_bp"
    t.integer "standing_systolic_bp"
    t.integer "systolic_bp"
    t.decimal "temperature", precision: 3, scale: 1
    t.time "time"
    t.decimal "total_body_water", precision: 8, scale: 2
    t.string "type"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.string "urine_blood"
    t.string "urine_glucose"
    t.string "urine_protein"
    t.uuid "uuid", default: -> { "public.uuid_generate_v4()" }
    t.float "weight"
    t.index ["clinic_id"], name: "index_clinic_visits_on_clinic_id"
    t.index ["created_by_id"], name: "index_clinic_visits_on_created_by_id"
    t.index ["document"], name: "index_clinic_visits_on_document", using: :gin
    t.index ["location_id"], name: "index_clinic_visits_on_location_id"
    t.index ["patient_id"], name: "index_clinic_visits_on_patient_id"
    t.index ["type"], name: "index_clinic_visits_on_type"
    t.index ["updated_by_id"], name: "index_clinic_visits_on_updated_by_id"
  end

  create_table "renalware.clinical_allergies", id: :serial, force: :cascade do |t|
    t.integer "created_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.text "description", null: false
    t.integer "patient_id", null: false
    t.datetime "recorded_at", precision: nil, null: false
    t.datetime "updated_at"
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_clinical_allergies_on_created_by_id"
    t.index ["deleted_at"], name: "index_clinical_allergies_on_deleted_at"
    t.index ["patient_id"], name: "index_clinical_allergies_on_patient_id"
    t.index ["updated_by_id"], name: "index_clinical_allergies_on_updated_by_id"
  end

  create_table "renalware.clinical_body_compositions", id: :serial, force: :cascade do |t|
    t.decimal "adipose_tissue_mass", precision: 4, scale: 1, null: false
    t.date "assessed_on", null: false
    t.integer "assessor_id", null: false
    t.decimal "body_cell_mass", precision: 4, scale: 1, null: false
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.decimal "extracellular_water", precision: 4, scale: 1, null: false
    t.decimal "fat_tissue_index", precision: 4, scale: 1, null: false
    t.decimal "fat_tissue_mass", precision: 4, scale: 1, null: false
    t.decimal "intracellular_water", precision: 3, scale: 1, null: false
    t.decimal "lean_tissue_index", precision: 4, scale: 1, null: false
    t.decimal "lean_tissue_mass", precision: 4, scale: 1, null: false
    t.integer "modality_description_id"
    t.text "notes"
    t.decimal "overhydration", precision: 3, scale: 1, null: false
    t.integer "patient_id"
    t.enum "pre_post_hd", enum_type: "clinical_body_composition_pre_post_hd"
    t.decimal "quality_of_reading", precision: 6, scale: 3, null: false
    t.decimal "total_body_water", precision: 4, scale: 1, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.decimal "volume_of_distribution", precision: 4, scale: 1, null: false
    t.float "weight"
    t.index ["assessor_id"], name: "index_clinical_body_compositions_on_assessor_id"
    t.index ["created_by_id"], name: "index_clinical_body_compositions_on_created_by_id"
    t.index ["modality_description_id"], name: "index_clinical_body_compositions_on_modality_description_id"
    t.index ["patient_id"], name: "index_clinical_body_compositions_on_patient_id"
    t.index ["updated_by_id"], name: "index_clinical_body_compositions_on_updated_by_id"
  end

  create_table "renalware.clinical_dry_weights", id: :serial, force: :cascade do |t|
    t.date "assessed_on", null: false
    t.integer "assessor_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.float "maximum_weight", comment: "Set by the clinicial, if the patient's weight rises above this value then the clinican may decide change drugs etc"
    t.float "minimum_weight", comment: "Set by the clinicial, if the patient's weight drops below this value then the clinican may decide change drugs etc"
    t.integer "patient_id"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.float "weight", null: false
    t.index ["assessor_id"], name: "index_clinical_dry_weights_on_assessor_id"
    t.index ["created_by_id"], name: "index_clinical_dry_weights_on_created_by_id"
    t.index ["patient_id", "created_at"], name: "index_clinical_dry_weights_on_patient_id_created_at", order: { created_at: :desc }, comment: "Ordered index to speed up latest dry weight queries"
    t.index ["patient_id"], name: "index_clinical_dry_weights_on_patient_id"
    t.index ["updated_by_id"], name: "index_clinical_dry_weights_on_updated_by_id"
  end

  create_table "renalware.clinical_igan_risks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.bigint "patient_id", null: false
    t.decimal "risk", precision: 5, scale: 2, null: false, comment: "The risk of a 50% decline in estimated GFR or progression to end-stage renal disease 4.2 years after renal biopsy. Calculated using an external website and is a %value eg 40.1%"
    t.text "text", comment: "The calculation output or summary (a block of text) which the user can copy to the clipboard manually from the from the external website, and paste into RW to be saved here. Details the parameters they input as well as the calculated risk"
    t.datetime "updated_at", null: false
    t.bigint "updated_by_id", null: false
    t.text "workings", comment: "The calculation output or summary (a block of text) which the user can copy to the clipboard manually from the from the external website, and paste into RW to be saved here. Details the parameters they input as well as the calculated risk"
    t.index ["created_by_id"], name: "index_clinical_igan_risks_on_created_by_id"
    t.index ["patient_id"], name: "index_clinical_igan_risks_on_patient_id"
    t.index ["updated_by_id"], name: "index_clinical_igan_risks_on_updated_by_id"
  end

  create_table "renalware.clinical_versions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_clinical_versions_on_item_type_and_item_id"
  end

  create_table "renalware.death_causes", id: :serial, force: :cascade do |t|
    t.integer "code"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "description"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_death_causes_on_code", unique: true
  end

  create_table "renalware.death_locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.string "name", null: false
    t.integer "patients_actual_count", default: 0, null: false, comment: "Counter cache for the number of patients who died at this location"
    t.integer "patients_preferred_count", default: 0, null: false, comment: "Counter cache for the number of patients preferring this location"
    t.integer "ukrdc_assessment_outcome_code"
    t.datetime "updated_at", null: false
    t.index "TRIM(BOTH FROM lower((name)::text))", name: "idx_death_locations_name", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_death_locations_on_deleted_at"
  end

  create_table "renalware.delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "attempts", default: 0, null: false
    t.datetime "created_at", precision: nil
    t.datetime "failed_at", precision: nil
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "locked_at", precision: nil
    t.string "locked_by"
    t.integer "priority", default: 0, null: false
    t.string "queue"
    t.datetime "run_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "renalware.directory_people", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.string "family_name", null: false
    t.string "given_name", null: false
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_directory_people_on_created_by_id"
    t.index ["updated_by_id"], name: "index_directory_people_on_updated_by_id"
  end

  create_table "renalware.drug_dmd_actual_medical_products", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "name"
    t.string "trade_family_code"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "virtual_medical_product_code"
    t.index ["code"], name: "index_drug_dmd_actual_medical_products_on_code", unique: true
  end

  create_table "renalware.drug_dmd_matches", force: :cascade do |t|
    t.boolean "approved_trade_family_match", default: false
    t.boolean "approved_vtm_match", default: false, null: false
    t.bigint "drug_id"
    t.string "drug_name"
    t.string "form_name"
    t.integer "prescriptions_count"
    t.string "trade_family_name"
    t.string "vtm_name"
    t.index ["drug_id"], name: "index_drug_dmd_matches_on_drug_id", unique: true
  end

  create_table "renalware.drug_dmd_virtual_medical_products", force: :cascade do |t|
    t.string "active_ingredient_strength_numerator_uom_code", comment: "dm+d name VMP.STRNT_NMRTR_UOMCD"
    t.string "atc_code"
    t.string "basis_of_strength"
    t.string "code", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "form_code"
    t.boolean "inactive", default: false, null: false
    t.string "name"
    t.string "route_code"
    t.string "strength_numerator_value"
    t.string "unit_dose_form_size_uom_code", comment: "dm+d name VMP.UDFS_UOMCD"
    t.string "unit_dose_uom_code", comment: "dm+d name VMP.UNIT_DOSE_UOMCD"
    t.string "unit_of_measure_code_deprecated"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "virtual_therapeutic_moiety_code"
    t.index ["code"], name: "index_drug_dmd_virtual_medical_products_on_code", unique: true
  end

  create_table "renalware.drug_dmd_virtual_therapeutic_moieties", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.boolean "inactive", default: false, null: false
    t.string "name"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "index_drug_dmd_vtm_on_code", unique: true
  end

  create_table "renalware.drug_forms", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "name"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "index_drug_forms_on_code", unique: true
  end

  create_table "renalware.drug_frequencies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "doses_per_week", precision: 5, scale: 2, comment: "Examples: daily = 7, weekly = 1, twice daily = 14, monthly = 0.25"
    t.string "name", null: false
    t.integer "position", default: 1, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_drug_frequencies_on_name", unique: true
    t.index ["position"], name: "index_drug_frequencies_on_position"
  end

  create_table "renalware.drug_homecare_forms", comment: "X-ref table that says which drug_type is supplied by which (homecare) supplier and the data required (see form_name and form_version) to programmatically select and create the right PDF Homecare Supply form for them (using the renalware-forms gem) so this can be printed out and signed.", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "drug_type_id", null: false
    t.string "form_name", null: false, comment: "The lower-case programmatic name used for this provider, eg 'fresenius'"
    t.string "form_version", null: false, comment: "A number e.g. '1' that specified what version of the homecare supply formshould be created"
    t.integer "prescription_duration_default", comment: "The default option to pre-select when displaying prescription_duration_options"
    t.enum "prescription_duration_unit", null: false, comment: "E.g. 'week' or 'month'", enum_type: "duration"
    t.string "prescription_durations", default: [], null: false, comment: "An array of options where each integer is a number of units - these will be displayed as dropdown options presented to the user, and checkboxes on the homecare delivery form PDF. E.g [3,6] will be displayed as options '3 months' and '6 months' (see also prescription_duration_unit)", array: true
    t.bigint "supplier_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["drug_type_id", "supplier_id"], name: "index_drug_homecare_forms_on_drug_type_id_and_supplier_id", unique: true, comment: "A supplier can only have one form active for any drug type"
    t.index ["supplier_id"], name: "index_drug_homecare_forms_on_supplier_id"
  end

  create_table "renalware.drug_patient_group_directions", comment: "Patient group directions (PGDs) are written instructions to help you supply or administer medicines to patients, usually in planned circumstances https://www.gov.uk/government/publications/patient-group-directions-pgds/ patient-group-directions-who-can-use-them", force: :cascade do |t|
    t.string "code", comment: "E.g. DA/57"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.date "ends_on", comment: "The date the PGD is expires e.g. Apr-24-2024"
    t.string "name", null: false, comment: "E.g. Ceftriaxone INJECTION"
    t.integer "position", default: 0, null: false
    t.date "starts_on", comment: "The date the PGD is effective from e.g. Apr-24-2021"
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_drug_patient_group_directions_on_code", unique: true, where: "((ends_on IS NULL) AND (deleted_at IS NULL))"
  end

  create_table "renalware.drug_suppliers", comment: "A list of suppliers who deliver drugs eg for homecare", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false, comment: "The providers display name e.g. 'Fresenius'"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "renalware.drug_trade_families", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "name"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "index_drug_trade_families_on_code", unique: true
  end

  create_table "renalware.drug_trade_family_classifications", force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "drug_id", null: false
    t.boolean "enabled", default: false, null: false
    t.bigint "trade_family_id", null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["drug_id", "trade_family_id"], name: "index_drug_trade_family_class_on_drug_id_and_trade_family", unique: true
    t.index ["drug_id"], name: "index_drug_trade_family_classifications_on_drug_id"
    t.index ["trade_family_id"], name: "index_drug_trade_family_classifications_on_trade_family_id"
  end

  create_table "renalware.drug_types", id: :serial, force: :cascade do |t|
    t.string "atc_codes", array: true
    t.string "code", null: false
    t.enum "colour", comment: "A CSS colour e.f. '#A12A12'", enum_type: "enum_colour_name"
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false, comment: "Controls display order"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "weighting", default: 0, null: false, comment: "More important drug types have a higher value so their colour trumps other types a drug might have."
    t.index ["code"], name: "index_drug_types_on_code", unique: true
    t.index ["name"], name: "index_drug_types_on_name", unique: true
  end

  create_table "renalware.drug_types_drugs", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "drug_id", null: false
    t.integer "drug_type_id", null: false
    t.datetime "updated_at", precision: nil
    t.index ["drug_id", "drug_type_id"], name: "index_drug_types_drugs_on_drug_id_and_drug_type_id", unique: true
    t.index ["drug_type_id"], name: "index_drug_types_drugs_on_drug_type_id"
  end

  create_table "renalware.drug_unit_of_measures", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "name"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "index_drug_unit_of_measures_on_code", unique: true
  end

  create_table "renalware.drug_versions", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_drug_versions_on_item_type_and_item_id"
  end

  create_table "renalware.drug_vmp_classifications", force: :cascade do |t|
    t.bigint "active_ingredient_strength_numerator_uom_id"
    t.string "code", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "drug_id", null: false
    t.bigint "form_id"
    t.boolean "inactive", default: false, null: false
    t.bigint "route_id"
    t.integer "trade_family_ids", default: [], array: true
    t.bigint "unit_dose_form_size_uom_id"
    t.bigint "unit_dose_uom_id"
    t.bigint "unit_of_measure_id"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["active_ingredient_strength_numerator_uom_id"], name: "index_drug_vmp_classifications_on_active_ing_st_num_uom_id"
    t.index ["code"], name: "index_drug_vmp_classifications_on_code", unique: true
    t.index ["drug_id"], name: "index_drug_vmp_classifications_on_drug_id"
    t.index ["form_id"], name: "index_drug_vmp_classifications_on_form_id"
    t.index ["route_id"], name: "index_drug_vmp_classifications_on_route_id"
    t.index ["unit_dose_form_size_uom_id"], name: "index_drug_vmp_classifications_on_unit_dose_form_size_uom_id"
    t.index ["unit_dose_uom_id"], name: "index_drug_vmp_classifications_on_unit_dose_uom_id"
    t.index ["unit_of_measure_id"], name: "index_drug_vmp_classifications_on_unit_of_measure_id"
  end

  create_table "renalware.drugs", id: :serial, force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "deleted_at", precision: nil
    t.string "description"
    t.boolean "inactive", default: false, null: false
    t.string "name", null: false
    t.string "read_code"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_drugs_on_code", unique: true
    t.index ["deleted_at"], name: "index_drugs_on_deleted_at"
  end

  create_table "renalware.event_categories", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "name", null: false
    t.integer "position", default: 10, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_event_categories_on_deleted_at"
    t.index ["name"], name: "index_event_categories_on_name", unique: true
  end

  create_table "renalware.event_subtypes", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id", null: false
    t.datetime "deactivated_at", precision: nil
    t.jsonb "definition", default: "{}", null: false
    t.text "description"
    t.bigint "event_type_id", null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false, comment: "The order of the subtype within an event type, if >1 subtypes"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_event_subtypes_on_created_by_id"
    t.index ["deactivated_at"], name: "index_event_subtypes_on_deactivated_at"
    t.index ["event_type_id"], name: "index_event_subtypes_on_event_type_id"
    t.index ["updated_by_id"], name: "index_event_subtypes_on_updated_by_id"
  end

  create_table "renalware.event_type_alert_triggers", comment: "Matching alerts are displayed on patient pages", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "event_type_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "when_event_description_contains"
    t.text "when_event_document_contains"
    t.index ["event_type_id"], name: "index_event_type_alert_triggers_on_event_type_id"
  end

  create_table "renalware.event_types", id: :serial, force: :cascade do |t|
    t.integer "admin_change_window_hours", default: 0, null: false, comment: "Period post-creation within which an event of this type can be edited by an admin (or superadmin if superadmin_can_always_change is false"
    t.integer "author_change_window_hours", default: 0, null: false, comment: "Period post-creation within which an event of this type can be edited by the author"
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "event_class_name"
    t.integer "events_count", default: 0, null: false, comment: "Counter cache column which Rails will update and which stores the count of events created with this type"
    t.string "external_document_type_code", comment: "A code eg 'MDT' used as metadata when renderimg the event to a PDF"
    t.string "external_document_type_description", comment: "See comment for external_document_type_code"
    t.boolean "hidden", default: false, null: false
    t.string "name", null: false
    t.boolean "save_pdf_to_electronic_public_register", default: false, null: false
    t.string "slug"
    t.boolean "superadmin_can_always_change", default: true, null: false
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["category_id"], name: "index_event_types_on_category_id"
    t.index ["deleted_at"], name: "index_event_types_on_deleted_at"
    t.index ["hidden"], name: "index_event_types_on_hidden"
    t.index ["slug"], name: "index_event_types_on_slug", unique: true
  end

  create_table "renalware.event_versions", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_event_versions_on_item_type_and_item_id"
  end

  create_table "renalware.events", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.datetime "date_time", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "description"
    t.jsonb "document"
    t.integer "event_type_id"
    t.text "notes"
    t.integer "patient_id", null: false
    t.bigint "subtype_id"
    t.string "type", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false, comment: "A unique identifier for this event, used for external references eg HL7"
    t.index "date(created_at) DESC NULLS LAST", name: "index_events_on_created_at_as_date"
    t.index ["created_at"], name: "index_events_on_created_at", order: :desc
    t.index ["created_by_id"], name: "index_events_on_created_by_id"
    t.index ["date_time"], name: "index_events_on_date_time_desc_nulls_last", order: "DESC NULLS LAST"
    t.index ["deleted_at"], name: "index_events_on_deleted_at"
    t.index ["event_type_id"], name: "index_events_on_event_type_id"
    t.index ["patient_id", "deleted_at"], name: "index_events_on_patient_id_not_deleted", where: "(deleted_at IS NULL)", comment: "conditional index to speed up count()ing a patient's undeleted events"
    t.index ["patient_id"], name: "index_events_on_patient_id"
    t.index ["subtype_id"], name: "index_events_on_subtype_id"
    t.index ["type"], name: "index_events_on_type"
    t.index ["updated_at"], name: "index_events_on_updated_at", order: :desc
    t.index ["updated_by_id"], name: "index_events_on_updated_by_id"
    t.index ["uuid"], name: "index_events_on_uuid", unique: true
  end

  create_table "renalware.feed_file_types", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.text "description", null: false
    t.string "download_url"
    t.string "download_url_title"
    t.boolean "enabled", default: true, null: false
    t.string "filename_validation_pattern", default: ".*", null: false
    t.string "name", null: false
    t.text "prompt", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_feed_file_types_on_name"
  end

  create_table "renalware.feed_files", id: :serial, force: :cascade do |t|
    t.integer "attempts", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.integer "file_type_id", null: false
    t.string "location", null: false
    t.text "result"
    t.integer "status", default: 0, null: false
    t.integer "time_taken"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id"
    t.index ["created_by_id"], name: "index_feed_files_on_created_by_id"
    t.index ["file_type_id"], name: "index_feed_files_on_file_type_id"
    t.index ["updated_by_id"], name: "index_feed_files_on_updated_by_id"
  end

  create_table "renalware.feed_gps", force: :cascade do |t|
    t.text "code", null: false
    t.text "county"
    t.text "name", null: false
    t.text "postcode"
    t.string "status"
    t.text "street_1"
    t.text "street_2"
    t.text "street_3"
    t.text "telephone"
    t.text "town"
    t.index ["code"], name: "index_feed_gps_on_code", unique: true
  end

  create_table "renalware.feed_hl7_test_messages", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_feed_hl7_test_messages_on_name"
  end

  create_table "renalware.feed_logs", comment: "Stores links to a feed_message and a candidate/close-matched patient where eg a patient with the incoming nhs_number is found but their DOB differs. This allows an admin to review the log and diagnose the issue.", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.enum "event_type", enum_type: "hl7_event_type"
    t.enum "log_reason", null: false, enum_type: "enum_feed_log_reason"
    t.enum "log_type", null: false, enum_type: "enum_feed_log_type"
    t.bigint "message_id"
    t.enum "message_type", enum_type: "hl7_message_type"
    t.text "note"
    t.bigint "patient_id"
    t.datetime "updated_at", null: false
    t.index ["log_reason"], name: "index_feed_logs_on_log_reason"
    t.index ["log_type"], name: "index_feed_logs_on_log_type"
    t.index ["message_id"], name: "index_feed_logs_on_message_id"
    t.index ["patient_id"], name: "index_feed_logs_on_patient_id"
  end

  create_table "renalware.feed_message_replays", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error_message"
    t.bigint "message_id", null: false
    t.bigint "replay_request_id", null: false
    t.boolean "success", default: false, null: false
    t.datetime "updated_at", null: false
    t.string "urn"
    t.index ["message_id"], name: "index_feed_message_replays_on_message_id"
    t.index ["replay_request_id"], name: "index_feed_message_replays_on_replay_request_id"
    t.index ["urn"], name: "index_feed_message_replays_on_urn"
  end

  create_table "renalware.feed_messages", id: :serial, force: :cascade do |t|
    t.text "body", null: false
    t.text "body_hash"
    t.datetime "created_at", precision: nil, null: false
    t.date "dob"
    t.string "event_code_deprecated"
    t.enum "event_type", enum_type: "hl7_event_type"
    t.string "header_id", null: false
    t.string "local_patient_id"
    t.string "local_patient_id_2"
    t.string "local_patient_id_3"
    t.string "local_patient_id_4"
    t.string "local_patient_id_5"
    t.enum "message_type", enum_type: "hl7_message_type"
    t.string "nhs_number"
    t.string "orc_filler_order_number"
    t.enum "orc_order_status", enum_type: "enum_hl7_orc_order_status"
    t.jsonb "patient_identifiers", default: {}, null: false
    t.boolean "processed", default: false
    t.string "result_thread_key", comment: "A key to identify messages that are part of the same result thread, where the result thread\nis _basically_ ORC placer order number, but we prefix it with the sending app identifier\nfrom MSH-4, and suffix it with the fist OBR observation request identifier (OBR-4).\nie LAB1:123445:UE\nThe reasoning behind is that we need to be able to group the 'same' OUR^R01 message as it\nprogresses through its states (orc order status A -> IP -> CM) so we can remove all but the\nfinal CM message (there can be >1 CM) in a housekeeping SQL function.\nWe cannot use ORC filler order number for this as it spans multiple messages. So we\nuse placer order number which is unique per OBR, but pre-and suffix it as above to\nguarantee uniqueness.\n"
    t.datetime "sent_at"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["body_hash"], name: "index_feed_messages_on_body_hash", unique: true
    t.index ["created_at"], name: "index_feed_messages_created_at_nonauto", order: :desc
    t.index ["dob"], name: "index_feed_messages_on_dob"
    t.index ["local_patient_id"], name: "index_feed_messages_on_local_patient_id"
    t.index ["local_patient_id_2"], name: "index_feed_messages_on_local_patient_id_2"
    t.index ["local_patient_id_3"], name: "index_feed_messages_on_local_patient_id_3"
    t.index ["local_patient_id_4"], name: "index_feed_messages_on_local_patient_id_4"
    t.index ["local_patient_id_5"], name: "index_feed_messages_on_local_patient_id_5"
    t.index ["message_type", "event_type"], name: "index_feed_messages_on_message_type_event_type"
    t.index ["nhs_number"], name: "index_feed_messages_on_nhs_number"
    t.index ["orc_filler_order_number"], name: "index_feed_messages_on_orc_filler_order_number"
    t.index ["patient_identifiers"], name: "index_feed_messages_on_patient_identifiers", using: :gin
    t.index ["result_thread_key"], name: "index_feed_messages_on_result_thread_key"
    t.index ["sent_at"], name: "index_feed_messages_on_sent_at"
  end

  create_table "renalware.feed_msg_queue", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "feed_msg_id", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_msg_id"], name: "index_feed_msg_queue_on_feed_msg_id", unique: true
  end

  create_table "renalware.feed_msgs", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.date "dob"
    t.enum "event_type", null: false, enum_type: "hl7_event_type"
    t.string "local_patient_id"
    t.string "local_patient_id_2"
    t.string "local_patient_id_3"
    t.string "local_patient_id_4"
    t.string "local_patient_id_5"
    t.string "message_control_id"
    t.enum "message_type", null: false, enum_type: "hl7_message_type"
    t.string "nhs_number"
    t.string "orc_filler_order_number"
    t.enum "orc_order_status", enum_type: "enum_hl7_orc_order_status"
    t.datetime "processed_at", precision: nil
    t.datetime "sent_at", precision: nil, null: false
    t.datetime "updated_at", null: false
    t.integer "version", default: 1, null: false
    t.index ["message_control_id"], name: "index_feed_msgs_on_message_control_id"
    t.index ["orc_filler_order_number"], name: "index_feed_msgs_on_orc_filler_order_number"
    t.index ["sent_at"], name: "index_feed_msgs_on_sent_at"
  end

  create_table "renalware.feed_outgoing_documents", comment: "A queue of documents (letters, events) that require processing by an external system e.g. Mirth. For example when a letter is approved, a hospital's Renalware host app may listener for that event and write a row to this table, including the (polymorphic) details of the document (in this case the class name and id of the letter). When Mirth or the external system queries the Renalware API for for waiting queued documents, it will return documents referenced here that have a state of 'queued'. The renderable relation must implement the expected methods required to render to the requested format e.g. HL7 (and in the future FHIR).", force: :cascade do |t|
    t.text "comments"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id", null: false
    t.text "error"
    t.string "error_code"
    t.datetime "errored_at", precision: nil
    t.uuid "external_uuid", default: -> { "gen_random_uuid()" }, comment: "E.g. the Mirth message id"
    t.json "printing_options", default: {}
    t.bigint "renderable_id", null: false, comment: "The letter/event/etc to be processed"
    t.string "renderable_type", null: false
    t.datetime "retried_at", precision: nil
    t.enum "state", default: "queued", null: false, enum_type: "feed_outgoing_document_state"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_feed_outgoing_documents_on_created_by_id"
    t.index ["external_uuid"], name: "index_feed_outgoing_documents_on_external_uuid", unique: true
    t.index ["renderable_type", "renderable_id"], name: "index_feed_outgoing_documents_on_renderable"
    t.index ["updated_by_id"], name: "index_feed_outgoing_documents_on_updated_by_id"
  end

  create_table "renalware.feed_practice_gps", force: :cascade do |t|
    t.text "gp_code", null: false
    t.date "joined_on"
    t.date "left_on"
    t.text "practice_code", null: false
    t.integer "practice_id"
    t.integer "primary_care_physician_id"
  end

  create_table "renalware.feed_raw_hl7_message_errors", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.text "error_message"
    t.text "error_message_backtrace"
    t.datetime "sent_at", null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["sent_at"], name: "index_feed_raw_hl7_message_errors_on_sent_at"
  end

  create_table "renalware.feed_raw_hl7_messages", force: :cascade do |t|
    t.string "body"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "sent_at"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["created_at"], name: "index_feed_raw_hl7_messages_on_created_at", comment: "We query for rows ordering by created_at asc to give us a chance to process in FIFO order, so having an ordered index means when we use a LIMIT (batching) in the query, rows will be determined by index scan without having to look to the end of the table - or something like that! In fact the index is implicitly ordered already but having created_at: :asc here makes our intention more explicit."
    t.index ["sent_at"], name: "index_feed_raw_hl7_messages_on_sent_at"
  end

  create_table "renalware.feed_replay_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "criteria", default: {}
    t.text "error_message"
    t.integer "failed_messages", default: 0, null: false
    t.datetime "finished_at"
    t.bigint "patient_id", null: false
    t.text "reason"
    t.datetime "started_at", null: false
    t.integer "total_messages", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["criteria"], name: "index_feed_replay_requests_on_criteria", using: :gin
    t.index ["patient_id"], name: "index_feed_replay_requests_on_patient_id"
  end

  create_table "renalware.feed_sausage_queue_deprecated", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "feed_sausage_id", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_sausage_id"], name: "index_feed_sausage_queue_deprecated_on_feed_sausage_id"
  end

  create_table "renalware.feed_sausages_deprecated", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.date "dob"
    t.enum "event_type", null: false, enum_type: "hl7_event_type"
    t.string "local_patient_id"
    t.string "local_patient_id_2"
    t.string "local_patient_id_3"
    t.string "local_patient_id_4"
    t.string "local_patient_id_5"
    t.string "message_control_id"
    t.enum "message_type", null: false, enum_type: "hl7_message_type"
    t.string "nhs_number"
    t.string "orc_filler_order_number"
    t.enum "orc_order_status", enum_type: "enum_hl7_orc_order_status"
    t.datetime "processed_at", precision: nil
    t.datetime "sent_at", precision: nil, null: false
    t.datetime "updated_at", null: false
    t.integer "version", default: 1, null: false
    t.index ["message_control_id"], name: "index_feed_sausages_deprecated_on_message_control_id", unique: true
    t.index ["orc_filler_order_number"], name: "index_feed_sausages_deprecated_on_orc_filler_order_number", unique: true, where: "((orc_filler_order_number IS NOT NULL) AND ((orc_filler_order_number)::text <> ''::text))"
    t.index ["sent_at"], name: "index_feed_sausages_deprecated_on_sent_at"
  end

  create_table "renalware.geography_local_authority_districts", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "imd_decile", comment: "Grouping the most deprived 10% of LA as Decile 1 and the second most deprived 10% as decile 2 etc."
    t.integer "imd_pct", comment: "Percentage - where the most deprived 1% of LAs are 1 and the next most deprived 1% are 2 etc."
    t.integer "imd_rank", comment: "A simple Index of Multiple Deprivation (IMD) ranking of the LA from most to least deprived."
    t.string "name", null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "index_geography_local_authority_districts_on_code", unique: true
    t.index ["name"], name: "index_geography_local_authority_districts_on_name", unique: true
  end

  create_table "renalware.geography_lower_super_output_areas", comment: "LSOAs are a type of census geography that were created to allow for comparisons across\ndifferent parts of the country. LSOAs fall within the boundaries of Local Authority\nDistricts (LADs). LOSAa comprise between 400 and 1,200 households and have a usually\nresident population between 1,000 and 3,000 persons. LSOAs are made up of groups of\nOutput Areas (OAs), usually four or five.\n", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "imd_decile", comment: "Grouping the most deprived 10% of LSOAs as Decile 1 and the second most deprived 10% as decile 2 etc."
    t.integer "imd_pct", comment: "Percentage - where the most deprived 1% of LSOAs are 1 and the next most deprived 1% are 2 etc."
    t.integer "imd_rank", comment: "A simple Index of Multiple Deprivation (IMD) ranking of the LSOA from most to least deprived."
    t.bigint "middle_super_output_area_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "index_geography_lower_super_output_areas_on_code", unique: true
    t.index ["middle_super_output_area_id"], name: "idx_on_middle_super_output_area_id_b9987db7f1"
  end

  create_table "renalware.geography_middle_super_output_areas", comment: "MSOAs are groups of Lower Layer Super Output Areas (LSOAs) -  usually four or five - that\nare used to publish statistics. They are designed to contain between 5,000 and 15,000\nresidents and 2,000 and 6,000 households. MSOAs are generated automatically by zone-design\nsoftware using census data. They are often used when statistics cannot be published at the\nLSOA level because they could be disclosive of an individual's data. As of 2021, there were\n6,856 MSOAs in England and 408 in Wales.\n", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "local_authority_district_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code", "local_authority_district_id"], name: "idx_on_code_local_authority_district_id_fe2b0c7d98", unique: true
    t.index ["code"], name: "index_geography_middle_super_output_areas_on_code", unique: true
    t.index ["local_authority_district_id"], name: "idx_on_local_authority_district_id_103e1854df"
    t.index ["name"], name: "index_geography_middle_super_output_areas_on_name"
  end

  create_table "renalware.geography_output_areas", comment: "Output Areas (OAs) are the lowest level of geographical area for census statistics and\nwere first created following the 2001 Census\n", force: :cascade do |t|
    t.string "code", null: false
    t.bigint "lower_super_output_area_id", null: false
    t.index ["code"], name: "index_geography_output_areas_on_code", unique: true
    t.index ["lower_super_output_area_id"], name: "index_geography_output_areas_on_lower_super_output_area_id"
  end

  create_table "renalware.geography_postcodes", force: :cascade do |t|
    t.bigint "lower_super_output_area_id", null: false
    t.string "postal_code", null: false
    t.index ["lower_super_output_area_id"], name: "index_geography_postcodes_on_lower_super_output_area_id"
    t.index ["postal_code"], name: "index_geography_postcodes_on_postal_code", unique: true
  end

  create_table "renalware.good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "callback_priority"
    t.text "callback_queue_name"
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "discarded_at"
    t.datetime "enqueued_at"
    t.datetime "finished_at"
    t.datetime "jobs_finished_at"
    t.text "on_discard"
    t.text "on_finish"
    t.text "on_success"
    t.jsonb "serialized_properties"
    t.datetime "updated_at", null: false
  end

  create_table "renalware.good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "active_job_id", null: false
    t.datetime "created_at", null: false
    t.interval "duration"
    t.text "error"
    t.text "error_backtrace", array: true
    t.integer "error_event", limit: 2
    t.datetime "finished_at"
    t.text "job_class"
    t.uuid "process_id"
    t.text "queue_name"
    t.datetime "scheduled_at"
    t.jsonb "serialized_params"
    t.datetime "updated_at", null: false
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
    t.index ["process_id", "created_at"], name: "index_good_job_executions_on_process_id_and_created_at"
  end

  create_table "renalware.good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "lock_type", limit: 2
    t.jsonb "state"
    t.datetime "updated_at", null: false
  end

  create_table "renalware.good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "key"
    t.datetime "updated_at", null: false
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "renalware.good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "active_job_id"
    t.uuid "batch_callback_id"
    t.uuid "batch_id"
    t.text "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "cron_at"
    t.text "cron_key"
    t.text "error"
    t.integer "error_event", limit: 2
    t.integer "executions_count"
    t.datetime "finished_at"
    t.boolean "is_discrete"
    t.text "job_class"
    t.text "labels", array: true
    t.datetime "locked_at"
    t.uuid "locked_by_id"
    t.datetime "performed_at"
    t.integer "priority"
    t.text "queue_name"
    t.uuid "retried_good_job_id"
    t.datetime "scheduled_at"
    t.jsonb "serialized_params"
    t.datetime "updated_at", null: false
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key", "created_at"], name: "index_good_jobs_on_concurrency_key_and_created_at"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at_only", where: "(finished_at IS NOT NULL)"
    t.index ["job_class"], name: "index_good_jobs_on_job_class"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["locked_by_id"], name: "index_good_jobs_on_locked_by_id", where: "(locked_by_id IS NOT NULL)"
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["priority", "scheduled_at"], name: "index_good_jobs_on_priority_scheduled_at_unfinished_unlocked", where: "((finished_at IS NULL) AND (locked_by_id IS NULL))"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "renalware.hd_acuity_assessments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.bigint "patient_id", null: false
    t.decimal "ratio", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.bigint "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_hd_acuity_assessments_on_created_by_id"
    t.index ["patient_id"], name: "index_hd_acuity_assessments_on_patient_id"
    t.index ["updated_by_id"], name: "index_hd_acuity_assessments_on_updated_by_id"
    t.check_constraint "ratio = ANY (ARRAY[0.25, 0.33, 0.5, 1.0])", name: "check_ratio_valid_values"
  end

  create_table "renalware.hd_cannulation_types", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "name", null: false
    t.string "qhd33_code", comment: "Needling Method (RR50)"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_hd_cannulation_types_on_deleted_at"
  end

  create_table "renalware.hd_dialysates", force: :cascade do |t|
    t.decimal "bicarbonate_content", precision: 10, scale: 2
    t.string "bicarbonate_content_uom", default: "mmol/L"
    t.decimal "calcium_content", precision: 10, scale: 2
    t.string "calcium_content_uom", default: "mmol/L"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.text "description"
    t.decimal "glucose_content", precision: 10, scale: 2
    t.string "glucose_content_uom", default: "g/L"
    t.string "name", null: false
    t.decimal "potassium_content", precision: 10, scale: 2
    t.string "potassium_content_uom", default: "mmol/L"
    t.integer "sodium_content", null: false
    t.string "sodium_content_uom", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_hd_dialysates_on_deleted_at"
  end

  create_table "renalware.hd_dialysers", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "group", null: false
    t.decimal "membrane_surface_area", precision: 10, scale: 2
    t.decimal "membrane_surface_area_coefficient_k0a", precision: 10, scale: 2
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "renalware.hd_diaries", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.bigint "hospital_unit_id", null: false
    t.boolean "master", default: false, null: false
    t.integer "master_diary_id"
    t.string "type", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.integer "week_number"
    t.integer "year"
    t.index ["created_by_id"], name: "index_hd_diaries_on_created_by_id"
    t.index ["deleted_at"], name: "index_hd_diaries_on_deleted_at"
    t.index ["hospital_unit_id", "week_number", "year"], name: "index_hd_diaries_on_hospital_unit_id_and_week_number_and_year", unique: true, where: "(master = false)"
    t.index ["hospital_unit_id"], name: "index_hd_diaries_on_hospital_unit_id"
    t.index ["hospital_unit_id"], name: "master_index_hd_diaries_on_hospital_unit_id", unique: true, where: "(master = true)"
    t.index ["master_diary_id"], name: "index_hd_diaries_on_master_diary_id"
    t.index ["type"], name: "index_hd_diaries_on_type"
    t.index ["updated_by_id"], name: "index_hd_diaries_on_updated_by_id"
    t.index ["week_number"], name: "index_hd_diaries_on_week_number"
    t.index ["year"], name: "index_hd_diaries_on_year"
    t.check_constraint "week_number >= 1 AND week_number <= 53", name: "week_number_in_valid_range"
    t.check_constraint "year >= 2017 AND year <= 2050", name: "year_in_valid_range"
  end

  create_table "renalware.hd_diary_slots", force: :cascade do |t|
    t.boolean "archived", default: false, null: false
    t.datetime "archived_at", precision: nil
    t.time "arrival_time"
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.integer "day_of_week", null: false
    t.datetime "deleted_at", precision: nil
    t.integer "diary_id", null: false
    t.integer "diurnal_period_code_id", null: false
    t.bigint "patient_id", null: false
    t.integer "station_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["archived"], name: "index_hd_diary_slots_on_archived"
    t.index ["created_by_id"], name: "index_hd_diary_slots_on_created_by_id"
    t.index ["day_of_week"], name: "index_hd_diary_slots_on_day_of_week"
    t.index ["deleted_at"], name: "index_hd_diary_slots_on_deleted_at"
    t.index ["diary_id", "day_of_week", "diurnal_period_code_id", "patient_id"], name: "hd_diary_slots_unique_by_day_period_patient", unique: true, where: "(deleted_at IS NULL)"
    t.index ["diary_id", "diurnal_period_code_id", "day_of_week", "patient_id"], name: "idx_unique_diaryslot_patients", unique: true
    t.index ["diary_id", "station_id", "day_of_week", "diurnal_period_code_id"], name: "hd_diary_slots_unique_by_station_day_period", unique: true, where: "(deleted_at IS NULL)"
    t.index ["diary_id"], name: "index_hd_diary_slots_on_diary_id"
    t.index ["diurnal_period_code_id"], name: "index_hd_diary_slots_on_diurnal_period_code_id"
    t.index ["patient_id"], name: "index_hd_diary_slots_on_patient_id"
    t.index ["station_id"], name: "index_hd_diary_slots_on_station_id"
    t.index ["updated_by_id"], name: "index_hd_diary_slots_on_updated_by_id"
    t.check_constraint "day_of_week >= 1 AND day_of_week <= 7", name: "day_of_week_in_valid_range"
  end

  create_table "renalware.hd_diurnal_period_codes", force: :cascade do |t|
    t.string "code", null: false
    t.text "description"
    t.integer "sort_order", default: 0, null: false
    t.index ["code"], name: "index_hd_diurnal_period_codes_on_code", unique: true
  end

  create_table "renalware.hd_patient_statistics", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "dialysis_minutes_shortfall"
    t.decimal "dialysis_minutes_shortfall_percentage", precision: 10, scale: 2
    t.decimal "highest_systolic_blood_pressure", precision: 10, scale: 2
    t.integer "hospital_unit_id", null: false
    t.decimal "lowest_systolic_blood_pressure", precision: 10, scale: 2
    t.decimal "mean_blood_flow", precision: 10, scale: 2
    t.decimal "mean_fluid_removal", precision: 10, scale: 2
    t.decimal "mean_litres_processed", precision: 10, scale: 2
    t.decimal "mean_machine_ktv", precision: 10, scale: 2
    t.decimal "mean_ufr", precision: 10, scale: 2
    t.decimal "mean_weight_loss", precision: 10, scale: 2
    t.decimal "mean_weight_loss_as_percentage_of_body_weight", precision: 10, scale: 2
    t.integer "month"
    t.integer "number_of_missed_sessions"
    t.integer "number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct"
    t.jsonb "pathology_snapshot", default: {}, null: false
    t.integer "patient_id", null: false
    t.decimal "post_mean_diastolic_blood_pressure", precision: 10, scale: 2
    t.decimal "post_mean_systolic_blood_pressure", precision: 10, scale: 2
    t.decimal "pre_mean_diastolic_blood_pressure", precision: 10, scale: 2
    t.decimal "pre_mean_systolic_blood_pressure", precision: 10, scale: 2
    t.boolean "rolling"
    t.integer "session_count", default: 0, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "year"
    t.index ["hospital_unit_id"], name: "index_hd_patient_statistics_on_hospital_unit_id"
    t.index ["month"], name: "index_hd_patient_statistics_on_month"
    t.index ["patient_id", "month", "year"], name: "index_hd_patient_statistics_on_patient_id_and_month_and_year", unique: true
    t.index ["patient_id", "rolling"], name: "index_hd_patient_statistics_on_patient_id_and_rolling", unique: true
    t.index ["patient_id"], name: "index_hd_patient_statistics_on_patient_id"
    t.index ["rolling"], name: "index_hd_patient_statistics_on_rolling"
    t.index ["year"], name: "index_hd_patient_statistics_on_year"
  end

  create_table "renalware.hd_preference_sets", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.date "entered_on"
    t.integer "hospital_unit_id"
    t.text "notes"
    t.string "other_schedule"
    t.integer "patient_id", null: false
    t.integer "schedule_definition_id"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_hd_preference_sets_on_created_by_id"
    t.index ["hospital_unit_id"], name: "index_hd_preference_sets_on_hospital_unit_id"
    t.index ["patient_id"], name: "index_hd_preference_sets_on_patient_id"
    t.index ["schedule_definition_id"], name: "index_hd_preference_sets_on_schedule_definition_id"
    t.index ["updated_by_id"], name: "index_hd_preference_sets_on_updated_by_id"
  end

  create_table "renalware.hd_prescription_administration_reasons", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_hd_prescription_administration_reasons_on_name", unique: true
  end

  create_table "renalware.hd_prescription_administrations", id: :serial, force: :cascade do |t|
    t.boolean "administered"
    t.bigint "administered_by_id"
    t.boolean "administrator_authorised", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.integer "hd_session_id"
    t.text "notes"
    t.bigint "patient_id"
    t.integer "prescription_id", null: false
    t.bigint "reason_id"
    t.date "recorded_on"
    t.datetime "signed_off_at"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.boolean "witness_authorised", default: false, null: false
    t.bigint "witnessed_by_id"
    t.index ["administered_by_id"], name: "index_hd_prescription_administrations_on_administered_by_id"
    t.index ["created_by_id"], name: "index_hd_prescription_administrations_on_created_by_id"
    t.index ["deleted_at"], name: "index_hd_prescription_administrations_on_deleted_at"
    t.index ["hd_session_id"], name: "index_hd_prescription_administrations_on_hd_session_id"
    t.index ["patient_id"], name: "index_hd_prescription_administrations_on_patient_id"
    t.index ["prescription_id"], name: "index_hd_prescription_administrations_on_prescription_id"
    t.index ["reason_id"], name: "index_hd_prescription_administrations_on_reason_id"
    t.index ["updated_by_id"], name: "index_hd_prescription_administrations_on_updated_by_id"
    t.index ["witnessed_by_id"], name: "index_hd_prescription_administrations_on_witnessed_by_id"
  end

  create_table "renalware.hd_profiles", id: :serial, force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.datetime "deactivated_at", precision: nil
    t.bigint "dialysate_id"
    t.jsonb "document"
    t.string "home_machine_identifier", comment: "eg serial number of Baxter Home AK98 dialyser with which we sync via HDCloud API"
    t.integer "hospital_unit_id"
    t.integer "named_nurse_id_legacy"
    t.string "other_schedule"
    t.integer "patient_id"
    t.date "prescribed_on"
    t.integer "prescribed_time"
    t.integer "prescriber_id"
    t.integer "schedule_definition_id"
    t.time "scheduled_time"
    t.integer "transport_decider_id"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["active", "patient_id"], name: "index_hd_profiles_on_active_and_patient_id", unique: true
    t.index ["created_by_id"], name: "index_hd_profiles_on_created_by_id"
    t.index ["deactivated_at"], name: "index_hd_profiles_on_deactivated_at"
    t.index ["dialysate_id"], name: "index_hd_profiles_on_dialysate_id"
    t.index ["document"], name: "index_hd_profiles_on_document", using: :gin
    t.index ["home_machine_identifier"], name: "index_hd_profiles_on_home_machine_identifier", unique: true, where: "((deactivated_at IS NULL) AND ((COALESCE(home_machine_identifier, ''::character varying))::text <> ''::text))", comment: "Must be unique among active HD Profiles, ignoring blanks"
    t.index ["hospital_unit_id"], name: "index_hd_profiles_on_hospital_unit_id"
    t.index ["named_nurse_id_legacy"], name: "index_hd_profiles_on_named_nurse_id_legacy"
    t.index ["patient_id"], name: "index_hd_profiles_on_patient_id"
    t.index ["prescriber_id"], name: "index_hd_profiles_on_prescriber_id"
    t.index ["schedule_definition_id"], name: "index_hd_profiles_on_schedule_definition_id"
    t.index ["transport_decider_id"], name: "index_hd_profiles_on_transport_decider_id"
    t.index ["updated_by_id"], name: "index_hd_profiles_on_updated_by_id"
  end

  create_table "renalware.hd_provider_units", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "hd_provider_id", null: false
    t.bigint "hospital_unit_id", null: false
    t.string "providers_reference"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["hd_provider_id", "hospital_unit_id"], name: "index_hd_provider_units_on_hd_provider_id_and_hospital_unit_id", unique: true
    t.index ["hd_provider_id"], name: "index_renalware.hd_provider_units_on_hd_provider_id"
    t.index ["hospital_unit_id"], name: "index_renalware.hd_provider_units_on_hospital_unit_id"
    t.index ["providers_reference"], name: "index_renalware.hd_provider_units_on_providers_reference"
  end

  create_table "renalware.hd_providers", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "renalware.hd_schedule_definitions", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "days", default: [], null: false, array: true
    t.virtual "days_text", type: :text, as: "hd_schedule_definition_days_text(days)", stored: true
    t.datetime "deleted_at", precision: nil
    t.integer "diurnal_period_id", null: false
    t.integer "sort_order", default: 0, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["days"], name: "index_hd_schedule_definitions_on_days", using: :gin
    t.index ["diurnal_period_id"], name: "index_hd_schedule_definitions_on_diurnal_period_id"
    t.exclusion_constraint "diurnal_period_id WITH =, days WITH =", using: :gist, name: "days_array_unique_scoped_to_period"
  end

  create_table "renalware.hd_session_form_batch_items", force: :cascade do |t|
    t.bigint "batch_id", null: false
    t.integer "printable_id", null: false
    t.integer "status", limit: 2, default: 0, null: false
    t.index ["batch_id", "printable_id"], name: "index_hd_session_form_batch_items_on_batch_id_and_printable_id", unique: true
    t.index ["status"], name: "index_hd_session_form_batch_items_on_status"
  end

  create_table "renalware.hd_session_form_batches", force: :cascade do |t|
    t.integer "batch_items_count"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id", null: false
    t.string "filepath"
    t.string "last_error"
    t.jsonb "query_params", default: {}, null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_hd_session_form_batches_on_created_by_id"
    t.index ["status"], name: "index_hd_session_form_batches_on_status"
    t.index ["updated_by_id"], name: "index_hd_session_form_batches_on_updated_by_id"
  end

  create_table "renalware.hd_session_patient_group_directions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "patient_group_direction_id", null: false
    t.bigint "session_id", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_group_direction_id"], name: "idx_hd_session_pgds_pgd_id"
    t.index ["session_id", "patient_group_direction_id"], name: "idx_hd_session_pgds_session_pgd"
    t.index ["session_id"], name: "index_hd_session_patient_group_directions_on_session_id"
  end

  create_table "renalware.hd_sessions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.bigint "dialysate_id"
    t.jsonb "document"
    t.integer "dry_weight_id"
    t.integer "duration"
    t.time "end_time"
    t.bigint "external_id"
    t.bigint "hd_station_id", comment: "The HD Station (eg 'Bay 1 Bed 2') where the patient was dialysed"
    t.integer "hospital_unit_id"
    t.string "machine_ip_address"
    t.integer "modality_description_id"
    t.text "notes"
    t.integer "patient_id"
    t.date "performed_on"
    t.integer "profile_id"
    t.bigint "provider_id"
    t.datetime "signed_off_at", precision: nil
    t.integer "signed_off_by_id"
    t.integer "signed_on_by_id"
    t.time "start_time"
    t.datetime "started_at", precision: nil
    t.datetime "stopped_at", precision: nil
    t.string "type", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.uuid "uuid", default: -> { "public.uuid_generate_v4()" }, null: false
    t.index ["created_by_id"], name: "index_hd_sessions_on_created_by_id"
    t.index ["deleted_at"], name: "index_hd_sessions_on_deleted_at"
    t.index ["dialysate_id"], name: "index_hd_sessions_on_dialysate_id"
    t.index ["document"], name: "index_hd_sessions_on_document", using: :gin
    t.index ["dry_weight_id"], name: "index_hd_sessions_on_dry_weight_id"
    t.index ["external_id"], name: "index_hd_sessions_on_external_id", unique: true
    t.index ["hd_station_id"], name: "index_hd_sessions_on_hd_station_id"
    t.index ["hospital_unit_id"], name: "index_hd_sessions_on_hospital_unit_id"
    t.index ["id", "type"], name: "index_hd_sessions_on_id_and_type"
    t.index ["modality_description_id"], name: "index_hd_sessions_on_modality_description_id"
    t.index ["patient_id"], name: "index_hd_sessions_on_patient_id"
    t.index ["performed_on"], name: "index_hd_sessions_on_performed_on"
    t.index ["profile_id"], name: "index_hd_sessions_on_profile_id"
    t.index ["provider_id"], name: "index_hd_sessions_on_provider_id"
    t.index ["signed_off_at"], name: "index_hd_sessions_on_signed_off_at"
    t.index ["signed_off_by_id"], name: "index_hd_sessions_on_signed_off_by_id"
    t.index ["signed_on_by_id"], name: "index_hd_sessions_on_signed_on_by_id"
    t.index ["type"], name: "index_hd_sessions_on_type"
    t.index ["updated_by_id"], name: "index_hd_sessions_on_updated_by_id"
    t.index ["uuid"], name: "index_hd_sessions_on_uuid"
  end

  create_table "renalware.hd_slot_request_access_states", force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.text "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index "lower(name)", name: "index_hd_slot_request_access_states_on_name", unique: true
  end

  create_table "renalware.hd_slot_request_deletion_reasons", force: :cascade do |t|
    t.datetime "deleted_at"
    t.string "reason"
    t.index ["deleted_at"], name: "index_hd_slot_request_deletion_reasons_on_deleted_at"
  end

  create_table "renalware.hd_slot_request_locations", force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.text "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index "lower(name)", name: "index_hd_slot_request_locations_on_name", unique: true
  end

  create_table "renalware.hd_slot_requests", force: :cascade do |t|
    t.bigint "access_state_id"
    t.datetime "allocated_at"
    t.boolean "boolean", default: false, null: false, comment: "known to service <90 days"
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.datetime "deleted_at"
    t.bigint "deletion_reason_id"
    t.boolean "external_referral", default: false, null: false
    t.boolean "inpatient", default: false, null: false
    t.boolean "late_presenter", default: false, null: false, comment: "known to service <90 days"
    t.bigint "location_id"
    t.boolean "medically_fit_for_discharge", default: false, null: false, comment: "The datetime the MFFD checkbox was checked"
    t.datetime "medically_fit_for_discharge_at", comment: "The datetime the MFFD checkbox was checked"
    t.bigint "medically_fit_for_discharge_by_id", comment: "The id of the user show checked the MFFD checkbox on the HD Slot Request form"
    t.text "notes"
    t.bigint "patient_id", null: false
    t.boolean "requires_bbv_slot", default: false, null: false
    t.text "specific_requirements", comment: "transport requirements, blood borne viruses etc"
    t.boolean "suitable_for_twilight_slots", default: false, null: false
    t.datetime "updated_at", null: false
    t.bigint "updated_by_id", null: false
    t.enum "urgency", null: false, enum_type: "enum_hd_slot_request_urgency"
    t.index ["access_state_id"], name: "index_hd_slot_requests_on_access_state_id"
    t.index ["allocated_at"], name: "index_hd_slot_requests_on_allocated_at"
    t.index ["created_by_id"], name: "index_hd_slot_requests_on_created_by_id"
    t.index ["deleted_at"], name: "index_hd_slot_requests_on_deleted_at"
    t.index ["deletion_reason_id"], name: "index_hd_slot_requests_on_deletion_reason_id"
    t.index ["location_id"], name: "index_hd_slot_requests_on_location_id"
    t.index ["medically_fit_for_discharge_by_id"], name: "index_hd_slot_requests_on_medically_fit_for_discharge_by_id"
    t.index ["patient_id"], name: "index_hd_slot_requests_on_patient_id"
    t.index ["updated_by_id"], name: "index_hd_slot_requests_on_updated_by_id"
  end

  create_table "renalware.hd_station_locations", force: :cascade do |t|
    t.string "colour", null: false
    t.string "name", null: false
    t.index ["name"], name: "index_hd_station_locations_on_name"
  end

  create_table "renalware.hd_stations", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.bigint "hospital_unit_id", null: false
    t.integer "location_id"
    t.string "name"
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_hd_stations_on_created_by_id"
    t.index ["deleted_at"], name: "index_hd_stations_on_deleted_at"
    t.index ["hospital_unit_id"], name: "index_hd_stations_on_hospital_unit_id"
    t.index ["location_id"], name: "index_hd_stations_on_location_id"
    t.index ["position"], name: "index_hd_stations_on_position"
    t.index ["updated_by_id"], name: "index_hd_stations_on_updated_by_id"
  end

  create_table "renalware.hd_transmission_logs", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "direction", null: false
    t.text "error_messages", default: [], array: true
    t.string "external_session_id"
    t.string "filepath"
    t.string "format", null: false
    t.bigint "hd_provider_unit_id"
    t.bigint "parent_id"
    t.bigint "patient_id"
    t.text "payload"
    t.jsonb "result", default: {}
    t.bigint "session_id"
    t.string "status"
    t.datetime "transmitted_at", precision: nil
    t.datetime "updated_at", precision: nil, null: false
    t.uuid "uuid", default: -> { "public.uuid_generate_v4()" }, null: false
    t.string "warnings", default: [], array: true
    t.index ["direction"], name: "index_renalware.hd_transmission_logs_on_direction"
    t.index ["format"], name: "index_renalware.hd_transmission_logs_on_format"
    t.index ["hd_provider_unit_id"], name: "index_renalware.hd_transmission_logs_on_hd_provider_unit_id"
    t.index ["parent_id"], name: "index_renalware.hd_transmission_logs_on_parent_id"
    t.index ["patient_id"], name: "index_renalware.hd_transmission_logs_on_patient_id"
    t.index ["result"], name: "index_renalware.hd_transmission_logs_on_result", using: :gin
    t.index ["session_id"], name: "index_hd_transmission_logs_on_session_id"
    t.index ["status"], name: "index_renalware.hd_transmission_logs_on_status"
    t.index ["transmitted_at"], name: "index_renalware.hd_transmission_logs_on_transmitted_at"
  end

  create_table "renalware.hd_versions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "hd_versions_type_id"
  end

  create_table "renalware.hd_vnd_risk_assessments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.datetime "deleted_at"
    t.enum "overall_risk_level", null: false, comment: "Overall risk level for a serious Venous Needle Dislodgement incident eg 'high'", enum_type: "hd_vnd_risk_level_overall"
    t.integer "overall_risk_score", null: false, comment: "Overall risk score for a serious Venous Needle Dislodgement incident eg 6"
    t.bigint "patient_id", null: false
    t.enum "risk1", null: false, comment: "What is the likelihood that the staff (or carer) will fail to observe an actual or potential VND for this patient?", enum_type: "hd_vnd_risk_level_itemised"
    t.enum "risk2", null: false, comment: "What is the likelihood that the patient will fail to raise the alarm if they experience VND?", enum_type: "hd_vnd_risk_level_itemised"
    t.enum "risk3", null: false, comment: "What is the likelihood of the patient behaving in a way that could lead to VND?", enum_type: "hd_vnd_risk_level_itemised"
    t.enum "risk4", null: false, comment: "What is the likelihood of the taping failing to ensure that the needle is secure throughout dialysis?", enum_type: "hd_vnd_risk_level_itemised"
    t.datetime "updated_at", null: false
    t.bigint "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_hd_vnd_risk_assessments_on_created_by_id"
    t.index ["deleted_at"], name: "index_hd_vnd_risk_assessments_on_deleted_at"
    t.index ["patient_id"], name: "index_hd_vnd_risk_assessments_on_patient_id"
    t.index ["updated_by_id"], name: "index_hd_vnd_risk_assessments_on_updated_by_id"
  end

  create_table "renalware.help_tour_annotations", force: :cascade do |t|
    t.string "attached_to_position", default: "bottom", null: false
    t.string "attached_to_selector", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "page_id", null: false
    t.integer "position", default: 1, null: false
    t.string "text", null: false
    t.string "title"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["page_id", "attached_to_selector"], name: "idx_on_page_id_attached_to_selector_1d87c582e9", unique: true
    t.index ["page_id"], name: "index_help_tour_annotations_on_page_id"
  end

  create_table "renalware.help_tour_pages", force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "name"
    t.string "route", null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index "lower((route)::text)", name: "index_help_tour_pages_on_lower_route", unique: true
  end

  create_table "renalware.hospital_centres", id: :serial, force: :cascade do |t|
    t.string "abbrev"
    t.boolean "active"
    t.string "code", null: false
    t.datetime "created_at", precision: nil, null: false
    t.boolean "default_site", default: false, null: false
    t.integer "departments_count", default: 0, null: false, comment: "Counter cache for the number of departments at this centre"
    t.boolean "host_site", default: false, null: false
    t.text "info"
    t.boolean "is_transplant_site", default: false, null: false
    t.string "location"
    t.string "name", null: false
    t.integer "position", default: 10, null: false, comment: "Allows us to float hard-to-find options like 'Other' and 'Non-UK' the top of of dropdown lists"
    t.string "trust_caption"
    t.string "trust_name"
    t.integer "units_count", default: 0, null: false, comment: "Counter cache for the number of units at this centre"
    t.datetime "updated_at", precision: nil, null: false
    t.uuid "uuid", default: -> { "public.uuid_generate_v4()" }
    t.index ["abbrev"], name: "index_hospital_centres_on_abbrev", unique: true
    t.index ["code"], name: "index_hospital_centres_on_code"
    t.index ["host_site"], name: "index_hospital_centres_on_host_site"
  end

  create_table "renalware.hospital_departments", comment: "Can be assigned for example to a Letters::Letterhead. Useful for e.g. when including the sending organisation's details in a GP Connect message.", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.text "description"
    t.bigint "hospital_centre_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_hospital_departments_on_deleted_at"
    t.index ["hospital_centre_id"], name: "index_hospital_departments_on_hospital_centre_id"
  end

  create_table "renalware.hospital_units", id: :serial, force: :cascade do |t|
    t.string "alias"
    t.datetime "created_at", precision: nil, null: false
    t.integer "hospital_centre_id", null: false
    t.boolean "is_hd_site", default: false, null: false
    t.string "name", null: false
    t.string "ods_code"
    t.string "renal_registry_code", null: false
    t.string "unit_code", null: false
    t.string "unit_type", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["alias"], name: "index_hospital_units_on_alias", unique: true
    t.index ["hospital_centre_id"], name: "index_hospital_units_on_hospital_centre_id"
    t.index ["is_hd_site"], name: "index_hospital_units_on_is_hd_site"
  end

  create_table "renalware.hospital_wards", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "code"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.bigint "hospital_unit_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_hospital_wards_on_code"
    t.index ["hospital_unit_id"], name: "index_hospital_wards_on_hospital_unit_id"
    t.index ["name", "hospital_unit_id"], name: "index_hospital_wards_on_name_and_hospital_unit_id", unique: true, where: "(deleted_at IS NOT NULL)"
  end

  create_table "renalware.letter_archives", id: :serial, force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.integer "letter_id", null: false
    t.binary "pdf_content", comment: "Binary PDF letter data created by e.g. prawn. Definitive record of what was sent"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id"
    t.uuid "uuid", default: -> { "public.uuid_generate_v4()" }, null: false
    t.index ["created_by_id"], name: "index_letter_archives_on_created_by_id"
    t.index ["letter_id"], name: "index_letter_archives_on_letter_id"
    t.index ["updated_by_id"], name: "index_letter_archives_on_updated_by_id"
    t.index ["uuid"], name: "index_letter_archives_on_uuid", unique: true
  end

  create_table "renalware.letter_batch_items", force: :cascade do |t|
    t.bigint "batch_id", null: false
    t.bigint "letter_id", null: false
    t.integer "status", limit: 2, default: 0, null: false
    t.index ["batch_id", "status"], name: "index_letter_batch_items_on_batch_id_and_status"
    t.index ["letter_id", "batch_id"], name: "index_letter_batch_items_on_letter_id_and_batch_id", unique: true
  end

  create_table "renalware.letter_batches", force: :cascade do |t|
    t.integer "batch_items_count"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id", null: false
    t.string "filepath"
    t.jsonb "query_params", default: {}, null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_letter_batches_on_created_by_id"
    t.index ["status"], name: "index_letter_batches_on_status"
    t.index ["updated_by_id"], name: "index_letter_batches_on_updated_by_id"
  end

  create_table "renalware.letter_contact_descriptions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.integer "position", null: false
    t.string "system_code", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_letter_contact_descriptions_on_name", unique: true
    t.index ["position"], name: "index_letter_contact_descriptions_on_position", unique: true
    t.index ["system_code"], name: "index_letter_contact_descriptions_on_system_code", unique: true
  end

  create_table "renalware.letter_contacts", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.boolean "default_cc", default: false, null: false
    t.integer "description_id", null: false
    t.text "notes"
    t.string "other_description"
    t.integer "patient_id", null: false
    t.integer "person_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["description_id"], name: "index_letter_contacts_on_description_id"
    t.index ["patient_id"], name: "index_letter_contacts_on_patient_id"
    t.index ["person_id", "patient_id"], name: "index_letter_contacts_on_person_id_and_patient_id", unique: true
  end

  create_table "renalware.letter_descriptions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.integer "position", default: 0, null: false
    t.string "section_identifier"
    t.string "section_identifiers", default: [], array: true
    t.bigint "snomed_document_type_id"
    t.string "text", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_letter_descriptions_on_deleted_at"
    t.index ["snomed_document_type_id"], name: "index_letter_descriptions_on_snomed_document_type_id"
  end

  create_table "renalware.letter_electronic_receipts", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "letter_id", null: false
    t.datetime "read_at", precision: nil
    t.bigint "recipient_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_group_id", comment: "If the user chose a user group as a the eCC recipient (rather than a user) then we split up the group and store each member as a row, but assign the letter_group_id for reference"
    t.index ["letter_id"], name: "index_letter_electronic_receipts_on_letter_id"
    t.index ["read_at"], name: "index_letter_electronic_receipts_on_read_at"
    t.index ["recipient_id"], name: "index_letter_electronic_receipts_on_recipient_id"
    t.index ["user_group_id"], name: "index_letter_electronic_receipts_on_user_group_id"
  end

  create_table "renalware.letter_letterheads", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "hospital_department_id"
    t.boolean "include_pathology_in_letter_body", default: true
    t.string "name", null: false
    t.string "site_code", null: false
    t.text "site_info"
    t.string "trust_caption", null: false
    t.string "trust_name", null: false
    t.string "unit_info", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["hospital_department_id"], name: "index_letter_letterheads_on_hospital_department_id"
  end

  create_table "renalware.letter_letters", id: :serial, force: :cascade do |t|
    t.datetime "approved_at", precision: nil
    t.bigint "approved_by_id"
    t.integer "author_id", null: false
    t.text "body"
    t.boolean "clinical"
    t.datetime "completed_at", precision: nil
    t.bigint "completed_by_id"
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.datetime "deleted_at"
    t.bigint "deleted_by_id"
    t.text "deletion_notes"
    t.string "description"
    t.string "enclosures"
    t.integer "event_id"
    t.string "event_type"
    t.enum "gp_send_status", default: "not_applicable", null: false, comment: "Captures the status of out attempt to send a copy of the letter to the GP over MESH using eg GP Connect.", enum_type: "enum_letters_gp_send_status"
    t.date "legacy_issued_on"
    t.integer "letterhead_id", null: false
    t.text "notes"
    t.integer "page_count"
    t.jsonb "pathology_snapshot", default: {}
    t.datetime "pathology_timestamp", precision: nil
    t.integer "patient_id"
    t.string "salutation"
    t.datetime "signed_at", precision: nil
    t.datetime "submitted_for_approval_at", precision: nil
    t.bigint "submitted_for_approval_by_id"
    t.bigint "topic_id"
    t.string "type", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.uuid "uuid", default: -> { "public.uuid_generate_v4()" }, null: false
    t.index "COALESCE(completed_at, approved_at, submitted_for_approval_at, created_at)", name: "letter_effective_date_idx"
    t.index ["approved_at"], name: "index_letter_letters_on_approved_at"
    t.index ["approved_by_id"], name: "index_letter_letters_on_approved_by_id"
    t.index ["author_id"], name: "index_letter_letters_on_author_id"
    t.index ["completed_at"], name: "index_letter_letters_on_completed_at"
    t.index ["completed_by_id"], name: "index_letter_letters_on_completed_by_id"
    t.index ["created_at"], name: "index_letter_letters_on_created_at"
    t.index ["created_by_id"], name: "index_letter_letters_on_created_by_id"
    t.index ["deleted_at"], name: "index_letter_letters_on_deleted_at", where: "(deleted_at IS NULL)"
    t.index ["deleted_by_id"], name: "index_letter_letters_on_deleted_by_id"
    t.index ["event_type", "event_id"], name: "index_letter_letters_on_event_type_and_event_id"
    t.index ["gp_send_status"], name: "index_letter_letters_on_gp_send_status"
    t.index ["id", "type"], name: "index_letter_letters_on_id_and_type"
    t.index ["letterhead_id"], name: "index_letter_letters_on_letterhead_id"
    t.index ["patient_id"], name: "index_letter_letters_on_patient_id"
    t.index ["submitted_for_approval_at"], name: "index_letter_letters_on_submitted_for_approval_at"
    t.index ["submitted_for_approval_by_id"], name: "index_letter_letters_on_submitted_for_approval_by_id"
    t.index ["topic_id"], name: "index_letter_letters_on_topic_id"
    t.index ["type"], name: "index_letter_letters_on_type"
    t.index ["updated_by_id"], name: "index_letter_letters_on_updated_by_id"
    t.index ["uuid"], name: "index_letter_letters_on_uuid"
  end

  create_table "renalware.letter_mailshot_items", comment: "A record of the letters sent in a mailshot", force: :cascade do |t|
    t.bigint "letter_id", null: false
    t.bigint "mailshot_id", null: false
    t.index ["letter_id"], name: "index_letter_mailshot_items_on_letter_id"
    t.index ["mailshot_id", "letter_id"], name: "index_letter_mailshot_items_on_mailshot_id_and_letter_id", unique: true, comment: "A sanity check that a letter appears only once in a mailshot"
  end

  create_table "renalware.letter_mailshot_mailshots", comment: "A mailshot is an adhoc letter sent to a group of patients", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.text "body", null: false, comment: "The body text that will be inserted into each letter"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id", null: false
    t.string "description", null: false, comment: "Some text to identify the mailshot purpose. Will be written to letter_letters.description column when letter created"
    t.text "last_error"
    t.bigint "letterhead_id", null: false
    t.integer "letters_count", comment: "Counter cache column which Rails will update"
    t.string "sql_view_name", null: false, comment: "The name of the SQL view chosen as the data source"
    t.enum "status", enum_type: "background_job_status"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id", null: false
    t.index ["author_id"], name: "index_letter_mailshot_mailshots_on_author_id"
    t.index ["created_by_id"], name: "index_letter_mailshot_mailshots_on_created_by_id"
    t.index ["letterhead_id"], name: "index_letter_mailshot_mailshots_on_letterhead_id"
    t.index ["updated_by_id"], name: "index_letter_mailshot_mailshots_on_updated_by_id"
  end

  create_table "renalware.letter_mesh_operations", comment: "Each row represents a MESH API message. There are two types of message - outbound XML FHIR messages containing the letter content and supporting metadata - inbound XML FHIR messages containing a business or infrastructure response. The direction column specifies the direction.", force: :cascade do |t|
    t.enum "action", null: false, enum_type: "enum_mesh_api_action"
    t.datetime "created_at", null: false
    t.enum "direction", default: "outbound", null: false, comment: "See enum for options", enum_type: "enum_mesh_message_direction"
    t.boolean "http_error", default: false, null: false, comment: "true is eg response status > 299"
    t.integer "http_response_code", comment: "eg 200, 401"
    t.text "http_response_description", comment: "e.g. OK, Unauthorised"
    t.boolean "itk3_error", default: false, null: false, comment: "true if an ITK3 error was returned in a business or infrastructure reply"
    t.text "itk3_operation_outcome_code", comment: "from OperationOutcome/issues/details/coding/code - a numeric code e.g. 20001"
    t.text "itk3_operation_outcome_description", comment: "from OperationOutcome/issues/details/coding/display - code description eg 'Handling Specification Error'"
    t.text "itk3_operation_outcome_severity", comment: "from MessageHeader/response/severity, e.g. fatal, success"
    t.text "itk3_operation_outcome_type", comment: "from OperationOutcome/issue/code, eg processing, security etc"
    t.text "itk3_response_code", comment: "from MessageHeader/response/code, e.g. fatal-error"
    t.enum "itk3_response_type", comment: "Incoming messages, where they are an async response to a previously sent message will be of type 'infrastructure' or 'business'", enum_type: "enum_mesh_itk3_response_type"
    t.boolean "mesh_error", default: false, null: false, comment: "true if a MESH error was returned from a API call"
    t.text "mesh_message_id", comment: "The MESH message id for this message"
    t.text "mesh_response_error_code", comment: "MESH EPL mailbox/NHS number error code eg EPL-153"
    t.text "mesh_response_error_description", comment: "e.g. for EPL-153, 'NHS Number not found'"
    t.text "mesh_response_error_event", comment: "eg SEND"
    t.bigint "parent_id", comment: "Parent operation - if if we are a download_message operation which needs to be associated with the earlier, parent send_message operation"
    t.text "payload", comment: "The XML message body"
    t.boolean "reconciliation_error", default: false, null: false
    t.text "reconciliation_error_description"
    t.jsonb "request_headers", comment: "Optional, useful for testing"
    t.text "response_body", comment: "The response body (eg JSON) if the message is outbound"
    t.jsonb "response_headers", comment: "Optional, useful for testing"
    t.bigint "transmission_id", comment: "A reference to the transmission 'transaction'"
    t.text "unhandled_error", comment: "Stores an unexpected exception"
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "public.uuid_generate_v4()" }, null: false
    t.index ["action"], name: "index_letter_mesh_operations_on_action"
    t.index ["created_at"], name: "index_letter_mesh_operations_on_created_at"
    t.index ["direction"], name: "index_letter_mesh_operations_on_direction"
    t.index ["itk3_response_type"], name: "index_letter_mesh_operations_on_itk3_response_type"
    t.index ["parent_id"], name: "index_letter_mesh_operations_on_parent_id"
    t.index ["reconciliation_error"], name: "index_letter_mesh_operations_on_reconciliation_error"
    t.index ["transmission_id"], name: "index_letter_mesh_operations_on_transmission_id"
    t.index ["updated_at"], name: "index_letter_mesh_operations_on_updated_at"
  end

  create_table "renalware.letter_mesh_transmissions", force: :cascade do |t|
    t.uuid "active_job_id"
    t.datetime "cancelled_at"
    t.text "comment"
    t.datetime "created_at", null: false
    t.bigint "letter_id", null: false, comment: "A reference to the letter being sent"
    t.string "sent_to_practice_ods_code"
    t.enum "status", default: "pending", null: false, enum_type: "enum_mesh_transmission_status"
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "public.uuid_generate_v4()" }, null: false
    t.index ["active_job_id"], name: "index_letter_mesh_transmissions_on_active_job_id"
    t.index ["created_at"], name: "index_letter_mesh_transmissions_on_created_at"
    t.index ["letter_id"], name: "index_letter_mesh_transmissions_on_letter_id"
    t.index ["sent_to_practice_ods_code"], name: "index_letter_mesh_transmissions_on_sent_to_practice_ods_code"
    t.index ["status"], name: "index_letter_mesh_transmissions_on_status"
    t.index ["updated_at"], name: "index_letter_mesh_transmissions_on_updated_at"
  end

  create_table "renalware.letter_qr_encoded_online_reference_links", force: :cascade do |t|
    t.bigint "letter_id", null: false
    t.bigint "online_reference_link_id", null: false
    t.index ["letter_id", "online_reference_link_id"], name: "letter_online_references_uniq_idx", unique: true, comment: "A letter cannot have duplicate online references"
  end

  create_table "renalware.letter_recipients", id: :serial, force: :cascade do |t|
    t.integer "addressee_id"
    t.string "addressee_type"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "emailed_at", precision: nil
    t.integer "letter_id", null: false
    t.string "person_role", null: false
    t.datetime "printed_at", precision: nil
    t.string "role", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["addressee_type", "addressee_id"], name: "index_letter_recipients_on_addressee_type_and_addressee_id"
    t.index ["emailed_at"], name: "index_letter_recipients_on_emailed_at"
    t.index ["letter_id"], name: "index_letter_recipients_on_letter_id"
    t.index ["printed_at"], name: "index_letter_recipients_on_printed_at"
    t.index ["role"], name: "index_letter_recipients_on_role"
  end

  create_table "renalware.letter_section_snapshots", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", null: false
    t.bigint "letter_id", null: false
    t.string "section_identifier"
    t.datetime "updated_at", null: false
    t.index ["letter_id", "section_identifier"], name: "index_unique_on_letter_id_and_section_identifier", unique: true
    t.index ["letter_id"], name: "index_letter_section_snapshots_on_letter_id"
  end

  create_table "renalware.letter_signatures", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "letter_id", null: false
    t.datetime "signed_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id", null: false
    t.index ["letter_id"], name: "index_letter_signatures_on_letter_id"
    t.index ["user_id"], name: "index_letter_signatures_on_user_id"
  end

  create_table "renalware.letter_snomed_document_types", comment: "SNOMED codes and their description that are attached to a letter description (aka letter topic) and used as the FHIR Composition.document_type in GP Connect messages. There can be only one default type, and this is used wherever a letter description has no associated SNOMED document type.", force: :cascade do |t|
    t.text "code", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.boolean "default_type", default: false, null: false
    t.text "title", null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "index_letter_snomed_document_types_on_code", unique: true
    t.index ["default_type"], name: "index_letter_snomed_document_types_on_default_type", unique: true, where: "(default_type = true)"
    t.index ["title"], name: "index_letter_snomed_document_types_on_title", unique: true
  end

  create_table "renalware.low_clearance_dialysis_plans", force: :cascade do |t|
    t.string "code", null: false, comment: "Required only for migration from the code-based enumeration"
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.string "name", null: false
    t.integer "ukrdc_assessment_outcome_code", comment: "For UKRDC Care Planning Assessments. See UKRR Dataset 5+. Valid values are 4 through 10."
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_low_clearance_dialysis_plans_on_code", unique: true
    t.index ["deleted_at"], name: "index_low_clearance_dialysis_plans_on_deleted_at"
    t.index ["name"], name: "index_low_clearance_dialysis_plans_on_name", unique: true
  end

  create_table "renalware.low_clearance_profiles", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id", null: false
    t.bigint "dialysis_plan_id"
    t.jsonb "document"
    t.bigint "patient_id", null: false
    t.bigint "referrer_id"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_low_clearance_profiles_on_created_by_id"
    t.index ["dialysis_plan_id"], name: "index_low_clearance_profiles_on_dialysis_plan_id"
    t.index ["document"], name: "index_low_clearance_profiles_on_document", using: :gin
    t.index ["patient_id"], name: "index_low_clearance_profiles_on_patient_id", unique: true
    t.index ["referrer_id"], name: "index_low_clearance_profiles_on_referrer_id"
    t.index ["updated_by_id"], name: "index_low_clearance_profiles_on_updated_by_id"
  end

  create_table "renalware.low_clearance_referrers", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.boolean "hidden", default: false, null: false
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_low_clearance_referrers_on_name", unique: true
  end

  create_table "renalware.low_clearance_versions", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_low_clearance_versions_on_item_type_and_item_id"
  end

  create_table "renalware.medication_delivery_event_prescriptions", comment: "A cross reference table between delivery_events and prescriptions", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "prescription_id", null: false
    t.index ["event_id", "prescription_id"], name: "idx_medication_delivery_event_prescriptions", unique: true
  end

  create_table "renalware.medication_delivery_events", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.bigint "drug_type_id", null: false
    t.bigint "homecare_form_id", null: false
    t.bigint "patient_id", null: false
    t.integer "prescription_duration"
    t.boolean "printed", default: false, null: false
    t.string "reference_number"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_medication_delivery_events_on_created_by_id"
    t.index ["deleted_at"], name: "index_medication_delivery_events_on_deleted_at"
    t.index ["drug_type_id"], name: "index_medication_delivery_events_on_drug_type_id"
    t.index ["homecare_form_id"], name: "index_medication_delivery_events_on_homecare_form_id"
    t.index ["patient_id"], name: "index_medication_delivery_events_on_patient_id"
    t.index ["updated_by_id"], name: "index_medication_delivery_events_on_updated_by_id"
  end

  create_table "renalware.medication_prescription_terminations", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.text "notes"
    t.integer "prescription_id", null: false
    t.date "terminated_on", null: false
    t.boolean "terminated_on_set_by_user", default: false, null: false, comment: "If true, the system will not attempt to set to prescribed_on + 6 months if prescriptions administer_on_hd=true"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_medication_prescription_terminations_on_created_by_id"
    t.index ["prescription_id"], name: "index_medication_prescription_terminations_on_prescription_id"
    t.index ["updated_by_id"], name: "index_medication_prescription_terminations_on_updated_by_id"
  end

  create_table "renalware.medication_prescription_versions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_medication_prescription_versions_on_item_type_and_item_id"
  end

  create_table "renalware.medication_prescriptions", id: :serial, force: :cascade do |t|
    t.boolean "administer_on_hd", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.string "dose_amount", null: false
    t.string "dose_unit"
    t.integer "drug_id", null: false
    t.bigint "form_id"
    t.string "frequency", null: false
    t.string "frequency_comment"
    t.date "last_delivery_date"
    t.integer "legacy_drug_id", comment: "Keep the previous drug id as a reference in case of issues with DMD migration"
    t.integer "legacy_medication_route_id", comment: "Keep the previous route id as a reference in case of issues with DMD migration"
    t.integer "medication_route_id", null: false
    t.date "next_delivery_date"
    t.text "notes"
    t.integer "patient_id", null: false
    t.date "prescribed_on", null: false
    t.integer "provider", null: false
    t.string "route_description"
    t.boolean "stat", comment: "Can be chosen when administer_on_hd is true. Prescriptions marked as 'stat' will be marked as terminated automatically once given."
    t.bigint "trade_family_id"
    t.integer "treatable_id", null: false
    t.string "treatable_type", null: false
    t.bigint "unit_of_measure_id"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_medication_prescriptions_on_created_by_id"
    t.index ["drug_id", "patient_id"], name: "index_medication_prescriptions_on_drug_id_and_patient_id"
    t.index ["drug_id"], name: "index_medication_prescriptions_on_drug_id"
    t.index ["form_id"], name: "index_medication_prescriptions_on_form_id"
    t.index ["medication_route_id"], name: "index_medication_prescriptions_on_medication_route_id"
    t.index ["patient_id", "medication_route_id"], name: "idx_mp_patient_id_medication_route_id"
    t.index ["patient_id"], name: "index_medication_prescriptions_on_patient_id"
    t.index ["trade_family_id"], name: "index_medication_prescriptions_on_trade_family_id"
    t.index ["treatable_id", "treatable_type"], name: "idx_medication_prescriptions_type"
    t.index ["unit_of_measure_id"], name: "index_medication_prescriptions_on_unit_of_measure_id"
    t.index ["updated_by_id"], name: "index_medication_prescriptions_on_updated_by_id"
  end

  create_table "renalware.medication_routes", id: :serial, force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "deleted_at", precision: nil
    t.string "legacy_code"
    t.string "name", null: false
    t.string "rr_code"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "weighting", default: 0, null: false
    t.index ["code"], name: "index_medication_routes_on_code", unique: true
    t.index ["weighting"], name: "index_medication_routes_on_weighting"
  end

  create_table "renalware.messaging_messages", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.text "body", null: false
    t.datetime "created_at", precision: nil, null: false
    t.bigint "patient_id", null: false
    t.boolean "public", default: false, null: false, comment: "If true, the message will be displayed on a patient's clinical summary and their messages page. If false (ie private), the message can only be viewed by the sender (in their sent messages) and by the recipients. New messages once this migration is run will always have public=true. Historical messages will remain private."
    t.integer "replying_to_message_id"
    t.datetime "sent_at", precision: nil, null: false
    t.string "subject", null: false
    t.string "type", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "urgent", default: false, null: false
    t.index ["author_id"], name: "index_messaging_messages_on_author_id"
    t.index ["patient_id"], name: "index_messaging_messages_on_patient_id"
    t.index ["replying_to_message_id"], name: "index_messaging_messages_on_replying_to_message_id"
    t.index ["subject"], name: "index_messaging_messages_on_subject"
    t.index ["type"], name: "index_messaging_messages_on_type"
  end

  create_table "renalware.messaging_receipts", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.datetime "read_at", precision: nil
    t.bigint "recipient_id", null: false
    t.index ["message_id"], name: "index_messaging_receipts_on_message_id"
    t.index ["read_at"], name: "index_messaging_receipts_on_read_at"
    t.index ["recipient_id"], name: "idx_unread_messaging_receipts", where: "(read_at IS NULL)"
    t.index ["recipient_id"], name: "index_messaging_receipts_on_recipient_id"
  end

  create_table "renalware.modality_change_types", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at"
    t.bigint "created_by_id", null: false
    t.boolean "default", default: false, null: false
    t.datetime "deleted_at"
    t.string "name", null: false
    t.boolean "require_destination_hospital_centre", default: false, null: false, comment: "When true, a destination hospital must be chosen when adding the modality"
    t.boolean "require_source_hospital_centre", default: false, null: false, comment: "When true, a source hospital must be chosen when adding the modality"
    t.datetime "updated_at"
    t.bigint "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_modality_change_types_on_created_by_id"
    t.index ["default"], name: "index_modality_change_types_on_default", unique: true, where: "(\"default\" = true)"
    t.index ["deleted_at"], name: "index_modality_change_types_on_deleted_at"
    t.index ["updated_by_id"], name: "index_modality_change_types_on_updated_by_id"
  end

  create_table "renalware.modality_descriptions", id: :serial, force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.boolean "hidden", default: false, null: false
    t.boolean "ignore_for_aki_alerts", default: false, null: false, comment: "If true, HL7 AKI scores are ignored when the patient has this current modality"
    t.boolean "ignore_for_kfre", default: false, null: false, comment: "If true, we will attempt to generate a KFRE on receipt of ACR/PCR result when the patient has this current modality"
    t.string "name", null: false
    t.string "type"
    t.bigint "ukrdc_modality_code_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_modality_descriptions_on_code", unique: true
    t.index ["deleted_at"], name: "index_modality_descriptions_on_deleted_at"
    t.index ["id", "type"], name: "index_modality_descriptions_on_id_and_type"
    t.index ["ignore_for_kfre"], name: "index_modality_descriptions_on_ignore_for_kfre"
    t.index ["name"], name: "index_modality_descriptions_on_name"
    t.index ["type"], name: "index_modality_descriptions_on_type"
    t.index ["ukrdc_modality_code_id"], name: "index_modality_descriptions_on_ukrdc_modality_code_id"
  end

  create_table "renalware.modality_modalities", id: :serial, force: :cascade do |t|
    t.bigint "change_type_id"
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.integer "description_id", null: false
    t.bigint "destination_hospital_centre_id", comment: "Destination hospital when modality is transferred out."
    t.date "ended_on"
    t.string "modal_change_type_deprecated"
    t.text "notes"
    t.integer "patient_id", null: false
    t.integer "reason_id"
    t.bigint "source_hospital_centre_id", comment: "Source hospital when modality is transferred in."
    t.date "started_on", null: false
    t.string "state", default: "current", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["change_type_id"], name: "index_modality_modalities_on_change_type_id"
    t.index ["created_by_id"], name: "index_modality_modalities_on_created_by_id"
    t.index ["description_id"], name: "index_modality_modalities_on_description_id"
    t.index ["destination_hospital_centre_id"], name: "index_modality_modalities_on_destination_hospital_centre_id"
    t.index ["ended_on"], name: "index_modality_modalities_on_ended_on"
    t.index ["patient_id", "description_id"], name: "index_modality_modalities_on_patient_id_and_description_id"
    t.index ["patient_id"], name: "index_modality_modalities_on_patient_id"
    t.index ["reason_id"], name: "index_modality_modalities_on_reason_id"
    t.index ["source_hospital_centre_id"], name: "index_modality_modalities_on_source_hospital_centre_id"
    t.index ["state"], name: "index_modality_modalities_on_state"
    t.index ["updated_by_id"], name: "index_modality_modalities_on_updated_by_id"
  end

  create_table "renalware.modality_reasons", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "description"
    t.integer "rr_code"
    t.string "type"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["id", "type"], name: "index_modality_reasons_on_id_and_type"
  end

  create_table "renalware.modality_versions", force: :cascade do |t|
    t.datetime "created_at"
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_modality_versions_on_item_type_and_item_id"
  end

  create_table "renalware.monitoring_mirth_channel_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "name", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid", null: false
    t.index ["uuid"], name: "index_monitoring_mirth_channel_groups_on_uuid", unique: true
  end

  create_table "renalware.monitoring_mirth_channel_stats", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.datetime "created_at", null: false
    t.integer "error", default: 0, null: false
    t.integer "filtered", default: 0, null: false
    t.integer "queued", default: 0, null: false
    t.integer "received", default: 0, null: false
    t.integer "sent", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_monitoring_mirth_channel_stats_on_channel_id"
    t.index ["created_at"], name: "index_monitoring_mirth_channel_stats_on_created_at"
  end

  create_table "renalware.monitoring_mirth_channels", force: :cascade do |t|
    t.bigint "channel_group_id"
    t.datetime "created_at", null: false
    t.text "name", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid", null: false
    t.index ["channel_group_id"], name: "index_monitoring_mirth_channels_on_channel_group_id"
    t.index ["uuid"], name: "index_monitoring_mirth_channels_on_uuid", unique: true
  end

  create_table "renalware.old_passwords", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "encrypted_password", null: false
    t.integer "password_archivable_id", null: false
    t.string "password_archivable_type", null: false
    t.index ["password_archivable_type", "password_archivable_id"], name: "index_password_archivable"
  end

  create_table "renalware.pathology_calculation_sources", force: :cascade do |t|
    t.bigint "calculated_observation_id", null: false, comment: "Id of the calculated observation e.g. URR derived from pre and post UREA"
    t.bigint "source_observation_id", null: false, comment: "Id of an observation used in the calculation e.g. a UREA observation"
    t.index ["calculated_observation_id", "source_observation_id"], name: "pathology_calculation_sources_idx", unique: true
  end

  create_table "renalware.pathology_chart_series", comment: "Defines the series displayed on a predefined chart", force: :cascade do |t|
    t.enum "axis", default: "y1", null: false, enum_type: "pathology_chart_axis"
    t.bigint "chart_id", null: false
    t.string "colour", comment: "Usually null, but can override the colour in the chartable row here"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "observation_description_id", null: false
    t.jsonb "options", default: {}, comment: "Optional hash to override default series settings"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["chart_id"], name: "index_pathology_chart_series_on_chart_id"
    t.index ["observation_description_id"], name: "idx_path_cst_obx"
  end

  create_table "renalware.pathology_charts", comment: "Pre-defined charts that can appear in various places", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.text "description", comment: "For admin use only"
    t.integer "display_group", default: 1, null: false, comment: "For grouping charts"
    t.integer "display_order", default: 1, null: false, comment: "Position of chart in a group"
    t.boolean "enabled", default: true, null: false
    t.jsonb "options", default: {}, comment: "Optional hash to override default chart settings"
    t.bigint "owner_id", comment: "If set, only this user sees this chart"
    t.string "scope", default: "charts", null: false, comment: "E.g. page location for chart"
    t.string "title", null: false, comment: "Appears on the page next to the chart"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["enabled"], name: "index_pathology_charts_on_enabled"
    t.index ["owner_id"], name: "index_pathology_charts_on_owner_id"
    t.index ["title"], name: "index_pathology_charts_on_title", unique: true
  end

  create_table "renalware.pathology_code_group_memberships", force: :cascade do |t|
    t.bigint "code_group_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id"
    t.bigint "observation_description_id", null: false
    t.integer "position_within_subgroup", default: 1, null: false
    t.integer "subgroup", default: 1, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id"
    t.index ["code_group_id", "observation_description_id"], name: "index_pathology_code_group_memberships_uniq", unique: true
    t.index ["code_group_id"], name: "index_pathology_code_group_memberships_on_code_group_id"
    t.index ["created_by_id"], name: "index_pathology_code_group_memberships_on_created_by_id"
    t.index ["observation_description_id"], name: "pathology_code_group_membership_obx"
    t.index ["updated_by_id"], name: "index_pathology_code_group_memberships_on_updated_by_id"
  end

  create_table "renalware.pathology_code_groups", force: :cascade do |t|
    t.boolean "context_specific", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id"
    t.text "description"
    t.string "name", null: false
    t.enum "subgroup_colours", array: true, enum_type: "enum_colour_name"
    t.text "subgroup_titles", default: [], array: true
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_pathology_code_groups_on_created_by_id"
    t.index ["name"], name: "index_pathology_code_groups_on_name", unique: true
    t.index ["updated_by_id"], name: "index_pathology_code_groups_on_updated_by_id"
  end

  create_table "renalware.pathology_current_observation_sets", force: :cascade do |t|
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "patient_id", null: false
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.jsonb "values", default: {}
    t.index ["patient_id"], name: "index_pathology_current_observation_sets_on_patient_id", unique: true
    t.index ["values"], name: "index_pathology_current_observation_sets_on_values", using: :gin
  end

  create_table "renalware.pathology_labs", id: :serial, force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "renalware.pathology_measurement_units", force: :cascade do |t|
    t.string "description"
    t.string "name", null: false
    t.bigint "ukrdc_measurement_unit_id"
    t.index ["name"], name: "index_pathology_measurement_units_on_name", unique: true
    t.index ["ukrdc_measurement_unit_id"], name: "index_pathology_measurement_units_ukrdc_mu"
  end

  create_table "renalware.pathology_observation_descriptions", id: :serial, force: :cascade do |t|
    t.string "chart_colour"
    t.boolean "chart_logarithmic", default: false, null: false
    t.string "chart_sql_function_name", comment: "A custom json-returning SQL function returning a calculated/derived series. Must accept an integer (patient id) and date (start date to search from)"
    t.string "code", null: false
    t.enum "colour", enum_type: "enum_colour_name"
    t.datetime "created_at", precision: nil
    t.bigint "created_by_sender_id", comment: "The feed source that dynmically created this OBX"
    t.integer "display_group"
    t.integer "display_order"
    t.datetime "last_observed_at", precision: nil
    t.string "legacy_code"
    t.integer "letter_group"
    t.integer "letter_order"
    t.string "loinc_code"
    t.float "lower_threshold", comment: "Value below which a result can be seen as abnormal"
    t.integer "measurement_unit_id"
    t.string "name"
    t.integer "observations_count", default: 0
    t.integer "rr_coding_standard", default: 0, null: false
    t.integer "rr_type", default: 0, null: false
    t.integer "suggested_measurement_unit_id"
    t.datetime "updated_at", precision: nil
    t.float "upper_threshold", comment: "Value above which a result can be seen as abnormal"
    t.boolean "virtual", default: false, null: false
    t.index ["code"], name: "index_pathology_observation_descriptions_on_code", unique: true
    t.index ["created_by_sender_id"], name: "pathology_observation_descriptions_sender"
    t.index ["display_group", "display_order"], name: "obx_unique_display_grouping"
    t.index ["letter_group", "letter_order"], name: "obx_unique_letter_grouping"
    t.index ["measurement_unit_id"], name: "index_pathology_observation_descriptions_on_measurement_unit_id"
  end

  create_table "renalware.pathology_observation_requests", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "description_id", null: false
    t.integer "feed_message_id", comment: "Reference to the feed_message from which this observation_request was created. There is no constraint on this relationship as feed_messages can be housekept."
    t.string "filler_order_number"
    t.integer "patient_id", null: false
    t.datetime "requested_at", precision: nil, null: false
    t.string "requestor_name", null: false
    t.string "requestor_order_number"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["description_id"], name: "index_pathology_observation_requests_on_description_id"
    t.index ["feed_message_id"], name: "index_pathology_observation_requests_on_feed_message_id"
    t.index ["patient_id"], name: "index_pathology_observation_requests_on_patient_id"
    t.index ["requested_at"], name: "index_pathology_observation_requests_on_requested_at"
    t.index ["requestor_order_number"], name: "index_pathology_observation_requests_on_requestor_order_number"
  end

  create_table "renalware.pathology_observations", id: :serial, force: :cascade do |t|
    t.boolean "cancelled"
    t.text "comment"
    t.datetime "created_at", precision: nil, null: false
    t.integer "description_id", null: false
    t.text "legacy_comment"
    t.float "nresult", comment: "The result column cast to a float, for ease of using graphing and claculations.Will be null if the result has a text value that cannot be coreced into a number"
    t.datetime "observed_at", precision: nil, null: false
    t.integer "request_id", null: false
    t.string "result", null: false
    t.enum "result_status", comment: "OBX.11 - Observation Result Status\nDefinition:\nC Record coming over is a correction and thus replaces a final result\nD Deletes the OBX record\nF Final results; Can only be changed with a corrected result.\nI Specimen in lab; results pending\nN Not asked\nO Order detail description only (no result)\nP Preliminary results\nR Results entered -- not verified\nS Partial results. Deprecated. Retained only for backward compatibility as of V2.6.\nU Results status change to final without retransmitting results already sent as preliminary\nW Post original as wrong, e.g., transmitted for wrong patient\nX Results cannot be obtained for this observation\n", enum_type: "enum_hl7_observation_result_status_codes"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["description_id"], name: "index_pathology_observations_on_description_id"
    t.index ["observed_at"], name: "index_pathology_observations_on_observed_at"
    t.index ["request_id"], name: "index_pathology_observations_on_request_id"
  end

  create_table "renalware.pathology_obx_mappings", comment: "In a multi-site installation, one hospital might use a different OBX code (eg HB or HBN) from the one Renalware expects (in this case HGB). This table enables that mapping so that incoming OBX results from different sites are mapped to a single observation_description. This table defines the expected MSH sending facility/app to match against.", force: :cascade do |t|
    t.string "code_alias", null: false, comment: "The hosp-specific code eg 'HB'"
    t.text "comment", comment: "Optional text to help understand mapping issues"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id"
    t.bigint "observation_description_id", null: false, comment: "The Renalware standarised OBX we are mapping to"
    t.bigint "sender_id", null: false, comment: "A definition of the sending facility (eg RAJ01) and sending app (eg WinPath)"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id"
    t.index ["code_alias", "sender_id"], name: "pathology_obx_mappings_uniqueness", unique: true, comment: "Ensures only one mapping row per sender + code_alias."
    t.index ["code_alias"], name: "index_pathology_obx_mappings_on_code_alias"
    t.index ["created_by_id"], name: "index_pathology_obx_mappings_on_created_by_id"
    t.index ["observation_description_id"], name: "index_pathology_obx_mappings_on_observation_description_id"
    t.index ["sender_id"], name: "index_pathology_obx_mappings_on_sender_id"
    t.index ["updated_by_id"], name: "index_pathology_obx_mappings_on_updated_by_id"
  end

  create_table "renalware.pathology_request_descriptions", id: :serial, force: :cascade do |t|
    t.string "bottle_type"
    t.string "code", null: false
    t.datetime "created_at", precision: nil
    t.integer "expiration_days", default: 0, null: false
    t.integer "lab_id", null: false
    t.string "name"
    t.integer "required_observation_description_id"
    t.datetime "updated_at", precision: nil
    t.index ["code"], name: "index_pathology_request_descriptions_on_code", unique: true
    t.index ["lab_id"], name: "index_pathology_request_descriptions_on_lab_id"
    t.index ["required_observation_description_id"], name: "prd_required_observation_description_id_idx"
  end

  create_table "renalware.pathology_request_descriptions_requests_requests", id: :serial, force: :cascade do |t|
    t.integer "request_description_id", null: false
    t.integer "request_id", null: false
    t.index ["request_description_id"], name: "prdr_requests_description_id_idx"
    t.index ["request_id"], name: "prdr_requests_request_id_idx"
  end

  create_table "renalware.pathology_requests_drug_categories", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_pathology_requests_drug_categories_on_name"
  end

  create_table "renalware.pathology_requests_drugs_drug_categories", id: :serial, force: :cascade do |t|
    t.integer "drug_category_id", null: false
    t.integer "drug_id", null: false
    t.index ["drug_category_id"], name: "prddc_drug_category_id_idx"
    t.index ["drug_id"], name: "index_pathology_requests_drugs_drug_categories_on_drug_id"
  end

  create_table "renalware.pathology_requests_global_rule_sets", id: :serial, force: :cascade do |t|
    t.integer "clinic_id"
    t.string "frequency_type", null: false
    t.integer "request_description_id", null: false
    t.index ["clinic_id"], name: "index_pathology_requests_global_rule_sets_on_clinic_id"
    t.index ["request_description_id"], name: "prddc_request_description_id_idx"
  end

  create_table "renalware.pathology_requests_global_rules", id: :serial, force: :cascade do |t|
    t.string "param_comparison_operator"
    t.string "param_comparison_value"
    t.string "param_id"
    t.integer "rule_set_id"
    t.string "rule_set_type", null: false
    t.string "type"
    t.index ["id", "type"], name: "index_pathology_requests_global_rules_on_id_and_type"
    t.index ["rule_set_id", "rule_set_type"], name: "prgr_rule_set_id_and_rule_set_type_idx"
    t.index ["rule_set_type"], name: "index_pathology_requests_global_rules_on_rule_set_type"
  end

  create_table "renalware.pathology_requests_patient_rules", id: :serial, force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.date "end_date"
    t.string "frequency_type"
    t.integer "lab_id"
    t.integer "patient_id"
    t.integer "sample_number_bottles"
    t.string "sample_type"
    t.date "start_date"
    t.text "test_description"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["lab_id"], name: "index_pathology_requests_patient_rules_on_lab_id"
    t.index ["patient_id"], name: "index_pathology_requests_patient_rules_on_patient_id"
  end

  create_table "renalware.pathology_requests_patient_rules_requests", id: :serial, force: :cascade do |t|
    t.integer "patient_rule_id", null: false
    t.integer "request_id", null: false
    t.index ["patient_rule_id"], name: "prprr_patient_rule_id_idx"
    t.index ["request_id"], name: "index_pathology_requests_patient_rules_requests_on_request_id"
  end

  create_table "renalware.pathology_requests_requests", id: :serial, force: :cascade do |t|
    t.integer "clinic_id", null: false
    t.bigint "consultant_id"
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.boolean "high_risk", null: false
    t.integer "patient_id", null: false
    t.string "telephone", null: false
    t.string "template", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["clinic_id"], name: "index_pathology_requests_requests_on_clinic_id"
    t.index ["consultant_id"], name: "index_pathology_requests_requests_on_consultant_id"
    t.index ["created_by_id"], name: "index_pathology_requests_requests_on_created_by_id"
    t.index ["patient_id"], name: "index_pathology_requests_requests_on_patient_id"
    t.index ["updated_by_id"], name: "index_pathology_requests_requests_on_updated_by_id"
  end

  create_table "renalware.pathology_requests_sample_types", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_pathology_requests_sample_types_on_code", unique: true
    t.index ["name"], name: "index_pathology_requests_sample_types_on_name", unique: true
  end

  create_table "renalware.pathology_senders", comment: "The HL7 MSH segment defines a sending application and sending facility e.g. at MSE Basildon 'MSH|^~&|WinPath|RAJ01|RenalWare|MSE|202110261045||ORU^R01|116182217|P|2.3|1||AL' has application 'WinPath' and facility 'RAJ01' (in this case fcaility is the hospital code but that is not guaranteed), and at Kings e.g. 'MSH|^~&|HM|LBE|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||' contains application 'HM' and facility 'LBE'. Defining in this table the expected HL7 sending facilities (and optional applications) allows us to use these definitions when creating OBX mappings - for instance we can delcare that the OBX code 'HB' from sending facility 'RAJ32' should map to the observation description with code 'HGB'.", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "sending_application", default: "*", null: false, comment: "From MSH segment"
    t.string "sending_facility", null: false, comment: "From MSH segment"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["sending_facility", "sending_application"], name: "pathology_senders_idx", unique: true
  end

  create_table "renalware.pathology_versions", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_pathology_versions_on_item_type_and_item_id"
  end

  create_table "renalware.patient_alerts", force: :cascade do |t|
    t.boolean "covid_19", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.text "notes"
    t.bigint "patient_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.boolean "urgent", default: false, null: false
    t.index ["created_by_id"], name: "index_patient_alerts_on_created_by_id"
    t.index ["deleted_at"], name: "index_patient_alerts_on_deleted_at"
    t.index ["patient_id"], name: "index_patient_alerts_on_patient_id"
    t.index ["updated_by_id"], name: "index_patient_alerts_on_updated_by_id"
  end

  create_table "renalware.patient_attachment_types", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "description"
    t.string "name", null: false
    t.boolean "store_file_externally", default: false, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_patient_attachment_types_on_deleted_at"
    t.index ["name"], name: "index_patient_attachment_types_on_name", unique: true
  end

  create_table "renalware.patient_attachments", force: :cascade do |t|
    t.bigint "attachment_type_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id"
    t.datetime "deleted_at", precision: nil
    t.text "description"
    t.date "document_date"
    t.string "external_location"
    t.string "name"
    t.bigint "patient_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id"
    t.index ["attachment_type_id"], name: "index_patient_attachments_on_attachment_type_id"
    t.index ["created_by_id"], name: "index_patient_attachments_on_created_by_id"
    t.index ["deleted_at"], name: "index_patient_attachments_on_deleted_at"
    t.index ["document_date"], name: "index_patient_attachments_on_document_date"
    t.index ["name"], name: "index_patient_attachments_on_name"
    t.index ["patient_id"], name: "index_patient_attachments_on_patient_id"
    t.index ["updated_by_id"], name: "index_patient_attachments_on_updated_by_id"
  end

  create_table "renalware.patient_bookmarks", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.text "notes"
    t.integer "patient_id", null: false
    t.string "tags"
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "urgent", default: false, null: false
    t.integer "user_id", null: false
    t.index "patient_id, user_id, COALESCE(deleted_at, '1970-01-01 00:00:00'::timestamp without time zone)", name: "patient_bookmarks_uniqueness", unique: true
    t.index ["deleted_at"], name: "index_patient_bookmarks_on_deleted_at", where: "(deleted_at IS NULL)"
    t.index ["patient_id"], name: "index_patient_bookmarks_on_patient_id"
    t.index ["urgent"], name: "index_patient_bookmarks_on_urgent"
    t.index ["user_id"], name: "index_patient_bookmarks_on_user_id"
  end

  create_table "renalware.patient_ethnicities", id: :serial, force: :cascade do |t|
    t.string "cfh_name"
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.string "rr18_code"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["cfh_name"], name: "index_patient_ethnicities_on_cfh_name"
  end

  create_table "renalware.patient_languages", id: :serial, force: :cascade do |t|
    t.string "code"
    t.string "name", null: false
    t.index ["code"], name: "index_patient_languages_on_code", unique: true
  end

  create_table "renalware.patient_marital_statuses", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_patient_marital_statuses_on_code", unique: true
  end

  create_table "renalware.patient_master_index_deprecated", force: :cascade do |t|
    t.date "born_on"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "died_at", precision: nil
    t.string "ethnicity"
    t.string "family_name"
    t.string "given_name"
    t.string "gp_code"
    t.string "hospital_number"
    t.string "middle_name"
    t.string "nhs_number"
    t.bigint "patient_id"
    t.string "practice_code"
    t.string "sex"
    t.string "suffix"
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["hospital_number"], name: "index_patient_master_index_deprecated_on_hospital_number"
    t.index ["nhs_number"], name: "index_patient_master_index_deprecated_on_nhs_number"
    t.index ["patient_id"], name: "index_patient_master_index_deprecated_on_patient_id"
  end

  create_table "renalware.patient_merge_logs", comment: "Logs of individual record updates made as part of a patient merge operation. Each record indicates that a record in some table had its patient_id (or other FK column as specified in the merge_operation.column_name) updated from the minor patient to the major patient.", force: :cascade do |t|
    t.integer "id_of_updated_record", null: false
    t.bigint "operation_id", null: false
    t.index ["operation_id", "id_of_updated_record"], name: "index_merge_operation_logs_on_ids"
    t.index ["operation_id"], name: "index_patient_merge_logs_on_operation_id"
  end

  create_table "renalware.patient_merge_merges", comment: "Record and status of patient merges from external systems, such as HL7 A34 or A40 messages. See A34 or A40 HL7 online spec for an understanding of major and minor patients. Supports one merge pair at a time (a major patient and a minor patient) as per spec. If the upstream EPR requires multiple minors then they will send multiple messages. Note that we only create a row in this table if, on receipt of an A34 or A40 message, we were able to find both the major and minor patients in our system.", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "failure_message", comment: "Populated when status is 'failed'"
    t.bigint "feed_message_id", comment: "The feed message that triggered this merge"
    t.bigint "major_patient_id", null: false, comment: "The patient that the minor patient was merged into"
    t.enum "message_type", null: false, comment: "The type of merge message, e.g., 'A34' or 'A40'", enum_type: "patient_merge_message_types"
    t.bigint "minor_patient_id", null: false, comment: "The patient that was merged into the major patient"
    t.integer "operations_count", default: 0, null: false
    t.enum "source", null: false, comment: "The source system of the merge, e.g., 'HL7'", enum_type: "patient_merge_sources"
    t.enum "status", default: "in_progress", null: false, comment: "The status of the merge, e.g., 'in_progress'", enum_type: "patient_merge_statuses"
    t.datetime "updated_at", null: false
    t.index ["feed_message_id"], name: "index_patient_merge_merges_on_feed_message_id"
    t.index ["major_patient_id"], name: "index_patient_merge_merges_on_major_patient_id"
    t.index ["minor_patient_id"], name: "index_patient_merge_merges_on_minor_patient_id"
  end

  create_table "renalware.patient_merge_operations", comment: "Belongs to a PatientMerge::Merge and records the result of attempting to update a particular table.column that has a foreign key to renalware.patients.id. If merged is true, updated_count records how many rows were updated to point to the surviving patient (may be 0). The warnings column may contain any warnings that were generated during the merge operation. These can be present even if merged is true. This list of operations with warnings can be used to inform the user of any potential issues they may need to check after the merge.", force: :cascade do |t|
    t.string "column_name", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "merge_id", null: false
    t.boolean "merged", null: false
    t.boolean "require_intervention", default: false, null: false
    t.string "schema_name", null: false
    t.string "table_name", null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "updated_count", default: 0, null: false
    t.text "warning"
    t.index ["merge_id", "schema_name", "table_name", "column_name"], name: "index_patient_merge_operations_on_merge_and_schema_and_table", unique: true
    t.index ["merge_id"], name: "index_patient_merge_operations_on_merge_id"
  end

  create_table "renalware.patient_merge_rules", comment: "Specifies actions to take for a specific schema.table when doing a patient merge (eg HL7 A34). A * in the table_name indicates all tables in the schema that have a patient_id column and are not otherwise specified. Possible values are eg to merge silently, merge but warn the user that some interaction may be required, skip this table etc. See model for details.", force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.boolean "merge", default: true, null: false
    t.string "schema_name", null: false
    t.string "table_name", null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.text "warning_message", comment: "Displayed to the user if present after a merge"
    t.index ["schema_name", "table_name"], name: "index_patient_merge_rules_on_schema_name_and_table_name", unique: true
  end

  create_table "renalware.patient_practice_memberships", id: :serial, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", precision: nil, null: false
    t.boolean "default_gp", default: false, null: false, comment: "A membership with default_gp=true will be the default GP for a Practice in case the patient has no specific PrimaryCarePhysician assigned (one is required for letters etc). Only one (undeleted) membership per Practice can have default_gp=true. Generally this will be assigned to the system-level Generic PrimaryCarePhysician unless a specific PrimaryCarePhysician is assigned as default."
    t.datetime "deleted_at", precision: nil
    t.date "joined_on"
    t.date "last_change_date"
    t.date "left_on"
    t.integer "practice_id", null: false
    t.integer "primary_care_physician_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["default_gp", "practice_id"], name: "index_unique_default_gp_per_practice", unique: true, where: "((default_gp = true) AND (deleted_at IS NULL))"
    t.index ["deleted_at"], name: "index_patient_practice_memberships_on_deleted_at"
    t.index ["practice_id", "primary_care_physician_id"], name: "idx_practice_membership", unique: true
    t.index ["practice_id"], name: "index_patient_practice_memberships_on_practice_id"
    t.index ["primary_care_physician_id"], name: "index_patient_practice_memberships_on_primary_care_physician_id"
  end

  create_table "renalware.patient_practices", id: :serial, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "code", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "email"
    t.date "last_change_date"
    t.string "mesh_mailbox_description", comment: "Mailbox description eg GP Connect TPP Mailbox One.\nPopulated by a call to MESHAPI endpointlookup.\n"
    t.string "mesh_mailbox_id", comment: "e.g. YGM24GPXXX. Populated by a call to MESHAPI endpointlookup.\nUsed when sending letters using TransferOfCare via MESH.\n"
    t.string "name", null: false
    t.string "telephone"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_patient_practices_on_code", unique: true
  end

  create_table "renalware.patient_primary_care_physicians", id: :serial, force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "family_name"
    t.string "given_name"
    t.string "name"
    t.string "practitioner_type", null: false
    t.string "telephone"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_patient_primary_care_physicians_on_code", unique: true
    t.index ["deleted_at"], name: "index_patient_primary_care_physicians_on_deleted_at"
    t.index ["name"], name: "index_patient_primary_care_physicians_on_name"
  end

  create_table "renalware.patient_religions", id: :serial, force: :cascade do |t|
    t.string "code", comment: "eg 'E' for 'Jain'"
    t.string "name", null: false
    t.index ["code"], name: "index_patient_religions_on_code"
  end

  create_table "renalware.patient_versions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "patient_versions_versions_type_id"
  end

  create_table "renalware.patient_worries", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.datetime "deleted_at"
    t.text "notes"
    t.integer "patient_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.bigint "worry_category_id"
    t.index ["created_by_id"], name: "index_patient_worries_on_created_by_id"
    t.index ["deleted_at"], name: "index_patient_worries_on_deleted_at"
    t.index ["patient_id"], name: "index_patient_worries_on_patient_id", unique: true, where: "(deleted_at IS NULL)"
    t.index ["updated_by_id"], name: "index_patient_worries_on_updated_by_id"
    t.index ["worry_category_id"], name: "index_patient_worries_on_worry_category_id"
  end

  create_table "renalware.patient_worry_categories", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id", null: false
    t.integer "worries_count", default: 0, null: false, comment: "Counter cache for the number of worries with this category"
    t.index ["created_by_id"], name: "index_patient_worry_categories_on_created_by_id"
    t.index ["deleted_at"], name: "index_patient_worry_categories_on_deleted_at"
    t.index ["name"], name: "index_patient_worry_categories_on_name", unique: true, where: "(deleted_at IS NULL)", comment: "Disallow duplicate undeleted names"
    t.index ["updated_by_id"], name: "index_patient_worry_categories_on_updated_by_id"
  end

  create_table "renalware.patients", id: :serial, force: :cascade do |t|
    t.bigint "actual_death_location_id"
    t.string "allergy_status", default: "unrecorded", null: false
    t.datetime "allergy_status_updated_at", precision: nil
    t.date "born_on", null: false
    t.date "cc_decision_on"
    t.boolean "cc_on_all_letters", default: true, null: false
    t.datetime "checked_for_ukrdc_changes_at", precision: nil
    t.enum "confidentiality", default: "normal", null: false, comment: "Correspondence will not be sent via GP Connect if set to restricted", enum_type: "enum_confidentiality"
    t.integer "country_of_birth_id"
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.text "death_notes"
    t.date "died_on"
    t.jsonb "document"
    t.string "ehr_person_identifier", comment: "For use with an EHR eg Millennium. This is a unique identifier for the patient in the EHR system, and maybe be populated during the HL7 ingestion that creates the patient. SHould not be searchable from, or displayed in, the UI."
    t.string "email"
    t.integer "ethnicity_id"
    t.string "external_patient_id"
    t.string "family_name", null: false
    t.integer "first_cause_id"
    t.string "given_name", null: false
    t.string "hospital_centre_code"
    t.bigint "hospital_centre_id"
    t.integer "language_id"
    t.integer "legacy_patient_id"
    t.string "local_patient_id"
    t.string "local_patient_id_2"
    t.string "local_patient_id_3"
    t.string "local_patient_id_4"
    t.string "local_patient_id_5"
    t.string "marital_status"
    t.bigint "marital_status_id"
    t.datetime "merged_at"
    t.bigint "merged_into_patient_id", comment: "After an HL7 A34 or A40 merge, points to the major patient\nthat this minor patient was merged into\n"
    t.bigint "named_consultant_id"
    t.bigint "named_nurse_id"
    t.text "next_of_kin", comment: "Next of kin details from HL7 NK1 segments"
    t.text "next_of_kin_notes", comment: "Manually entered next of kin details, not from HL7"
    t.string "nhs_number"
    t.boolean "paediatric_patient_indicator", default: false, null: false
    t.integer "practice_id"
    t.bigint "preferred_death_location_id"
    t.text "preferred_death_location_notes"
    t.integer "primary_care_physician_id"
    t.string "primary_esrf_centre"
    t.integer "religion_id"
    t.string "renal_registry_id"
    t.date "renalreg_decision_on"
    t.string "renalreg_recorded_by"
    t.date "rpv_decision_on"
    t.string "rpv_recorded_by"
    t.integer "second_cause_id"
    t.uuid "secure_id", default: -> { "public.uuid_generate_v4()" }, null: false
    t.boolean "send_to_renalreg", default: false, null: false
    t.boolean "send_to_rpv", default: false, null: false
    t.datetime "sent_to_ukrdc_at", precision: nil
    t.string "sex"
    t.string "suffix"
    t.string "telephone1"
    t.string "telephone2"
    t.string "title"
    t.boolean "ukrdc_anonymise", default: false, null: false
    t.date "ukrdc_anonymise_decision_on"
    t.string "ukrdc_anonymise_recorded_by"
    t.text "ukrdc_external_id", default: -> { "public.uuid_generate_v4()" }
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index "lower((family_name)::text), given_name", name: "idx_patients_on_lower_family_name"
    t.index ["actual_death_location_id"], name: "index_patients_on_actual_death_location_id"
    t.index ["country_of_birth_id"], name: "index_patients_on_country_of_birth_id"
    t.index ["created_by_id"], name: "index_patients_on_created_by_id"
    t.index ["document"], name: "index_patients_on_document", using: :gin
    t.index ["ehr_person_identifier"], name: "index_patients_on_ehr_person_identifier", unique: true
    t.index ["ethnicity_id"], name: "index_patients_on_ethnicity_id"
    t.index ["external_patient_id"], name: "index_patients_on_external_patient_id"
    t.index ["first_cause_id"], name: "index_patients_on_first_cause_id"
    t.index ["hospital_centre_id"], name: "index_patients_on_hospital_centre_id"
    t.index ["language_id"], name: "index_patients_on_language_id"
    t.index ["legacy_patient_id"], name: "index_patients_on_legacy_patient_id", unique: true
    t.index ["local_patient_id"], name: "index_patients_on_local_patient_id", unique: true
    t.index ["local_patient_id_2"], name: "index_patients_on_local_patient_id_2", unique: true
    t.index ["local_patient_id_3"], name: "index_patients_on_local_patient_id_3", unique: true
    t.index ["local_patient_id_4"], name: "index_patients_on_local_patient_id_4", unique: true
    t.index ["local_patient_id_5"], name: "index_patients_on_local_patient_id_5", unique: true
    t.index ["marital_status_id"], name: "index_patients_on_marital_status_id"
    t.index ["merged_at"], name: "index_patients_on_merged_at", where: "(merged_at IS NULL)"
    t.index ["merged_into_patient_id"], name: "index_patients_on_merged_into_patient_id"
    t.index ["named_consultant_id"], name: "index_patients_on_named_consultant_id"
    t.index ["named_nurse_id"], name: "index_patients_on_named_nurse_id"
    t.index ["practice_id"], name: "index_patients_on_practice_id"
    t.index ["preferred_death_location_id"], name: "index_patients_on_preferred_death_location_id"
    t.index ["primary_care_physician_id"], name: "index_patients_on_primary_care_physician_id"
    t.index ["religion_id"], name: "index_patients_on_religion_id"
    t.index ["renal_registry_id"], name: "index_patients_on_renal_registry_id", unique: true
    t.index ["second_cause_id"], name: "index_patients_on_second_cause_id"
    t.index ["secure_id"], name: "index_patients_on_secure_id", unique: true
    t.index ["send_to_renalreg"], name: "index_patients_on_send_to_renalreg"
    t.index ["send_to_rpv"], name: "index_patients_on_send_to_rpv"
    t.index ["sent_to_ukrdc_at"], name: "index_patients_on_sent_to_ukrdc_at"
    t.index ["ukrdc_anonymise"], name: "index_patients_on_ukrdc_anonymise"
    t.index ["ukrdc_external_id"], name: "index_patients_on_ukrdc_external_id", unique: true
    t.index ["updated_by_id"], name: "index_patients_on_updated_by_id"
  end

  create_table "renalware.pd_adequacy_results", force: :cascade do |t|
    t.boolean "complete", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.boolean "dial_24_missing", default: false, null: false
    t.integer "dial_24_vol_in"
    t.integer "dial_24_vol_out"
    t.float "dialysate_creatinine"
    t.float "dialysate_glu"
    t.float "dialysate_na"
    t.float "dialysate_protein"
    t.float "dialysate_urea"
    t.float "dietry_protein_intake"
    t.float "height"
    t.bigint "patient_id", null: false
    t.date "performed_on", null: false
    t.float "pertitoneal_creatinine_clearance"
    t.float "pertitoneal_ktv"
    t.float "plasma_glc"
    t.float "renal_creatinine_clearance"
    t.float "renal_ktv"
    t.float "serum_ab"
    t.float "serum_creatinine"
    t.float "serum_urea"
    t.float "total_creatinine_clearance"
    t.float "total_ktv"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id", null: false
    t.boolean "urine_24_missing", default: false, null: false
    t.integer "urine_24_vol"
    t.float "urine_creatinine"
    t.float "urine_k"
    t.float "urine_na"
    t.float "urine_urea"
    t.float "weight"
    t.index ["created_by_id"], name: "index_pd_adequacy_results_on_created_by_id"
    t.index ["deleted_at"], name: "index_pd_adequacy_results_on_deleted_at"
    t.index ["patient_id"], name: "index_pd_adequacy_results_on_patient_id"
    t.index ["updated_by_id"], name: "index_pd_adequacy_results_on_updated_by_id"
  end

  create_table "renalware.pd_assessments", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.jsonb "document"
    t.integer "patient_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_pd_assessments_on_created_by_id"
    t.index ["patient_id"], name: "index_pd_assessments_on_patient_id"
    t.index ["updated_by_id"], name: "index_pd_assessments_on_updated_by_id"
  end

  create_table "renalware.pd_bag_types", id: :serial, force: :cascade do |t|
    t.boolean "amino_acid"
    t.integer "bicarbonate_content"
    t.decimal "calcium_content", precision: 3, scale: 2
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "description", null: false
    t.decimal "glucose_content", precision: 4, scale: 2, null: false
    t.integer "glucose_strength", null: false
    t.boolean "icodextrin"
    t.integer "lactate_content"
    t.boolean "low_glucose_degradation"
    t.boolean "low_sodium"
    t.decimal "magnesium_content", precision: 3, scale: 2
    t.string "manufacturer", null: false
    t.integer "sodium_content"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_pd_bag_types_on_deleted_at"
  end

  create_table "renalware.pd_exit_site_infections", id: :serial, force: :cascade do |t|
    t.boolean "catheter_removed"
    t.boolean "cleared"
    t.string "clinical_presentation", array: true
    t.datetime "created_at", precision: nil, null: false
    t.date "diagnosis_date", null: false
    t.text "notes"
    t.text "outcome"
    t.integer "patient_id", null: false
    t.boolean "recurrent"
    t.text "treatment"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["clinical_presentation"], name: "index_pd_exit_site_infections_on_clinical_presentation", using: :gin
    t.index ["patient_id"], name: "index_pd_exit_site_infections_on_patient_id"
  end

  create_table "renalware.pd_fluid_descriptions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "description"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "renalware.pd_infection_organisms", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "infectable_id"
    t.string "infectable_type"
    t.integer "organism_code_id", null: false
    t.text "resistance"
    t.text "sensitivity"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["infectable_id", "infectable_type"], name: "idx_infection_organisms_type"
    t.index ["organism_code_id", "infectable_id", "infectable_type"], name: "idx_infection_organisms", unique: true
  end

  create_table "renalware.pd_organism_codes", id: :serial, force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "renalware.pd_peritonitis_episode_type_descriptions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "definition"
    t.datetime "deleted_at", precision: nil
    t.string "term"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "renalware.pd_peritonitis_episode_types", id: :serial, force: :cascade do |t|
    t.integer "peritonitis_episode_id", null: false
    t.integer "peritonitis_episode_type_description_id", null: false
    t.index ["peritonitis_episode_id", "peritonitis_episode_type_description_id"], name: "pd_peritonitis_episode_types_unique_id", unique: true
    t.index ["peritonitis_episode_type_description_id"], name: "index_pd_peritonitis_episode_types_description_id"
  end

  create_table "renalware.pd_peritonitis_episodes", id: :serial, force: :cascade do |t|
    t.boolean "abdominal_pain"
    t.boolean "catheter_removed"
    t.datetime "created_at", precision: nil, null: false
    t.date "diagnosis_date", null: false
    t.boolean "diarrhoea"
    t.integer "episode_type_id"
    t.boolean "exit_site_infection"
    t.integer "fluid_description_id"
    t.boolean "line_break"
    t.text "notes"
    t.integer "patient_id", null: false
    t.date "treatment_end_date"
    t.date "treatment_start_date"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "white_cell_degen"
    t.integer "white_cell_lympho"
    t.integer "white_cell_neutro"
    t.integer "white_cell_other"
    t.integer "white_cell_total"
    t.index ["episode_type_id"], name: "index_pd_peritonitis_episodes_on_episode_type_id"
    t.index ["fluid_description_id"], name: "index_pd_peritonitis_episodes_on_fluid_description_id"
    t.index ["patient_id"], name: "index_pd_peritonitis_episodes_on_patient_id"
  end

  create_table "renalware.pd_pet_adequacy_results", id: :serial, force: :cascade do |t|
    t.date "adequacy_date"
    t.integer "crcl_dialysate"
    t.integer "crcl_rrf"
    t.integer "crcl_total"
    t.integer "creat_value"
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.integer "daily_uf"
    t.integer "daily_urine"
    t.date "date_creat_clearance"
    t.date "date_creat_value"
    t.date "date_rff"
    t.decimal "dialysate_creat_plasma_ratio", precision: 8, scale: 2
    t.decimal "dialysate_effluent_volume", precision: 8, scale: 2
    t.decimal "dialysate_glucose_end", precision: 8, scale: 1
    t.decimal "dialysate_glucose_start", precision: 8, scale: 1
    t.decimal "dietry_protein_intake", precision: 8, scale: 2
    t.decimal "ktv_dialysate", precision: 8, scale: 2
    t.decimal "ktv_rrf", precision: 8, scale: 2
    t.decimal "ktv_total", precision: 8, scale: 2
    t.integer "patient_id", null: false
    t.date "pet_date"
    t.decimal "pet_duration", precision: 8, scale: 1
    t.integer "pet_net_uf"
    t.string "pet_type"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.integer "urine_creat_conc"
    t.decimal "urine_urea_conc", precision: 8, scale: 1
    t.index ["created_by_id"], name: "index_pd_pet_adequacy_results_on_created_by_id"
    t.index ["patient_id"], name: "index_pd_pet_adequacy_results_on_patient_id"
    t.index ["updated_by_id"], name: "index_pd_pet_adequacy_results_on_updated_by_id"
  end

  create_table "renalware.pd_pet_dextrose_concentrations", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.boolean "hidden", default: false, null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.float "value", null: false
    t.index ["name"], name: "index_pd_pet_dextrose_concentrations_on_name", unique: true
    t.index ["value"], name: "index_pd_pet_dextrose_concentrations_on_value", unique: true
  end

  create_table "renalware.pd_pet_results", force: :cascade do |t|
    t.boolean "complete", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id", null: false
    t.float "d_pcr"
    t.datetime "deleted_at", precision: nil
    t.bigint "dextrose_concentration_id"
    t.integer "drain_time"
    t.integer "infusion_time"
    t.integer "net_uf"
    t.bigint "overnight_dextrose_concentration_id"
    t.integer "overnight_dwell_time"
    t.integer "overnight_volume_in"
    t.integer "overnight_volume_out"
    t.bigint "patient_id", null: false
    t.date "performed_on", null: false
    t.float "plasma_glc"
    t.float "sample_0hr_creatinine"
    t.float "sample_0hr_glc"
    t.float "sample_0hr_protein"
    t.float "sample_0hr_sodium"
    t.float "sample_0hr_time"
    t.float "sample_0hr_urea"
    t.float "sample_2hr_creatinine"
    t.float "sample_2hr_glc"
    t.float "sample_2hr_protein"
    t.float "sample_2hr_sodium"
    t.float "sample_2hr_time"
    t.float "sample_2hr_urea"
    t.float "sample_4hr_creatinine"
    t.float "sample_4hr_glc"
    t.float "sample_4hr_protein"
    t.float "sample_4hr_sodium"
    t.float "sample_4hr_time"
    t.float "sample_4hr_urea"
    t.float "sample_6hr_creatinine"
    t.float "sample_6hr_glc"
    t.float "sample_6hr_protein"
    t.float "sample_6hr_sodium"
    t.float "sample_6hr_time"
    t.float "sample_6hr_urea"
    t.float "serum_ab"
    t.float "serum_creatinine"
    t.float "serum_na"
    t.float "serum_time"
    t.float "serum_urea"
    t.enum "test_type", null: false, enum_type: "pd_pet_type"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id", null: false
    t.integer "volume_in"
    t.integer "volume_out"
    t.index ["created_by_id"], name: "index_pd_pet_results_on_created_by_id"
    t.index ["deleted_at"], name: "index_pd_pet_results_on_deleted_at"
    t.index ["dextrose_concentration_id"], name: "index_pd_pet_results_on_dextrose_concentration_id"
    t.index ["overnight_dextrose_concentration_id"], name: "index_pd_pet_results_on_overnight_dextrose_concentration_id"
    t.index ["patient_id"], name: "index_pd_pet_results_on_patient_id"
    t.index ["updated_by_id"], name: "index_pd_pet_results_on_updated_by_id"
  end

  create_table "renalware.pd_regime_bags", id: :serial, force: :cascade do |t|
    t.integer "bag_type_id", null: false
    t.boolean "capd_overnight_bag", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.boolean "friday"
    t.boolean "monday"
    t.integer "per_week"
    t.integer "regime_id", null: false
    t.string "role"
    t.boolean "saturday"
    t.boolean "sunday"
    t.boolean "thursday"
    t.boolean "tuesday"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "volume", null: false
    t.boolean "wednesday"
    t.index ["bag_type_id"], name: "index_pd_regime_bags_on_bag_type_id"
    t.index ["regime_id"], name: "index_pd_regime_bags_on_regime_id"
  end

  create_table "renalware.pd_regime_terminations", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.integer "regime_id", null: false
    t.date "terminated_on", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_pd_regime_terminations_on_created_by_id"
    t.index ["regime_id"], name: "index_pd_regime_terminations_on_regime_id"
    t.index ["updated_by_id"], name: "index_pd_regime_terminations_on_updated_by_id"
  end

  create_table "renalware.pd_regimes", id: :serial, force: :cascade do |t|
    t.boolean "add_hd"
    t.integer "additional_manual_exchange_volume"
    t.integer "amino_acid_volume"
    t.string "apd_machine_pac"
    t.string "assistance_type"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id"
    t.integer "daily_volume"
    t.string "delivery_interval"
    t.integer "dwell_time"
    t.date "end_date"
    t.string "exchanges_done_by"
    t.string "exchanges_done_by_if_other"
    t.text "exchanges_done_by_notes"
    t.integer "fill_volume"
    t.integer "glucose_volume_high_strength"
    t.integer "glucose_volume_low_strength"
    t.integer "glucose_volume_medium_strength"
    t.integer "icodextrin_volume"
    t.integer "last_fill_volume"
    t.integer "no_cycles_per_apd"
    t.integer "overnight_volume"
    t.integer "patient_id", null: false
    t.date "start_date", null: false
    t.integer "system_id"
    t.integer "therapy_time"
    t.boolean "tidal_full_drain_every_three_cycles", default: true
    t.boolean "tidal_indicator"
    t.integer "tidal_percentage"
    t.string "treatment", null: false
    t.string "type"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_pd_regimes_on_created_by_id"
    t.index ["id", "type"], name: "index_pd_regimes_on_id_and_type"
    t.index ["patient_id"], name: "index_pd_regimes_on_patient_id"
    t.index ["system_id"], name: "index_pd_regimes_on_system_id"
    t.index ["updated_by_id"], name: "index_pd_regimes_on_updated_by_id"
  end

  create_table "renalware.pd_systems", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "name", null: false
    t.string "pd_type", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_pd_systems_on_deleted_at"
    t.index ["pd_type"], name: "index_pd_systems_on_pd_type"
  end

  create_table "renalware.pd_training_sessions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.jsonb "document"
    t.integer "patient_id", null: false
    t.integer "training_site_id", null: false
    t.integer "training_type_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_pd_training_sessions_on_created_by_id"
    t.index ["patient_id"], name: "index_pd_training_sessions_on_patient_id"
    t.index ["training_site_id"], name: "index_pd_training_sessions_on_training_site_id"
    t.index ["training_type_id"], name: "index_pd_training_sessions_on_training_type_id"
    t.index ["updated_by_id"], name: "index_pd_training_sessions_on_updated_by_id"
  end

  create_table "renalware.pd_training_sites", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "renalware.pd_training_types", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "renalware.problem_comorbidities", comment: "A single comobidity problem for a patient. A patient can only have one per description", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id", null: false
    t.bigint "description_id", null: false
    t.string "diabetes_type"
    t.bigint "malignancy_site_id"
    t.bigint "patient_id", null: false
    t.enum "recognised", default: "unknown", null: false, enum_type: "tristate_type"
    t.date "recognised_at", comment: "Note often only year is known"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_problem_comorbidities_on_created_by_id"
    t.index ["description_id"], name: "index_problem_comorbidities_on_description_id"
    t.index ["malignancy_site_id"], name: "index_problem_comorbidities_on_malignancy_site_id"
    t.index ["patient_id", "description_id"], name: "index_problem_comorbidities_on_patient_id_and_description_id", unique: true, comment: "Only 1 unique description allowed per patient"
    t.index ["patient_id"], name: "index_problem_comorbidities_on_patient_id"
    t.index ["updated_by_id"], name: "index_problem_comorbidities_on_updated_by_id"
  end

  create_table "renalware.problem_comorbidity_descriptions", comment: "The supported list of cormbidities that can be recorded for a patient", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.boolean "has_diabetes_type", default: false, null: false
    t.boolean "has_malignancy_site", default: false, null: false
    t.text "name", null: false
    t.integer "position", default: 0, null: false, comment: "Display order"
    t.string "snomed_code", comment: "Used in UKRDC exports"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_problem_comorbidity_descriptions_on_deleted_at"
    t.index ["name"], name: "index_problem_comorbidity_descriptions_on_name", unique: true, where: "(deleted_at IS NULL)"
    t.index ["position"], name: "index_problem_comorbidity_descriptions_on_position"
  end

  create_table "renalware.problem_malignancy_sites", force: :cascade do |t|
    t.text "description", null: false
    t.string "rr_19_code", comment: "Renal Registry dataset v5 RR19 code"
    t.index ["description"], name: "index_problem_malignancy_sites_on_description", unique: true
  end

  create_table "renalware.problem_notes", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.text "description", null: false
    t.integer "problem_id"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_problem_notes_on_created_by_id"
    t.index ["deleted_at"], name: "index_problem_notes_on_deleted_at"
    t.index ["problem_id"], name: "index_problem_notes_on_problem_id"
    t.index ["updated_by_id"], name: "index_problem_notes_on_updated_by_id"
  end

  create_table "renalware.problem_problems", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.date "date"
    t.enum "date_display_style", enum_type: "problem_date_display_style_enum"
    t.datetime "deleted_at", precision: nil
    t.string "description", null: false
    t.integer "patient_id", null: false
    t.integer "position", default: 0, null: false
    t.string "snomed_id"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id"
    t.index ["created_by_id"], name: "index_problem_problems_on_created_by_id"
    t.index ["deleted_at"], name: "index_problem_problems_on_deleted_at"
    t.index ["patient_id"], name: "index_problem_problems_on_patient_id"
    t.index ["position"], name: "index_problem_problems_on_position"
    t.index ["updated_by_id"], name: "index_problem_problems_on_updated_by_id"
  end

  create_table "renalware.problem_radar_cohorts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_problem_radar_cohorts_on_name", unique: true
  end

  create_table "renalware.problem_radar_diagnoses", force: :cascade do |t|
    t.bigint "cohort_id", null: false
    t.datetime "created_at", null: false
    t.text "description_regex", comment: "Optional regex eg 'AH (amyloidosis|amylidos.*)' against which patient problem descriptions will be matched (in addition to matching purely against the diagnosis.name) when trying to ascertain if the patient has this rare renal diagnosis. Supporting regexes allows for problem variants and for spelling mistakes in non-SNOMED coded problems."
    t.string "name", null: false
    t.text "snomed_regex", comment: "Optional regex eg '(123123|345345|123123123123.*)' against which patient problem snomed_codes will be matched (in addition to matching purely against the diagnosis.name) when trying to ascertain if the patient has this rare renal disease. Supporting regexes allows us to match a problem that has a SNOMED code that is the exact match, parent or child of the target RaDaR diagnosis SNOMED code."
    t.datetime "updated_at", null: false
    t.index ["cohort_id", "name"], name: "index_problem_radar_diagnoses_on_cohort_id_and_name", unique: true
    t.index ["cohort_id"], name: "index_problem_radar_diagnoses_on_cohort_id"
  end

  create_table "renalware.problem_versions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_problem_versions_on_item_type_and_item_id"
  end

  create_table "renalware.remote_monitoring_frequencies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.interval "period", null: false
    t.integer "position", default: 1, null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_remote_monitoring_frequencies_on_deleted_at"
    t.index ["period"], name: "index_remote_monitoring_frequencies_on_period", unique: true, where: "(deleted_at IS NULL)"
    t.index ["position"], name: "index_remote_monitoring_frequencies_on_position"
  end

  create_table "renalware.remote_monitoring_referral_reasons", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.text "description", null: false
    t.integer "position", default: 1, null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_remote_monitoring_referral_reasons_on_deleted_at"
    t.index ["description"], name: "index_remote_monitoring_referral_reasons_on_description", unique: true, where: "(deleted_at IS NULL)"
    t.index ["position"], name: "index_remote_monitoring_referral_reasons_on_position"
  end

  create_table "renalware.renal_aki_alert_actions", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_renal_aki_alert_actions_on_name"
  end

  create_table "renalware.renal_aki_alerts", force: :cascade do |t|
    t.string "action"
    t.bigint "action_id"
    t.date "aki_date"
    t.date "cre_date"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id"
    t.bigint "hospital_centre_id"
    t.bigint "hospital_ward_id"
    t.boolean "hotlist", default: false, null: false
    t.integer "max_aki"
    t.integer "max_cre"
    t.text "notes"
    t.bigint "patient_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id"
    t.index ["action"], name: "index_renal_aki_alerts_on_action"
    t.index ["action_id"], name: "index_renal_aki_alerts_on_action_id"
    t.index ["created_by_id"], name: "index_renal_aki_alerts_on_created_by_id"
    t.index ["hospital_centre_id"], name: "index_renal_aki_alerts_on_hospital_centre_id"
    t.index ["hospital_ward_id"], name: "index_renal_aki_alerts_on_hospital_ward_id"
    t.index ["hotlist"], name: "index_renal_aki_alerts_on_hotlist"
    t.index ["patient_id"], name: "index_renal_aki_alerts_on_patient_id"
    t.index ["updated_by_id"], name: "index_renal_aki_alerts_on_updated_by_id"
  end

  create_table "renalware.renal_prd_descriptions", id: :serial, force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", precision: nil, null: false
    t.string "term"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_renal_prd_descriptions_on_code", unique: true
  end

  create_table "renalware.renal_profiles", id: :serial, force: :cascade do |t|
    t.date "comorbidities_updated_on"
    t.datetime "created_at", precision: nil, null: false
    t.jsonb "document"
    t.date "esrf_on"
    t.date "first_seen_on"
    t.string "modality_at_esrf"
    t.integer "patient_id", null: false
    t.integer "prd_description_id"
    t.datetime "updated_at", precision: nil, null: false
    t.float "weight_at_esrf"
    t.index ["document"], name: "index_renal_profiles_on_document", using: :gin
    t.index ["patient_id"], name: "index_renal_profiles_on_patient_id", unique: true
    t.index ["prd_description_id"], name: "index_renal_profiles_on_prd_description_id"
  end

  create_table "renalware.renal_versions", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_renal_versions_on_item_type_and_item_id"
  end

  create_table "renalware.reporting_audits", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.text "description"
    t.text "display_configuration", default: "{}", null: false
    t.boolean "enabled", default: true, null: false
    t.boolean "materialized", default: true, null: false
    t.string "name", null: false
    t.string "refresh_schedule", default: "1 0 * * 1-6"
    t.datetime "refreshed_at", precision: nil
    t.datetime "updated_at", precision: nil, null: false
    t.string "view_name", null: false
  end

  create_table "renalware.research_investigatorships", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.jsonb "document"
    t.date "left_on"
    t.boolean "manager", default: false, null: false
    t.date "started_on"
    t.bigint "study_id", null: false
    t.string "type"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id", null: false
    t.bigint "user_id", null: false
    t.index ["created_by_id"], name: "index_research_investigatorships_on_created_by_id"
    t.index ["deleted_at"], name: "index_research_investigatorships_on_deleted_at"
    t.index ["document"], name: "index_research_investigatorships_on_document", using: :gin
    t.index ["study_id"], name: "index_research_investigatorships_on_study_id"
    t.index ["updated_by_id"], name: "index_research_investigatorships_on_updated_by_id"
    t.index ["user_id"], name: "index_research_investigatorships_on_user_id"
  end

  create_table "renalware.research_participations", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id"
    t.datetime "deleted_at", precision: nil
    t.jsonb "document"
    t.text "external_id"
    t.integer "external_id_deprecated", comment: "Backup of external_id taken before changing its type from int to text"
    t.string "external_reference"
    t.date "joined_on", null: false
    t.date "left_on"
    t.bigint "patient_id", null: false
    t.bigint "study_id", null: false
    t.string "type"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_research_participations_on_created_by_id"
    t.index ["deleted_at"], name: "index_research_participations_on_deleted_at"
    t.index ["document"], name: "index_research_participations_on_document", using: :gin
    t.index ["external_id"], name: "index_research_participations_on_external_id", unique: true
    t.index ["patient_id", "study_id"], name: "unique_study_participants", unique: true, where: "(deleted_at IS NULL)"
    t.index ["patient_id"], name: "index_research_participations_on_patient_id"
    t.index ["study_id", "external_reference"], name: "idx_on_study_id_external_reference_a07278c0eb", unique: true, where: "((deleted_at IS NULL) AND ((COALESCE(external_reference, ''::character varying))::text <> ''::text))"
    t.index ["study_id"], name: "index_research_participations_on_study_id"
    t.index ["updated_by_id"], name: "index_research_participations_on_updated_by_id"
  end

  create_table "renalware.research_studies", force: :cascade do |t|
    t.string "application_url"
    t.string "code", null: false
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id"
    t.datetime "deleted_at", precision: nil
    t.string "description", null: false
    t.jsonb "document"
    t.string "leader"
    t.string "namespace"
    t.text "notes"
    t.boolean "private", default: false, null: false
    t.date "started_on"
    t.date "terminated_on"
    t.string "type"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id"
    t.index ["code"], name: "index_research_studies_on_code", unique: true, where: "(deleted_at IS NULL)"
    t.index ["created_by_id"], name: "index_research_studies_on_created_by_id"
    t.index ["deleted_at"], name: "index_research_studies_on_deleted_at"
    t.index ["description"], name: "index_research_studies_on_description"
    t.index ["document"], name: "index_research_studies_on_document", using: :gin
    t.index ["leader"], name: "index_research_studies_on_leader"
    t.index ["private"], name: "index_research_studies_on_private"
    t.index ["updated_by_id"], name: "index_research_studies_on_updated_by_id"
  end

  create_table "renalware.research_versions", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.integer "whodunnit"
    t.index ["item_type", "item_id"], name: "index_research_versions_on_item_type_and_item_id"
    t.index ["whodunnit"], name: "index_research_versions_on_whodunnit"
  end

  create_table "renalware.roles", id: :serial, force: :cascade do |t|
    t.string "ad_role_name"
    t.datetime "created_at", precision: nil, null: false
    t.boolean "enforce", default: false, null: false
    t.boolean "hidden", default: false, null: false
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "renalware.roles_users", force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
    t.index ["role_id"], name: "index_roles_users_on_role_id"
    t.index ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id", unique: true
  end

  create_table "renalware.snippets_snippets", force: :cascade do |t|
    t.integer "author_id", null: false
    t.text "body", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "last_used_on", precision: nil
    t.integer "times_used", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["author_id"], name: "index_snippets_snippets_on_author_id"
    t.index ["title"], name: "index_snippets_snippets_on_title"
  end

  create_table "renalware.survey_questions", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "label"
    t.string "label_abbrv", comment: "If populated, used instead of label when displaying the table, to save space"
    t.integer "position", default: 0, null: false
    t.bigint "survey_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "validation_regex"
    t.index ["code", "survey_id"], name: "index_survey_questions_on_code_and_survey_id", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_survey_questions_on_deleted_at"
    t.index ["position"], name: "index_survey_questions_on_position"
    t.index ["survey_id", "code"], name: "index_survey_questions_on_survey_id_and_code", unique: true, where: "(deleted_at IS NULL)"
    t.index ["survey_id"], name: "index_survey_questions_on_survey_id"
  end

  create_table "renalware.survey_responses", force: :cascade do |t|
    t.date "answered_on", null: false
    t.datetime "created_at", precision: nil, null: false
    t.bigint "patient_id", null: false
    t.text "patient_question_text"
    t.bigint "question_id", null: false
    t.string "reference"
    t.datetime "updated_at", precision: nil, null: false
    t.string "value"
    t.index ["answered_on", "patient_id", "question_id"], name: "survey_responses_compound_index"
    t.index ["patient_id"], name: "index_survey_responses_on_patient_id"
    t.index ["question_id"], name: "index_survey_responses_on_question_id"
  end

  create_table "renalware.survey_surveys", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "description"
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_survey_surveys_on_code", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_survey_surveys_on_deleted_at"
    t.index ["name"], name: "index_survey_surveys_on_name", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "renalware.system_api_logs", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.boolean "dry_run", default: false, null: false
    t.decimal "elapsed_ms", comment: "Used for benchmarking"
    t.text "error"
    t.string "identifier", null: false
    t.integer "pages", default: 0, null: false
    t.integer "records_added", default: 0, null: false
    t.integer "records_updated", default: 0, null: false
    t.string "status", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "values", default: [], array: true
    t.index ["identifier"], name: "index_system_api_logs_on_identifier"
    t.index ["status"], name: "index_system_api_logs_on_status"
  end

  create_table "renalware.system_components", comment: "Available ruby display widgets for use e.g. in dashboards", force: :cascade do |t|
    t.string "class_name", null: false, comment: "Component class eg Renalware::.."
    t.datetime "created_at", precision: nil
    t.boolean "dashboard", default: true, null: false, comment: "If true, can use on dashboards"
    t.string "name", null: false, comment: "Friendly component name e.g. 'Letters in Progress'"
    t.string "roles", comment: "Who can use or be assigned this component"
    t.datetime "updated_at", precision: nil
    t.index ["class_name"], name: "index_system_components_on_class_name"
    t.index ["name"], name: "index_system_components_on_name", unique: true
    t.index ["roles"], name: "index_system_components_on_roles"
  end

  create_table "renalware.system_countries", force: :cascade do |t|
    t.string "alpha2", null: false
    t.string "alpha3", null: false
    t.string "name", null: false
    t.integer "position"
    t.index ["alpha2"], name: "index_system_countries_on_alpha2"
    t.index ["alpha3"], name: "index_system_countries_on_alpha3"
    t.index ["name"], name: "index_system_countries_on_name", unique: true
    t.index ["position"], name: "index_system_countries_on_position"
  end

  create_table "renalware.system_dashboard_components", comment: "Defines dashboard content", force: :cascade do |t|
    t.bigint "component_id"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "dashboard_id"
    t.integer "position", default: 1, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["component_id"], name: "index_system_dashboard_components_on_component_id"
    t.index ["dashboard_id", "component_id"], name: "idx_dashboard_component_useage_unique", unique: true, comment: "Allow only one instance of a component on any dashboard"
    t.index ["dashboard_id", "position"], name: "idx_dashboard_component_position", unique: true, comment: "Position must be unique within a dashboard"
  end

  create_table "renalware.system_dashboards", force: :cascade do |t|
    t.bigint "cloned_from_dashboard_id", comment: "Is the user customised their dashboard we store the original here"
    t.datetime "created_at", precision: nil, null: false
    t.text "description"
    t.string "name", comment: "A named dashboard e.g. default, hd_nurse"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id", comment: "If present, this dashboard belongs to a user e.g. they have customised a named dashboard to make it their own"
    t.index ["cloned_from_dashboard_id"], name: "index_system_dashboards_on_cloned_from_dashboard_id"
    t.index ["name"], name: "index_system_dashboards_on_name", unique: true
    t.index ["user_id"], name: "index_system_dashboards_on_user_id", unique: true
  end

  create_table "renalware.system_downloads", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.string "description"
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id", null: false
    t.integer "view_count", default: 0, null: false
    t.index ["created_by_id"], name: "index_system_downloads_on_created_by_id"
    t.index ["deleted_at"], name: "index_system_downloads_on_deleted_at"
    t.index ["name"], name: "index_system_downloads_on_name", unique: true
    t.index ["updated_by_id"], name: "index_system_downloads_on_updated_by_id"
  end

  create_table "renalware.system_events", force: :cascade do |t|
    t.string "name"
    t.jsonb "properties"
    t.datetime "time", precision: nil
    t.bigint "user_id"
    t.bigint "visit_id"
    t.index ["name", "time"], name: "index_system_events_on_name_and_time"
    t.index ["properties"], name: "index_system_events_on_properties_jsonb_path_ops", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_system_events_on_user_id"
    t.index ["visit_id"], name: "index_system_events_on_visit_id"
  end

  create_table "renalware.system_logs", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.enum "group", default: "users", null: false, enum_type: "system_log_group"
    t.text "message"
    t.bigint "owner_id", comment: "Optional - if targetted at a specific user"
    t.enum "severity", default: "info", null: false, enum_type: "system_log_severity"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["group"], name: "index_system_logs_on_group"
    t.index ["owner_id"], name: "index_system_logs_on_owner_id"
    t.index ["severity"], name: "index_system_logs_on_severity"
  end

  create_table "renalware.system_messages", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "display_from", precision: nil, null: false
    t.datetime "display_until", precision: nil
    t.integer "message_type", default: 0, null: false
    t.string "severity"
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "renalware.system_nag_definitions", comment: "Registers a 'missing data nag' sql function and the text to display if the function evaluates to true", force: :cascade do |t|
    t.integer "always_expire_cache_after_minutes", default: 60, null: false, comment: "Number of minutes to cache this nag before the cache is automatically invalidated. The cache may be invalidated earlier if the nag_definition.updated_at or patient.updated_at timestamps change."
    t.datetime "created_at", precision: nil, null: false
    t.text "description", null: false
    t.boolean "enabled", default: true, null: false
    t.text "hint", comment: "May be displayed when hovering over the nag"
    t.integer "importance", default: 1, null: false
    t.text "relative_link"
    t.enum "scope", null: false, enum_type: "system_nag_definition_scope"
    t.text "sql_function_name", null: false
    t.text "title", comment: "If present, text eg ('CFS:') displayed to the left of the content in a nag"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["description"], name: "index_system_nag_definitions_on_description", unique: true
    t.index ["enabled"], name: "index_system_nag_definitions_on_enabled"
    t.index ["scope", "importance"], name: "index_system_nag_definitions_on_scope_and_importance"
  end

  create_table "renalware.system_online_reference_links", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.text "description", comment: "Text displayed alongside the link or QR code"
    t.date "include_in_letters_from", comment: "If set, the QR code will be included in any new letters created on orafter this date - ie its the start of the window of auto-inclusion"
    t.date "include_in_letters_until", comment: "If 'include_in_letters_from' is set, letters created after this date will no longer have the QR code automatically inserted - ie its the end of the window of auto-inclusion"
    t.datetime "last_used_at", precision: nil
    t.string "title", null: false, comment: "The name of this resource, for display in the UI only"
    t.datetime "updated_at", null: false
    t.bigint "updated_by_id", null: false
    t.string "url", null: false, comment: "A URL linking to a helpful online reference for patients. May be rendered as a QR code."
    t.integer "usage_count", default: 0
    t.index ["created_by_id"], name: "index_system_online_reference_links_on_created_by_id"
    t.index ["title"], name: "index_system_online_reference_links_on_title", unique: true
    t.index ["updated_by_id"], name: "index_system_online_reference_links_on_updated_by_id"
    t.index ["url"], name: "index_system_online_reference_links_on_url", unique: true
  end

  create_table "renalware.system_templates", id: :serial, force: :cascade do |t|
    t.text "body", null: false
    t.string "description", null: false
    t.string "name", null: false
    t.string "title"
    t.index ["name"], name: "index_system_templates_on_name"
  end

  create_table "renalware.system_user_feedback", force: :cascade do |t|
    t.boolean "acknowledged"
    t.text "admin_notes"
    t.bigint "author_id", null: false
    t.string "category", null: false
    t.text "comment", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["author_id"], name: "index_system_user_feedback_on_author_id"
    t.index ["category"], name: "index_system_user_feedback_on_category"
  end

  create_table "renalware.system_versions", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_system_versions_on_item_type_and_item_id"
  end

  create_table "renalware.system_view_calls", force: :cascade do |t|
    t.datetime "called_at", null: false
    t.bigint "user_id", null: false
    t.bigint "view_metadata_id", null: false
    t.index ["user_id"], name: "index_system_view_calls_on_user_id"
    t.index ["view_metadata_id", "user_id", "called_at"], name: "idx_system_view_calls_all"
    t.index ["view_metadata_id"], name: "index_system_view_calls_on_view_metadata_id"
  end

  create_table "renalware.system_view_metadata", comment: "Holds descriptive and layout data to help us construct data-driven parts of the Renalware UI e.g. MDMs", force: :cascade do |t|
    t.integer "calls_count", default: 0
    t.enum "category", default: "mdm", null: false, enum_type: "system_view_category"
    t.jsonb "chart", default: {}, null: false
    t.jsonb "chart_raw", default: {}, null: false
    t.jsonb "columns", default: [], null: false, comment: "Array of column_names. If empty, all cols displayed. Array order is the display order"
    t.datetime "created_at", precision: nil, null: false
    t.text "description", comment: "A description of the SQL view's function"
    t.enum "display_type", default: "tabular", null: false, enum_type: "system_view_display_type"
    t.jsonb "filters", default: [], null: false, comment: "Array of filter definition for generating filters. Must be the name of a column in the SQL view. "
    t.datetime "last_called_at"
    t.boolean "materialized", default: false, null: false
    t.datetime "materialized_view_refreshed_at", precision: nil
    t.bigint "parent_id", comment: "Self-join in case a view should have children"
    t.text "parent_name"
    t.enum "patient_landing_page", comment: "If present, any patient links generated the report associated with this row will take the user indicated landing area eg patients/123/hd, where these landing areas are routes defined by each RW module and often redirect, e.g. to a dashboard or profile page", enum_type: "enum_patient_landing_page"
    t.integer "position", default: 0, null: false
    t.boolean "refresh_concurrently", default: false, null: false, comment: "where refresh_schedule is set, if refresh_concurrently is true then provided the materialised view has a unique index, the data will be reloaded without locking the table for selects - which is clearly advantageous"
    t.text "refresh_schedule", comment: "Cron or fugit schedule string for refreshing the view if it is materialized eg 'every day at 6am' or '0 * * * *' (every hour) or @hourly (turns into '0 * * * *') or '0 0 L * *' (last day of month at 00:00)"
    t.text "schema_name", null: false
    t.text "scope", comment: "e.g. PD"
    t.text "slug", comment: "May be used in urls - must be lower case with no spaces"
    t.string "sub_category"
    t.text "title", comment: "A label that may appear in the UI"
    t.datetime "updated_at", precision: nil, null: false
    t.text "view_name", null: false
    t.index ["parent_id"], name: "index_system_view_metadata_on_parent_id"
  end

  create_table "renalware.system_visits", force: :cascade do |t|
    t.string "browser"
    t.string "device_type"
    t.string "ip"
    t.text "landing_page"
    t.string "os"
    t.text "referrer"
    t.string "referring_domain"
    t.string "search_keyword"
    t.datetime "started_at", precision: nil
    t.text "user_agent"
    t.bigint "user_id"
    t.string "visit_token"
    t.string "visitor_token"
    t.index ["user_id"], name: "index_system_visits_on_user_id"
    t.index ["visit_token"], name: "index_system_visits_on_visit_token", unique: true
  end

  create_table "renalware.transplant_donations", id: :serial, force: :cascade do |t|
    t.string "blood_group_compatibility"
    t.datetime "created_at", precision: nil, null: false
    t.date "donated_on"
    t.date "first_seen_on"
    t.string "mismatch_grade"
    t.text "notes"
    t.string "paired_pooled_donation"
    t.integer "patient_id"
    t.integer "recipient_id"
    t.string "relationship_with_recipient", null: false
    t.string "relationship_with_recipient_other"
    t.string "state", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.date "volunteered_on"
    t.date "workup_completed_on"
    t.index ["patient_id"], name: "index_transplant_donations_on_patient_id"
    t.index ["recipient_id"], name: "index_transplant_donations_on_recipient_id"
  end

  create_table "renalware.transplant_donor_followups", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.date "dead_on"
    t.boolean "followed_up"
    t.date "last_seen_on"
    t.boolean "lost_to_followup"
    t.text "notes"
    t.integer "operation_id", null: false
    t.boolean "transferred_for_followup"
    t.string "ukt_center_code"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["operation_id"], name: "index_transplant_donor_followups_on_operation_id"
  end

  create_table "renalware.transplant_donor_operations", id: :serial, force: :cascade do |t|
    t.string "anaesthetist"
    t.datetime "created_at", precision: nil, null: false
    t.jsonb "document"
    t.string "donor_splenectomy_peri_or_post_operatively"
    t.string "kidney_side"
    t.string "nephrectomy_type"
    t.string "nephrectomy_type_other"
    t.text "notes"
    t.string "operating_surgeon"
    t.integer "patient_id"
    t.date "performed_on", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["document"], name: "index_transplant_donor_operations_on_document", using: :gin
    t.index ["patient_id"], name: "index_transplant_donor_operations_on_patient_id"
  end

  create_table "renalware.transplant_donor_stage_positions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.integer "position", default: 1, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_transplant_donor_stage_positions_on_name", unique: true
    t.index ["position"], name: "index_transplant_donor_stage_positions_on_position"
  end

  create_table "renalware.transplant_donor_stage_statuses", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.integer "position", default: 1, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_transplant_donor_stage_statuses_on_name", unique: true
    t.index ["position"], name: "index_transplant_donor_stage_statuses_on_position"
  end

  create_table "renalware.transplant_donor_stages", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.text "notes"
    t.integer "patient_id", null: false
    t.integer "stage_position_id", null: false
    t.integer "stage_status_id", null: false
    t.datetime "started_on", precision: nil, null: false
    t.datetime "terminated_on", precision: nil
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_transplant_donor_stages_on_created_by_id"
    t.index ["patient_id"], name: "index_transplant_donor_stages_on_patient_id"
    t.index ["stage_position_id"], name: "tx_donor_stage_position_idx"
    t.index ["stage_status_id"], name: "tx_donor_stage_status_idx"
    t.index ["updated_by_id"], name: "index_transplant_donor_stages_on_updated_by_id"
  end

  create_table "renalware.transplant_donor_workups", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.jsonb "document"
    t.integer "patient_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["document"], name: "index_transplant_donor_workups_on_document", using: :gin
    t.index ["patient_id"], name: "index_transplant_donor_workups_on_patient_id"
  end

  create_table "renalware.transplant_failure_cause_description_groups", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "renalware.transplant_failure_cause_descriptions", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", precision: nil, null: false
    t.integer "group_id"
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_transplant_failure_cause_descriptions_on_code", unique: true
    t.index ["group_id"], name: "index_transplant_failure_cause_descriptions_on_group_id"
  end

  create_table "renalware.transplant_induction_agents", force: :cascade do |t|
    t.text "atc_code"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.text "drug_name"
    t.text "name", null: false
    t.integer "position", default: 0, null: false
    t.text "snomed_code"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index "lower(name)", name: "index_transplant_induction_agents_on_name", unique: true
  end

  create_table "renalware.transplant_investigation_types", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "description", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_transplant_investigation_types_on_code", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_transplant_investigation_types_on_deleted_at"
  end

  create_table "renalware.transplant_recipient_followups", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.jsonb "document"
    t.string "graft_function_onset"
    t.date "graft_nephrectomy_on"
    t.date "last_post_transplant_dialysis_on"
    t.text "notes"
    t.integer "operation_id", null: false
    t.date "return_to_regular_dialysis_on"
    t.date "stent_removed_on"
    t.boolean "transplant_failed"
    t.date "transplant_failed_on"
    t.integer "transplant_failure_cause_description_id"
    t.string "transplant_failure_cause_other"
    t.text "transplant_failure_notes"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["document"], name: "index_transplant_recipient_followups_on_document", using: :gin
    t.index ["operation_id"], name: "index_transplant_recipient_followups_on_operation_id"
    t.index ["transplant_failure_cause_description_id"], name: "tx_recip_fol_failure_cause_description_id_idx"
  end

  create_table "renalware.transplant_recipient_operations", id: :serial, force: :cascade do |t|
    t.integer "cold_ischaemic_time"
    t.datetime "created_at", precision: nil, null: false
    t.jsonb "document"
    t.datetime "donor_kidney_removed_from_ice_at", precision: nil
    t.integer "hospital_centre_id", null: false
    t.string "immunological_risk"
    t.bigint "induction_agent_id"
    t.datetime "kidney_perfused_with_blood_at", precision: nil
    t.text "notes"
    t.string "operation_type", null: false
    t.integer "patient_id", null: false
    t.date "performed_on", null: false
    t.time "theatre_case_start_time"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "warm_ischaemic_time"
    t.index ["document"], name: "index_transplant_recipient_operations_on_document", using: :gin
    t.index ["hospital_centre_id"], name: "index_transplant_recipient_operations_on_hospital_centre_id"
    t.index ["induction_agent_id"], name: "index_transplant_recipient_operations_on_induction_agent_id"
    t.index ["patient_id"], name: "index_transplant_recipient_operations_on_patient_id"
  end

  create_table "renalware.transplant_recipient_workups", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.jsonb "document"
    t.integer "patient_id"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_transplant_recipient_workups_on_created_by_id"
    t.index ["document"], name: "index_transplant_recipient_workups_on_document", using: :gin
    t.index ["patient_id"], name: "index_transplant_recipient_workups_on_patient_id"
    t.index ["updated_by_id"], name: "index_transplant_recipient_workups_on_updated_by_id"
  end

  create_table "renalware.transplant_registration_status_descriptions", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.integer "position", default: 0
    t.integer "rr_code"
    t.text "rr_comment"
    t.integer "ukrdc_assessment_outcome_code", comment: "See UKRR Dataset 5+. Valid values are 1 through 3."
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_transplant_registration_status_descriptions_on_code"
    t.index ["position"], name: "index_transplant_registration_status_descriptions_on_position"
  end

  create_table "renalware.transplant_registration_statuses", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.integer "description_id"
    t.text "notes"
    t.integer "registration_id"
    t.date "started_on", null: false
    t.date "terminated_on"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_transplant_registration_statuses_on_created_by_id"
    t.index ["description_id"], name: "index_transplant_registration_statuses_on_description_id"
    t.index ["registration_id"], name: "index_transplant_registration_statuses_on_registration_id"
    t.index ["started_on"], name: "index_transplant_registration_statuses_on_started_on"
    t.index ["terminated_on"], name: "index_transplant_registration_statuses_on_terminated_on"
    t.index ["updated_by_id"], name: "index_transplant_registration_statuses_on_updated_by_id"
  end

  create_table "renalware.transplant_registrations", id: :serial, force: :cascade do |t|
    t.date "assessed_on"
    t.text "contact"
    t.datetime "created_at", precision: nil, null: false
    t.jsonb "document"
    t.date "entered_on"
    t.text "notes"
    t.integer "patient_id"
    t.date "referred_on"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["document"], name: "index_transplant_registrations_on_document", using: :gin
    t.index ["patient_id"], name: "index_transplant_registrations_on_patient_id", unique: true
  end

  create_table "renalware.transplant_rejection_episodes", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "created_by_id", null: false
    t.bigint "followup_id", null: false
    t.text "notes"
    t.date "recorded_on", null: false
    t.bigint "treatment_id"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_transplant_rejection_episodes_on_created_by_id"
    t.index ["followup_id"], name: "index_transplant_rejection_episodes_on_followup_id"
    t.index ["treatment_id"], name: "index_transplant_rejection_episodes_on_treatment_id"
    t.index ["updated_by_id"], name: "index_transplant_rejection_episodes_on_updated_by_id"
  end

  create_table "renalware.transplant_rejection_treatments", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.text "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_transplant_rejection_treatments_on_name"
    t.index ["position"], name: "index_transplant_rejection_treatments_on_position"
  end

  create_table "renalware.transplant_versions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_id"], name: "index_transplant_versions_on_item_id"
    t.index ["item_type", "item_id"], name: "tx_versions_type_id"
  end

  create_table "renalware.ukrdc_assessment_outcomes", primary_key: "code", id: :serial, force: :cascade do |t|
    t.bigint "assessment_type_id", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "description"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["assessment_type_id"], name: "index_ukrdc_assessment_outcomes_on_assessment_type_id"
  end

  create_table "renalware.ukrdc_assessment_types", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "description"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "renalware.ukrdc_batches", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "renalware.ukrdc_measurement_units", force: :cascade do |t|
    t.string "alias", default: [], array: true
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_ukrdc_measurement_units_on_name"
  end

  create_table "renalware.ukrdc_modality_codes", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.text "description"
    t.string "qbl_code"
    t.string "txt_code"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["qbl_code"], name: "index_ukrdc_modality_codes_on_qbl_code"
    t.index ["txt_code"], name: "index_ukrdc_modality_codes_on_txt_code"
  end

  create_table "renalware.ukrdc_transmission_logs", force: :cascade do |t|
    t.bigint "batch_id"
    t.datetime "created_at", precision: nil, null: false
    t.integer "direction", default: 0, null: false
    t.text "error", default: [], array: true
    t.string "file_path"
    t.bigint "patient_id"
    t.xml "payload"
    t.text "payload_hash"
    t.uuid "request_uuid"
    t.datetime "sent_at", precision: nil
    t.integer "status", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["batch_id"], name: "index_ukrdc_transmission_logs_on_batch_id"
    t.index ["patient_id"], name: "index_ukrdc_transmission_logs_on_patient_id"
    t.index ["request_uuid"], name: "index_ukrdc_transmission_logs_on_request_uuid"
  end

  create_table "renalware.ukrdc_treatments", force: :cascade do |t|
    t.bigint "clinician_id"
    t.datetime "created_at", precision: nil, null: false
    t.integer "discharge_reason_code"
    t.string "discharge_reason_comment"
    t.date "ended_on"
    t.bigint "hd_profile_id"
    t.string "hd_type"
    t.bigint "hospital_centre_id"
    t.bigint "hospital_unit_id"
    t.bigint "modality_code_id", null: false
    t.bigint "modality_description_id"
    t.bigint "modality_id"
    t.bigint "patient_id", null: false
    t.bigint "pd_regime_id"
    t.date "started_on", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["clinician_id"], name: "index_ukrdc_treatments_on_clinician_id"
    t.index ["hd_profile_id"], name: "index_ukrdc_treatments_on_hd_profile_id"
    t.index ["hospital_centre_id"], name: "index_ukrdc_treatments_on_hospital_centre_id"
    t.index ["hospital_unit_id"], name: "index_ukrdc_treatments_on_hospital_unit_id"
    t.index ["modality_code_id"], name: "index_ukrdc_treatments_on_modality_code_id"
    t.index ["modality_description_id"], name: "index_ukrdc_treatments_on_modality_description_id"
    t.index ["modality_id"], name: "index_ukrdc_treatments_on_modality_id"
    t.index ["patient_id"], name: "index_ukrdc_treatments_on_patient_id"
    t.index ["pd_regime_id"], name: "index_ukrdc_treatments_on_pd_regime_id"
  end

  create_table "renalware.user_group_memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_group_id", null: false
    t.bigint "user_id", null: false
    t.index ["user_group_id"], name: "index_user_group_memberships_on_user_group_id"
    t.index ["user_id", "user_group_id"], name: "index_user_group_memberships_on_user_id_and_user_group_id", unique: true
    t.index ["user_id"], name: "index_user_group_memberships_on_user_id"
  end

  create_table "renalware.user_groups", force: :cascade do |t|
    t.boolean "active", default: true, null: false, comment: "If false, the group will not be displayed anywhere prospectively"
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.string "description"
    t.boolean "letter_electronic_ccs", default: false, null: false, comment: "If true, the group can be chosen from the electronic CCs recipients dropdown in letters"
    t.integer "memberships_count", default: 0, null: false, comment: "Counter cache for the number of memberships in this group"
    t.string "name", null: false, comment: "e.g. 'Transplant Cordinators'"
    t.datetime "updated_at", null: false
    t.bigint "updated_by_id", null: false
    t.index ["active"], name: "index_user_groups_on_active"
    t.index ["created_by_id"], name: "index_user_groups_on_created_by_id"
    t.index ["name"], name: "index_user_groups_on_name", unique: true
    t.index ["updated_by_id"], name: "index_user_groups_on_updated_by_id"
  end

  create_table "renalware.users", id: :serial, force: :cascade do |t|
    t.boolean "approved", default: false, null: false
    t.boolean "asked_for_write_access", default: false, null: false
    t.string "authentication_token"
    t.string "azure_uid"
    t.boolean "banned", default: false, null: false
    t.boolean "consultant", default: false, null: false
    t.datetime "created_at", precision: nil
    t.datetime "current_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "expired_at", precision: nil
    t.integer "failed_attempts", default: 0, null: false
    t.string "family_name", null: false
    t.integer "feature_flags", default: 0, null: false, comment: "OR'ed feature flag bits to enable experimental features for certain users"
    t.string "given_name", null: false
    t.string "gmc_code"
    t.boolean "hidden", default: false, null: false
    t.bigint "hospital_centre_id"
    t.string "language"
    t.datetime "last_activity_at", precision: nil
    t.datetime "last_failed_sign_in_at"
    t.datetime "last_sign_in_at", precision: nil
    t.inet "last_sign_in_ip"
    t.datetime "locked_at", precision: nil
    t.text "notes"
    t.enum "nursing_experience_level", enum_type: "nursing_experience_level_enum"
    t.datetime "password_changed_at", precision: nil
    t.boolean "prescriber", default: false, null: false, comment: "A user can only add or terminate a prescription if this is set to true"
    t.string "professional_position"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.string "signature"
    t.string "telephone"
    t.string "unlock_token"
    t.datetime "updated_at", precision: nil
    t.string "username", null: false
    t.uuid "uuid", default: -> { "public.uuid_generate_v4()" }, null: false
    t.index "lower((email)::text)", name: "index_users_on_lower_email", unique: true
    t.index "lower((username)::text)", name: "index_users_on_lower_username", unique: true
    t.index ["approved"], name: "index_users_on_approved"
    t.index ["azure_uid"], name: "index_users_on_azure_uid", unique: true
    t.index ["expired_at"], name: "index_users_on_expired_at"
    t.index ["family_name"], name: "index_users_on_family_name"
    t.index ["given_name"], name: "index_users_on_given_name"
    t.index ["hidden"], name: "index_users_on_hidden"
    t.index ["hospital_centre_id"], name: "index_users_on_hospital_centre_id"
    t.index ["last_activity_at"], name: "index_users_on_last_activity_at"
    t.index ["password_changed_at"], name: "index_users_on_password_changed_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["signature"], name: "index_users_on_signature"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "renalware.versions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "renalware.virology_profiles", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.bigint "created_by_id"
    t.jsonb "document", default: {}, null: false
    t.bigint "patient_id", null: false
    t.datetime "updated_at", precision: nil
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_virology_profiles_on_created_by_id"
    t.index ["document"], name: "index_virology_profiles_on_document", using: :gin
    t.index ["patient_id"], name: "index_virology_profiles_on_patient_id", unique: true
    t.index ["updated_by_id"], name: "index_virology_profiles_on_updated_by_id"
  end

  create_table "renalware.virology_vaccination_types", force: :cascade do |t|
    t.string "atc_codes", default: [], null: false, array: true
    t.string "code", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_virology_vaccination_types_on_code", unique: true
    t.index ["name"], name: "index_virology_vaccination_types_on_name", unique: true
  end

  create_table "renalware.virology_versions", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.index ["item_type", "item_id"], name: "index_virology_versions_on_item_type_and_item_id"
  end

  add_foreign_key "renalware.access_assessments", "renalware.access_types", column: "type_id"
  add_foreign_key "renalware.access_assessments", "renalware.patients"
  add_foreign_key "renalware.access_assessments", "renalware.users", column: "created_by_id", name: "access_assessments_created_by_id_fk"
  add_foreign_key "renalware.access_assessments", "renalware.users", column: "updated_by_id", name: "access_assessments_updated_by_id_fk"
  add_foreign_key "renalware.access_needling_assessments", "renalware.patients"
  add_foreign_key "renalware.access_needling_assessments", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.access_needling_assessments", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.access_plans", "renalware.access_plan_types", column: "plan_type_id"
  add_foreign_key "renalware.access_plans", "renalware.patients"
  add_foreign_key "renalware.access_plans", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.access_plans", "renalware.users", column: "decided_by_id"
  add_foreign_key "renalware.access_plans", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.access_procedures", "renalware.access_types", column: "type_id"
  add_foreign_key "renalware.access_procedures", "renalware.patients"
  add_foreign_key "renalware.access_procedures", "renalware.users", column: "created_by_id", name: "access_procedures_created_by_id_fk"
  add_foreign_key "renalware.access_procedures", "renalware.users", column: "updated_by_id", name: "access_procedures_updated_by_id_fk"
  add_foreign_key "renalware.access_profiles", "renalware.access_types", column: "type_id"
  add_foreign_key "renalware.access_profiles", "renalware.patients"
  add_foreign_key "renalware.access_profiles", "renalware.users", column: "created_by_id", name: "access_profiles_created_by_id_fk"
  add_foreign_key "renalware.access_profiles", "renalware.users", column: "decided_by_id"
  add_foreign_key "renalware.access_profiles", "renalware.users", column: "updated_by_id", name: "access_profiles_updated_by_id_fk"
  add_foreign_key "renalware.active_storage_attachments", "renalware.active_storage_blobs", column: "blob_id"
  add_foreign_key "renalware.active_storage_variant_records", "renalware.active_storage_blobs", column: "blob_id"
  add_foreign_key "renalware.addresses", "renalware.system_countries", column: "country_id"
  add_foreign_key "renalware.admission_admissions", "renalware.hospital_wards"
  add_foreign_key "renalware.admission_admissions", "renalware.modality_modalities", column: "modality_at_admission_id"
  add_foreign_key "renalware.admission_admissions", "renalware.patients"
  add_foreign_key "renalware.admission_admissions", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.admission_admissions", "renalware.users", column: "summarised_by_id"
  add_foreign_key "renalware.admission_admissions", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.admission_consults", "renalware.admission_specialties", column: "specialty_id"
  add_foreign_key "renalware.admission_consults", "renalware.hospital_wards"
  add_foreign_key "renalware.admission_consults", "renalware.patients"
  add_foreign_key "renalware.admission_consults", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.admission_consults", "renalware.users", column: "seen_by_id"
  add_foreign_key "renalware.admission_consults", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.admission_requests", "renalware.admission_request_reasons", column: "reason_id"
  add_foreign_key "renalware.admission_requests", "renalware.hospital_units"
  add_foreign_key "renalware.admission_requests", "renalware.patients"
  add_foreign_key "renalware.admission_requests", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.admission_requests", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.clinic_appointments", "renalware.clinic_clinics", column: "clinic_id"
  add_foreign_key "renalware.clinic_appointments", "renalware.clinic_consultants", column: "consultant_id"
  add_foreign_key "renalware.clinic_appointments", "renalware.clinic_visits", column: "becomes_visit_id"
  add_foreign_key "renalware.clinic_appointments", "renalware.patients"
  add_foreign_key "renalware.clinic_appointments", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.clinic_appointments", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.clinic_clinics", "renalware.modality_descriptions", column: "default_modality_description_id"
  add_foreign_key "renalware.clinic_clinics", "renalware.users"
  add_foreign_key "renalware.clinic_clinics", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.clinic_clinics", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.clinic_consultants", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.clinic_consultants", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.clinic_mappings", "renalware.clinic_clinics", column: "clinic_id"
  add_foreign_key "renalware.clinic_visit_locations", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.clinic_visit_locations", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.clinic_visits", "renalware.clinic_clinics", column: "clinic_id"
  add_foreign_key "renalware.clinic_visits", "renalware.clinic_visit_locations", column: "location_id"
  add_foreign_key "renalware.clinic_visits", "renalware.patients", name: "clinic_visits_patient_id_fk"
  add_foreign_key "renalware.clinic_visits", "renalware.users", column: "created_by_id", name: "clinic_visits_created_by_id_fk"
  add_foreign_key "renalware.clinic_visits", "renalware.users", column: "updated_by_id", name: "clinic_visits_updated_by_id_fk"
  add_foreign_key "renalware.clinical_allergies", "renalware.patients"
  add_foreign_key "renalware.clinical_allergies", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.clinical_allergies", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.clinical_body_compositions", "renalware.modality_descriptions"
  add_foreign_key "renalware.clinical_body_compositions", "renalware.patients"
  add_foreign_key "renalware.clinical_body_compositions", "renalware.users", column: "assessor_id"
  add_foreign_key "renalware.clinical_dry_weights", "renalware.patients"
  add_foreign_key "renalware.clinical_dry_weights", "renalware.users", column: "assessor_id"
  add_foreign_key "renalware.clinical_dry_weights", "renalware.users", column: "created_by_id", name: "hd_dry_weights_created_by_id_fk"
  add_foreign_key "renalware.clinical_dry_weights", "renalware.users", column: "updated_by_id", name: "hd_dry_weights_updated_by_id_fk"
  add_foreign_key "renalware.clinical_igan_risks", "renalware.patients"
  add_foreign_key "renalware.clinical_igan_risks", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.clinical_igan_risks", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.death_locations", "renalware.ukrdc_assessment_outcomes", column: "ukrdc_assessment_outcome_code", primary_key: "code"
  add_foreign_key "renalware.directory_people", "renalware.users", column: "created_by_id", name: "directory_people_created_by_id_fk"
  add_foreign_key "renalware.directory_people", "renalware.users", column: "updated_by_id", name: "directory_people_updated_by_id_fk"
  add_foreign_key "renalware.drug_homecare_forms", "renalware.drug_suppliers", column: "supplier_id"
  add_foreign_key "renalware.drug_trade_family_classifications", "renalware.drug_trade_families", column: "trade_family_id"
  add_foreign_key "renalware.drug_trade_family_classifications", "renalware.drugs"
  add_foreign_key "renalware.drug_types_drugs", "renalware.drug_types"
  add_foreign_key "renalware.drug_types_drugs", "renalware.drugs"
  add_foreign_key "renalware.drug_vmp_classifications", "renalware.drug_forms", column: "form_id"
  add_foreign_key "renalware.drug_vmp_classifications", "renalware.drug_unit_of_measures", column: "unit_of_measure_id"
  add_foreign_key "renalware.drug_vmp_classifications", "renalware.drugs"
  add_foreign_key "renalware.drug_vmp_classifications", "renalware.medication_routes", column: "route_id"
  add_foreign_key "renalware.event_subtypes", "renalware.event_types"
  add_foreign_key "renalware.event_subtypes", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.event_subtypes", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.event_type_alert_triggers", "renalware.event_types"
  add_foreign_key "renalware.event_types", "renalware.event_categories", column: "category_id"
  add_foreign_key "renalware.events", "renalware.event_subtypes", column: "subtype_id"
  add_foreign_key "renalware.events", "renalware.event_types"
  add_foreign_key "renalware.events", "renalware.patients"
  add_foreign_key "renalware.events", "renalware.users", column: "created_by_id", name: "events_created_by_id_fk"
  add_foreign_key "renalware.events", "renalware.users", column: "updated_by_id", name: "events_updated_by_id_fk"
  add_foreign_key "renalware.feed_files", "renalware.feed_file_types", column: "file_type_id"
  add_foreign_key "renalware.feed_logs", "renalware.feed_messages", column: "message_id"
  add_foreign_key "renalware.feed_logs", "renalware.patients"
  add_foreign_key "renalware.feed_message_replays", "renalware.feed_messages", column: "message_id"
  add_foreign_key "renalware.feed_message_replays", "renalware.feed_replay_requests", column: "replay_request_id"
  add_foreign_key "renalware.feed_outgoing_documents", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.feed_outgoing_documents", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.feed_replay_requests", "renalware.patients"
  add_foreign_key "renalware.geography_lower_super_output_areas", "renalware.geography_middle_super_output_areas", column: "middle_super_output_area_id"
  add_foreign_key "renalware.geography_middle_super_output_areas", "renalware.geography_local_authority_districts", column: "local_authority_district_id"
  add_foreign_key "renalware.geography_output_areas", "renalware.geography_lower_super_output_areas", column: "lower_super_output_area_id"
  add_foreign_key "renalware.geography_postcodes", "renalware.geography_lower_super_output_areas", column: "lower_super_output_area_id"
  add_foreign_key "renalware.hd_acuity_assessments", "renalware.patients"
  add_foreign_key "renalware.hd_acuity_assessments", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.hd_acuity_assessments", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.hd_diaries", "renalware.hd_diaries", column: "master_diary_id"
  add_foreign_key "renalware.hd_diaries", "renalware.hospital_units"
  add_foreign_key "renalware.hd_diaries", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.hd_diaries", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.hd_diary_slots", "renalware.hd_diaries", column: "diary_id"
  add_foreign_key "renalware.hd_diary_slots", "renalware.hd_diurnal_period_codes", column: "diurnal_period_code_id"
  add_foreign_key "renalware.hd_diary_slots", "renalware.hd_stations", column: "station_id"
  add_foreign_key "renalware.hd_diary_slots", "renalware.patients"
  add_foreign_key "renalware.hd_diary_slots", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.hd_diary_slots", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.hd_patient_statistics", "renalware.hospital_units"
  add_foreign_key "renalware.hd_patient_statistics", "renalware.patients"
  add_foreign_key "renalware.hd_preference_sets", "renalware.hd_schedule_definitions", column: "schedule_definition_id"
  add_foreign_key "renalware.hd_preference_sets", "renalware.hospital_units"
  add_foreign_key "renalware.hd_preference_sets", "renalware.patients"
  add_foreign_key "renalware.hd_preference_sets", "renalware.users", column: "created_by_id", name: "hd_preference_sets_created_by_id_fk"
  add_foreign_key "renalware.hd_preference_sets", "renalware.users", column: "updated_by_id", name: "hd_preference_sets_updated_by_id_fk"
  add_foreign_key "renalware.hd_prescription_administrations", "renalware.hd_prescription_administration_reasons", column: "reason_id"
  add_foreign_key "renalware.hd_prescription_administrations", "renalware.hd_sessions"
  add_foreign_key "renalware.hd_prescription_administrations", "renalware.medication_prescriptions", column: "prescription_id"
  add_foreign_key "renalware.hd_prescription_administrations", "renalware.patients"
  add_foreign_key "renalware.hd_prescription_administrations", "renalware.users", column: "administered_by_id"
  add_foreign_key "renalware.hd_prescription_administrations", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.hd_prescription_administrations", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.hd_prescription_administrations", "renalware.users", column: "witnessed_by_id"
  add_foreign_key "renalware.hd_profiles", "renalware.hd_dialysates", column: "dialysate_id"
  add_foreign_key "renalware.hd_profiles", "renalware.hd_schedule_definitions", column: "schedule_definition_id"
  add_foreign_key "renalware.hd_profiles", "renalware.hospital_units"
  add_foreign_key "renalware.hd_profiles", "renalware.patients"
  add_foreign_key "renalware.hd_profiles", "renalware.users", column: "created_by_id", name: "hd_profiles_created_by_id_fk"
  add_foreign_key "renalware.hd_profiles", "renalware.users", column: "named_nurse_id_legacy"
  add_foreign_key "renalware.hd_profiles", "renalware.users", column: "prescriber_id"
  add_foreign_key "renalware.hd_profiles", "renalware.users", column: "transport_decider_id"
  add_foreign_key "renalware.hd_profiles", "renalware.users", column: "updated_by_id", name: "hd_profiles_updated_by_id_fk"
  add_foreign_key "renalware.hd_provider_units", "renalware.hd_providers"
  add_foreign_key "renalware.hd_provider_units", "renalware.hospital_units"
  add_foreign_key "renalware.hd_schedule_definitions", "renalware.hd_diurnal_period_codes", column: "diurnal_period_id"
  add_foreign_key "renalware.hd_session_form_batch_items", "renalware.hd_session_form_batches", column: "batch_id"
  add_foreign_key "renalware.hd_session_form_batches", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.hd_session_form_batches", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.hd_session_patient_group_directions", "renalware.drug_patient_group_directions", column: "patient_group_direction_id"
  add_foreign_key "renalware.hd_session_patient_group_directions", "renalware.hd_sessions", column: "session_id"
  add_foreign_key "renalware.hd_sessions", "renalware.clinical_dry_weights", column: "dry_weight_id"
  add_foreign_key "renalware.hd_sessions", "renalware.hd_dialysates", column: "dialysate_id"
  add_foreign_key "renalware.hd_sessions", "renalware.hd_profiles", column: "profile_id"
  add_foreign_key "renalware.hd_sessions", "renalware.hd_providers", column: "provider_id"
  add_foreign_key "renalware.hd_sessions", "renalware.hd_stations"
  add_foreign_key "renalware.hd_sessions", "renalware.hospital_units"
  add_foreign_key "renalware.hd_sessions", "renalware.modality_descriptions"
  add_foreign_key "renalware.hd_sessions", "renalware.patients"
  add_foreign_key "renalware.hd_sessions", "renalware.users", column: "created_by_id", name: "hd_sessions_created_by_id_fk"
  add_foreign_key "renalware.hd_sessions", "renalware.users", column: "signed_off_by_id"
  add_foreign_key "renalware.hd_sessions", "renalware.users", column: "signed_on_by_id"
  add_foreign_key "renalware.hd_sessions", "renalware.users", column: "updated_by_id", name: "hd_sessions_updated_by_id_fk"
  add_foreign_key "renalware.hd_slot_requests", "renalware.hd_slot_request_access_states", column: "access_state_id"
  add_foreign_key "renalware.hd_slot_requests", "renalware.hd_slot_request_deletion_reasons", column: "deletion_reason_id"
  add_foreign_key "renalware.hd_slot_requests", "renalware.hd_slot_request_locations", column: "location_id"
  add_foreign_key "renalware.hd_slot_requests", "renalware.patients"
  add_foreign_key "renalware.hd_slot_requests", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.hd_slot_requests", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.hd_stations", "renalware.hd_station_locations", column: "location_id"
  add_foreign_key "renalware.hd_stations", "renalware.hospital_units"
  add_foreign_key "renalware.hd_stations", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.hd_stations", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.hd_transmission_logs", "renalware.hd_provider_units"
  add_foreign_key "renalware.hd_transmission_logs", "renalware.patients"
  add_foreign_key "renalware.hd_vnd_risk_assessments", "renalware.patients"
  add_foreign_key "renalware.hd_vnd_risk_assessments", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.hd_vnd_risk_assessments", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.help_tour_annotations", "renalware.help_tour_pages", column: "page_id"
  add_foreign_key "renalware.hospital_departments", "renalware.hospital_centres"
  add_foreign_key "renalware.hospital_units", "renalware.hospital_centres"
  add_foreign_key "renalware.hospital_wards", "renalware.hospital_units"
  add_foreign_key "renalware.letter_archives", "renalware.letter_letters", column: "letter_id"
  add_foreign_key "renalware.letter_archives", "renalware.users", column: "created_by_id", name: "letter_archives_created_by_id_fk"
  add_foreign_key "renalware.letter_archives", "renalware.users", column: "updated_by_id", name: "letter_archives_updated_by_id_fk"
  add_foreign_key "renalware.letter_batch_items", "renalware.letter_batches", column: "batch_id"
  add_foreign_key "renalware.letter_batch_items", "renalware.letter_letters", column: "letter_id"
  add_foreign_key "renalware.letter_batches", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.letter_batches", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.letter_contacts", "renalware.directory_people", column: "person_id"
  add_foreign_key "renalware.letter_contacts", "renalware.letter_contact_descriptions", column: "description_id"
  add_foreign_key "renalware.letter_contacts", "renalware.patients"
  add_foreign_key "renalware.letter_descriptions", "renalware.letter_snomed_document_types", column: "snomed_document_type_id"
  add_foreign_key "renalware.letter_electronic_receipts", "renalware.letter_letters", column: "letter_id"
  add_foreign_key "renalware.letter_electronic_receipts", "renalware.user_groups", validate: false
  add_foreign_key "renalware.letter_electronic_receipts", "renalware.users", column: "recipient_id"
  add_foreign_key "renalware.letter_letterheads", "renalware.hospital_departments"
  add_foreign_key "renalware.letter_letters", "renalware.letter_letterheads", column: "letterhead_id"
  add_foreign_key "renalware.letter_letters", "renalware.patients", name: "letter_letters_patient_id_fk"
  add_foreign_key "renalware.letter_letters", "renalware.users", column: "approved_by_id"
  add_foreign_key "renalware.letter_letters", "renalware.users", column: "author_id"
  add_foreign_key "renalware.letter_letters", "renalware.users", column: "completed_by_id"
  add_foreign_key "renalware.letter_letters", "renalware.users", column: "created_by_id", name: "letter_letters_created_by_id_fk"
  add_foreign_key "renalware.letter_letters", "renalware.users", column: "deleted_by_id"
  add_foreign_key "renalware.letter_letters", "renalware.users", column: "submitted_for_approval_by_id"
  add_foreign_key "renalware.letter_letters", "renalware.users", column: "updated_by_id", name: "letter_letters_updated_by_id_fk"
  add_foreign_key "renalware.letter_mailshot_items", "renalware.letter_letters", column: "letter_id"
  add_foreign_key "renalware.letter_mailshot_items", "renalware.letter_mailshot_mailshots", column: "mailshot_id"
  add_foreign_key "renalware.letter_mailshot_mailshots", "renalware.letter_letterheads", column: "letterhead_id"
  add_foreign_key "renalware.letter_mailshot_mailshots", "renalware.users", column: "author_id"
  add_foreign_key "renalware.letter_mailshot_mailshots", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.letter_mailshot_mailshots", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.letter_mesh_operations", "renalware.letter_mesh_operations", column: "parent_id"
  add_foreign_key "renalware.letter_mesh_operations", "renalware.letter_mesh_transmissions", column: "transmission_id"
  add_foreign_key "renalware.letter_mesh_transmissions", "renalware.letter_letters", column: "letter_id"
  add_foreign_key "renalware.letter_qr_encoded_online_reference_links", "renalware.letter_letters", column: "letter_id"
  add_foreign_key "renalware.letter_qr_encoded_online_reference_links", "renalware.system_online_reference_links", column: "online_reference_link_id"
  add_foreign_key "renalware.letter_recipients", "renalware.letter_letters", column: "letter_id"
  add_foreign_key "renalware.letter_section_snapshots", "renalware.letter_letters", column: "letter_id"
  add_foreign_key "renalware.letter_signatures", "renalware.letter_letters", column: "letter_id"
  add_foreign_key "renalware.letter_signatures", "renalware.users"
  add_foreign_key "renalware.low_clearance_dialysis_plans", "renalware.ukrdc_assessment_outcomes", column: "ukrdc_assessment_outcome_code", primary_key: "code"
  add_foreign_key "renalware.low_clearance_profiles", "renalware.low_clearance_referrers", column: "referrer_id"
  add_foreign_key "renalware.low_clearance_profiles", "renalware.patients"
  add_foreign_key "renalware.low_clearance_profiles", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.low_clearance_profiles", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.medication_delivery_event_prescriptions", "renalware.medication_delivery_events", column: "event_id"
  add_foreign_key "renalware.medication_delivery_event_prescriptions", "renalware.medication_prescriptions", column: "prescription_id"
  add_foreign_key "renalware.medication_delivery_events", "renalware.drug_homecare_forms", column: "homecare_form_id"
  add_foreign_key "renalware.medication_delivery_events", "renalware.drug_types"
  add_foreign_key "renalware.medication_delivery_events", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.medication_delivery_events", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.medication_prescription_terminations", "renalware.medication_prescriptions", column: "prescription_id"
  add_foreign_key "renalware.medication_prescription_terminations", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.medication_prescription_terminations", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.medication_prescriptions", "renalware.drug_forms", column: "form_id"
  add_foreign_key "renalware.medication_prescriptions", "renalware.drug_trade_families", column: "trade_family_id"
  add_foreign_key "renalware.medication_prescriptions", "renalware.drug_unit_of_measures", column: "unit_of_measure_id"
  add_foreign_key "renalware.medication_prescriptions", "renalware.drugs"
  add_foreign_key "renalware.medication_prescriptions", "renalware.medication_routes"
  add_foreign_key "renalware.medication_prescriptions", "renalware.patients"
  add_foreign_key "renalware.medication_prescriptions", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.medication_prescriptions", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.messaging_messages", "renalware.messaging_messages", column: "replying_to_message_id"
  add_foreign_key "renalware.messaging_messages", "renalware.patients"
  add_foreign_key "renalware.messaging_messages", "renalware.users", column: "author_id"
  add_foreign_key "renalware.messaging_receipts", "renalware.messaging_messages", column: "message_id"
  add_foreign_key "renalware.messaging_receipts", "renalware.users", column: "recipient_id"
  add_foreign_key "renalware.modality_change_types", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.modality_change_types", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.modality_descriptions", "renalware.ukrdc_modality_codes"
  add_foreign_key "renalware.modality_modalities", "renalware.hospital_centres", column: "destination_hospital_centre_id"
  add_foreign_key "renalware.modality_modalities", "renalware.hospital_centres", column: "source_hospital_centre_id"
  add_foreign_key "renalware.modality_modalities", "renalware.modality_change_types", column: "change_type_id"
  add_foreign_key "renalware.modality_modalities", "renalware.modality_descriptions", column: "description_id"
  add_foreign_key "renalware.modality_modalities", "renalware.modality_reasons", column: "reason_id"
  add_foreign_key "renalware.modality_modalities", "renalware.patients"
  add_foreign_key "renalware.modality_modalities", "renalware.users", column: "created_by_id", name: "modality_modalities_created_by_id_fk"
  add_foreign_key "renalware.modality_modalities", "renalware.users", column: "updated_by_id", name: "modality_modalities_updated_by_id_fk"
  add_foreign_key "renalware.monitoring_mirth_channel_stats", "renalware.monitoring_mirth_channels", column: "channel_id"
  add_foreign_key "renalware.monitoring_mirth_channels", "renalware.monitoring_mirth_channel_groups", column: "channel_group_id"
  add_foreign_key "renalware.pathology_calculation_sources", "renalware.pathology_observations", column: "calculated_observation_id"
  add_foreign_key "renalware.pathology_calculation_sources", "renalware.pathology_observations", column: "source_observation_id"
  add_foreign_key "renalware.pathology_chart_series", "renalware.pathology_charts", column: "chart_id"
  add_foreign_key "renalware.pathology_chart_series", "renalware.pathology_observation_descriptions", column: "observation_description_id"
  add_foreign_key "renalware.pathology_charts", "renalware.users", column: "owner_id"
  add_foreign_key "renalware.pathology_code_group_memberships", "renalware.pathology_code_groups", column: "code_group_id"
  add_foreign_key "renalware.pathology_code_group_memberships", "renalware.pathology_observation_descriptions", column: "observation_description_id"
  add_foreign_key "renalware.pathology_code_group_memberships", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.pathology_code_group_memberships", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.pathology_code_groups", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.pathology_code_groups", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.pathology_current_observation_sets", "renalware.patients"
  add_foreign_key "renalware.pathology_observation_descriptions", "renalware.pathology_measurement_units", column: "measurement_unit_id"
  add_foreign_key "renalware.pathology_observation_descriptions", "renalware.pathology_measurement_units", column: "suggested_measurement_unit_id"
  add_foreign_key "renalware.pathology_observation_descriptions", "renalware.pathology_senders", column: "created_by_sender_id"
  add_foreign_key "renalware.pathology_observation_requests", "renalware.pathology_request_descriptions", column: "description_id"
  add_foreign_key "renalware.pathology_observation_requests", "renalware.patients"
  add_foreign_key "renalware.pathology_observations", "renalware.pathology_observation_descriptions", column: "description_id"
  add_foreign_key "renalware.pathology_observations", "renalware.pathology_observation_requests", column: "request_id"
  add_foreign_key "renalware.pathology_obx_mappings", "renalware.pathology_observation_descriptions", column: "observation_description_id"
  add_foreign_key "renalware.pathology_obx_mappings", "renalware.pathology_senders", column: "sender_id"
  add_foreign_key "renalware.pathology_obx_mappings", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.pathology_obx_mappings", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.pathology_request_descriptions", "renalware.pathology_labs", column: "lab_id"
  add_foreign_key "renalware.pathology_request_descriptions", "renalware.pathology_observation_descriptions", column: "required_observation_description_id"
  add_foreign_key "renalware.pathology_request_descriptions_requests_requests", "renalware.pathology_request_descriptions", column: "request_description_id"
  add_foreign_key "renalware.pathology_request_descriptions_requests_requests", "renalware.pathology_requests_requests", column: "request_id"
  add_foreign_key "renalware.pathology_requests_drugs_drug_categories", "renalware.drugs"
  add_foreign_key "renalware.pathology_requests_drugs_drug_categories", "renalware.pathology_requests_drug_categories", column: "drug_category_id"
  add_foreign_key "renalware.pathology_requests_global_rule_sets", "renalware.clinic_clinics", column: "clinic_id"
  add_foreign_key "renalware.pathology_requests_global_rule_sets", "renalware.pathology_request_descriptions", column: "request_description_id"
  add_foreign_key "renalware.pathology_requests_global_rules", "renalware.pathology_requests_global_rule_sets", column: "rule_set_id"
  add_foreign_key "renalware.pathology_requests_patient_rules", "renalware.pathology_labs", column: "lab_id"
  add_foreign_key "renalware.pathology_requests_patient_rules", "renalware.patients"
  add_foreign_key "renalware.pathology_requests_patient_rules_requests", "renalware.pathology_requests_patient_rules", column: "patient_rule_id"
  add_foreign_key "renalware.pathology_requests_patient_rules_requests", "renalware.pathology_requests_requests", column: "request_id"
  add_foreign_key "renalware.pathology_requests_requests", "renalware.clinic_clinics", column: "clinic_id"
  add_foreign_key "renalware.pathology_requests_requests", "renalware.clinic_consultants", column: "consultant_id"
  add_foreign_key "renalware.pathology_requests_requests", "renalware.patients"
  add_foreign_key "renalware.pathology_requests_requests", "renalware.users", column: "created_by_id", name: "pathology_requests_requests_created_by_id_fk"
  add_foreign_key "renalware.pathology_requests_requests", "renalware.users", column: "updated_by_id", name: "pathology_requests_requests_updated_by_id_fk"
  add_foreign_key "renalware.patient_alerts", "renalware.patients"
  add_foreign_key "renalware.patient_alerts", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.patient_alerts", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.patient_attachments", "renalware.patient_attachment_types", column: "attachment_type_id"
  add_foreign_key "renalware.patient_attachments", "renalware.patients"
  add_foreign_key "renalware.patient_attachments", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.patient_attachments", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.patient_bookmarks", "renalware.patients"
  add_foreign_key "renalware.patient_bookmarks", "renalware.users"
  add_foreign_key "renalware.patient_master_index_deprecated", "renalware.patients"
  add_foreign_key "renalware.patient_merge_logs", "renalware.patient_merge_operations", column: "operation_id"
  add_foreign_key "renalware.patient_merge_merges", "renalware.feed_messages"
  add_foreign_key "renalware.patient_merge_merges", "renalware.patients", column: "major_patient_id"
  add_foreign_key "renalware.patient_merge_merges", "renalware.patients", column: "minor_patient_id"
  add_foreign_key "renalware.patient_merge_operations", "renalware.patient_merge_merges", column: "merge_id"
  add_foreign_key "renalware.patient_practice_memberships", "renalware.patient_practices", column: "practice_id"
  add_foreign_key "renalware.patient_practice_memberships", "renalware.patient_primary_care_physicians", column: "primary_care_physician_id"
  add_foreign_key "renalware.patient_worries", "renalware.patient_worry_categories", column: "worry_category_id"
  add_foreign_key "renalware.patient_worries", "renalware.patients"
  add_foreign_key "renalware.patient_worries", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.patient_worries", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.patient_worry_categories", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.patient_worry_categories", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.patients", "renalware.death_causes", column: "first_cause_id"
  add_foreign_key "renalware.patients", "renalware.death_causes", column: "second_cause_id"
  add_foreign_key "renalware.patients", "renalware.death_locations", column: "actual_death_location_id"
  add_foreign_key "renalware.patients", "renalware.death_locations", column: "preferred_death_location_id"
  add_foreign_key "renalware.patients", "renalware.hospital_centres"
  add_foreign_key "renalware.patients", "renalware.patient_ethnicities", column: "ethnicity_id"
  add_foreign_key "renalware.patients", "renalware.patient_languages", column: "language_id"
  add_foreign_key "renalware.patients", "renalware.patient_marital_statuses", column: "marital_status_id"
  add_foreign_key "renalware.patients", "renalware.patient_practices", column: "practice_id", name: "patients_practice_id_fk"
  add_foreign_key "renalware.patients", "renalware.patient_primary_care_physicians", column: "primary_care_physician_id"
  add_foreign_key "renalware.patients", "renalware.patient_religions", column: "religion_id"
  add_foreign_key "renalware.patients", "renalware.patients", column: "merged_into_patient_id"
  add_foreign_key "renalware.patients", "renalware.system_countries", column: "country_of_birth_id"
  add_foreign_key "renalware.patients", "renalware.users", column: "created_by_id", name: "patients_created_by_id_fk"
  add_foreign_key "renalware.patients", "renalware.users", column: "named_consultant_id"
  add_foreign_key "renalware.patients", "renalware.users", column: "named_nurse_id"
  add_foreign_key "renalware.patients", "renalware.users", column: "updated_by_id", name: "patients_updated_by_id_fk"
  add_foreign_key "renalware.pd_adequacy_results", "renalware.patients"
  add_foreign_key "renalware.pd_adequacy_results", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.pd_adequacy_results", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.pd_assessments", "renalware.patients"
  add_foreign_key "renalware.pd_assessments", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.pd_assessments", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.pd_exit_site_infections", "renalware.patients"
  add_foreign_key "renalware.pd_infection_organisms", "renalware.pd_organism_codes", column: "organism_code_id"
  add_foreign_key "renalware.pd_peritonitis_episode_types", "renalware.pd_peritonitis_episode_type_descriptions", column: "peritonitis_episode_type_description_id"
  add_foreign_key "renalware.pd_peritonitis_episode_types", "renalware.pd_peritonitis_episodes", column: "peritonitis_episode_id"
  add_foreign_key "renalware.pd_peritonitis_episodes", "renalware.patients"
  add_foreign_key "renalware.pd_peritonitis_episodes", "renalware.pd_fluid_descriptions", column: "fluid_description_id"
  add_foreign_key "renalware.pd_peritonitis_episodes", "renalware.pd_peritonitis_episode_type_descriptions", column: "episode_type_id"
  add_foreign_key "renalware.pd_pet_adequacy_results", "renalware.patients"
  add_foreign_key "renalware.pd_pet_adequacy_results", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.pd_pet_adequacy_results", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.pd_pet_results", "renalware.patients"
  add_foreign_key "renalware.pd_pet_results", "renalware.pd_pet_dextrose_concentrations", column: "dextrose_concentration_id"
  add_foreign_key "renalware.pd_pet_results", "renalware.pd_pet_dextrose_concentrations", column: "overnight_dextrose_concentration_id"
  add_foreign_key "renalware.pd_pet_results", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.pd_pet_results", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.pd_regime_bags", "renalware.pd_bag_types", column: "bag_type_id"
  add_foreign_key "renalware.pd_regime_bags", "renalware.pd_regimes", column: "regime_id"
  add_foreign_key "renalware.pd_regime_terminations", "renalware.pd_regimes", column: "regime_id"
  add_foreign_key "renalware.pd_regime_terminations", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.pd_regime_terminations", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.pd_regimes", "renalware.patients"
  add_foreign_key "renalware.pd_regimes", "renalware.pd_systems", column: "system_id", name: "pd_regimes_system_id_fk"
  add_foreign_key "renalware.pd_regimes", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.pd_regimes", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.pd_training_sessions", "renalware.patients"
  add_foreign_key "renalware.pd_training_sessions", "renalware.pd_training_sites", column: "training_site_id", name: "pd_training_sessions_site_id_fk"
  add_foreign_key "renalware.pd_training_sessions", "renalware.pd_training_types", column: "training_type_id", name: "pd_training_sessions_type_id_fk"
  add_foreign_key "renalware.pd_training_sessions", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.pd_training_sessions", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.problem_comorbidities", "renalware.patients"
  add_foreign_key "renalware.problem_comorbidities", "renalware.problem_comorbidity_descriptions", column: "description_id"
  add_foreign_key "renalware.problem_comorbidities", "renalware.problem_malignancy_sites", column: "malignancy_site_id"
  add_foreign_key "renalware.problem_comorbidities", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.problem_comorbidities", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.problem_notes", "renalware.problem_problems", column: "problem_id"
  add_foreign_key "renalware.problem_notes", "renalware.users", column: "created_by_id", name: "problem_notes_created_by_id_fk"
  add_foreign_key "renalware.problem_notes", "renalware.users", column: "updated_by_id", name: "problem_notes_updated_by_id_fk"
  add_foreign_key "renalware.problem_problems", "renalware.patients"
  add_foreign_key "renalware.problem_problems", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.problem_problems", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.problem_radar_diagnoses", "renalware.problem_radar_cohorts", column: "cohort_id"
  add_foreign_key "renalware.renal_aki_alerts", "renalware.hospital_centres"
  add_foreign_key "renalware.renal_aki_alerts", "renalware.hospital_wards"
  add_foreign_key "renalware.renal_aki_alerts", "renalware.patients"
  add_foreign_key "renalware.renal_aki_alerts", "renalware.renal_aki_alert_actions", column: "action_id"
  add_foreign_key "renalware.renal_aki_alerts", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.renal_aki_alerts", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.renal_profiles", "renalware.patients"
  add_foreign_key "renalware.renal_profiles", "renalware.renal_prd_descriptions", column: "prd_description_id"
  add_foreign_key "renalware.research_investigatorships", "renalware.research_studies", column: "study_id"
  add_foreign_key "renalware.research_investigatorships", "renalware.users"
  add_foreign_key "renalware.research_investigatorships", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.research_investigatorships", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.research_participations", "renalware.patients"
  add_foreign_key "renalware.research_participations", "renalware.research_studies", column: "study_id"
  add_foreign_key "renalware.research_participations", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.research_participations", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.research_studies", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.research_studies", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.roles_users", "renalware.roles"
  add_foreign_key "renalware.roles_users", "renalware.users"
  add_foreign_key "renalware.snippets_snippets", "renalware.users", column: "author_id"
  add_foreign_key "renalware.survey_questions", "renalware.survey_surveys", column: "survey_id"
  add_foreign_key "renalware.survey_responses", "renalware.survey_questions", column: "question_id"
  add_foreign_key "renalware.system_dashboard_components", "renalware.system_components", column: "component_id"
  add_foreign_key "renalware.system_dashboard_components", "renalware.system_dashboards", column: "dashboard_id"
  add_foreign_key "renalware.system_dashboards", "renalware.system_dashboards", column: "cloned_from_dashboard_id"
  add_foreign_key "renalware.system_downloads", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.system_downloads", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.system_logs", "renalware.users", column: "owner_id"
  add_foreign_key "renalware.system_online_reference_links", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.system_online_reference_links", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.system_user_feedback", "renalware.users", column: "author_id"
  add_foreign_key "renalware.system_view_calls", "renalware.system_view_metadata", column: "view_metadata_id"
  add_foreign_key "renalware.system_view_calls", "renalware.users"
  add_foreign_key "renalware.system_view_metadata", "renalware.system_view_metadata", column: "parent_id"
  add_foreign_key "renalware.transplant_donations", "renalware.patients"
  add_foreign_key "renalware.transplant_donations", "renalware.patients", column: "recipient_id", name: "transplant_donations_recipient_id_fk"
  add_foreign_key "renalware.transplant_donor_followups", "renalware.transplant_donor_operations", column: "operation_id"
  add_foreign_key "renalware.transplant_donor_operations", "renalware.patients"
  add_foreign_key "renalware.transplant_donor_stages", "renalware.patients"
  add_foreign_key "renalware.transplant_donor_stages", "renalware.transplant_donor_stage_positions", column: "stage_position_id"
  add_foreign_key "renalware.transplant_donor_stages", "renalware.transplant_donor_stage_statuses", column: "stage_status_id"
  add_foreign_key "renalware.transplant_donor_stages", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.transplant_donor_stages", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.transplant_donor_workups", "renalware.patients"
  add_foreign_key "renalware.transplant_failure_cause_descriptions", "renalware.transplant_failure_cause_description_groups", column: "group_id"
  add_foreign_key "renalware.transplant_recipient_followups", "renalware.transplant_failure_cause_descriptions"
  add_foreign_key "renalware.transplant_recipient_followups", "renalware.transplant_recipient_operations", column: "operation_id"
  add_foreign_key "renalware.transplant_recipient_operations", "renalware.hospital_centres"
  add_foreign_key "renalware.transplant_recipient_operations", "renalware.patients"
  add_foreign_key "renalware.transplant_recipient_operations", "renalware.transplant_induction_agents", column: "induction_agent_id"
  add_foreign_key "renalware.transplant_recipient_workups", "renalware.patients"
  add_foreign_key "renalware.transplant_registration_status_descriptions", "renalware.ukrdc_assessment_outcomes", column: "ukrdc_assessment_outcome_code", primary_key: "code"
  add_foreign_key "renalware.transplant_registration_statuses", "renalware.transplant_registration_status_descriptions", column: "description_id"
  add_foreign_key "renalware.transplant_registration_statuses", "renalware.transplant_registrations", column: "registration_id"
  add_foreign_key "renalware.transplant_registration_statuses", "renalware.users", column: "created_by_id", name: "transplant_registration_statuses_created_by_id_fk"
  add_foreign_key "renalware.transplant_registration_statuses", "renalware.users", column: "updated_by_id", name: "transplant_registration_statuses_updated_by_id_fk"
  add_foreign_key "renalware.transplant_registrations", "renalware.patients"
  add_foreign_key "renalware.transplant_rejection_episodes", "renalware.transplant_recipient_followups", column: "followup_id"
  add_foreign_key "renalware.transplant_rejection_episodes", "renalware.transplant_rejection_treatments", column: "treatment_id"
  add_foreign_key "renalware.transplant_rejection_episodes", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.transplant_rejection_episodes", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.ukrdc_assessment_outcomes", "renalware.ukrdc_assessment_types", column: "assessment_type_id"
  add_foreign_key "renalware.ukrdc_transmission_logs", "renalware.patients"
  add_foreign_key "renalware.ukrdc_transmission_logs", "renalware.ukrdc_batches", column: "batch_id"
  add_foreign_key "renalware.ukrdc_treatments", "renalware.hd_profiles"
  add_foreign_key "renalware.ukrdc_treatments", "renalware.hospital_centres"
  add_foreign_key "renalware.ukrdc_treatments", "renalware.hospital_units"
  add_foreign_key "renalware.ukrdc_treatments", "renalware.modality_descriptions"
  add_foreign_key "renalware.ukrdc_treatments", "renalware.patients"
  add_foreign_key "renalware.ukrdc_treatments", "renalware.pd_regimes"
  add_foreign_key "renalware.ukrdc_treatments", "renalware.ukrdc_modality_codes", column: "modality_code_id"
  add_foreign_key "renalware.ukrdc_treatments", "renalware.users", column: "clinician_id"
  add_foreign_key "renalware.user_group_memberships", "renalware.user_groups"
  add_foreign_key "renalware.user_group_memberships", "renalware.users"
  add_foreign_key "renalware.user_groups", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.user_groups", "renalware.users", column: "updated_by_id"
  add_foreign_key "renalware.users", "renalware.hospital_centres"
  add_foreign_key "renalware.virology_profiles", "renalware.patients"
  add_foreign_key "renalware.virology_profiles", "renalware.users", column: "created_by_id"
  add_foreign_key "renalware.virology_profiles", "renalware.users", column: "updated_by_id"

  create_view "medication_current_prescriptions", sql_definition: <<-SQL
      SELECT mp.id,
      mp.patient_id,
      mp.drug_id,
      mp.treatable_type,
      mp.treatable_id,
      mp.dose_amount,
      mp.dose_unit,
      mp.medication_route_id,
      mp.route_description,
      mp.frequency,
      mp.notes,
      mp.prescribed_on,
      mp.provider,
      mp.created_at,
      mp.updated_at,
      mp.created_by_id,
      mp.updated_by_id,
      mp.administer_on_hd,
      mp.last_delivery_date,
      drugs.name AS drug_name,
      drug_types.code AS drug_type_code,
      drug_types.name AS drug_type_name
     FROM ((((renalware.medication_prescriptions mp
       FULL JOIN renalware.medication_prescription_terminations mpt ON ((mpt.prescription_id = mp.id)))
       JOIN renalware.drugs ON ((drugs.id = mp.drug_id)))
       FULL JOIN renalware.drug_types_drugs ON ((drug_types_drugs.drug_id = drugs.id)))
       FULL JOIN renalware.drug_types ON (((drug_types_drugs.drug_type_id = drug_types.id) AND ((mpt.terminated_on IS NULL) OR (mpt.terminated_on > now())))));
  SQL
  create_view "pathology_current_observations", sql_definition: <<-SQL
      SELECT DISTINCT ON (pathology_observation_requests.patient_id, pathology_observation_descriptions.id) pathology_observations.id,
      pathology_observations.result,
      pathology_observations.comment,
      pathology_observations.observed_at,
      pathology_observations.description_id,
      pathology_observations.request_id,
      pathology_observation_descriptions.code AS description_code,
      pathology_observation_descriptions.name AS description_name,
      pathology_observation_requests.patient_id
     FROM ((renalware.pathology_observations
       LEFT JOIN renalware.pathology_observation_requests ON ((pathology_observations.request_id = pathology_observation_requests.id)))
       LEFT JOIN renalware.pathology_observation_descriptions ON ((pathology_observations.description_id = pathology_observation_descriptions.id)))
    ORDER BY pathology_observation_requests.patient_id, pathology_observation_descriptions.id, pathology_observations.observed_at DESC;
  SQL
  create_view "reporting_pd_audit", sql_definition: <<-SQL
      WITH pd_patients AS (
           SELECT patients.id
             FROM ((renalware.patients
               JOIN renalware.modality_modalities current_modality ON ((current_modality.patient_id = patients.id)))
               JOIN renalware.modality_descriptions current_modality_description ON ((current_modality_description.id = current_modality.description_id)))
            WHERE ((current_modality.ended_on IS NULL) AND (current_modality.started_on <= CURRENT_DATE) AND ((current_modality_description.name)::text = 'PD'::text))
          ), current_regimes AS (
           SELECT pd_regimes.id,
              pd_regimes.patient_id,
              pd_regimes.start_date,
              pd_regimes.end_date,
              pd_regimes.treatment,
              pd_regimes.type,
              pd_regimes.glucose_volume_low_strength,
              pd_regimes.glucose_volume_medium_strength,
              pd_regimes.glucose_volume_high_strength,
              pd_regimes.amino_acid_volume,
              pd_regimes.icodextrin_volume,
              pd_regimes.add_hd,
              pd_regimes.last_fill_volume,
              pd_regimes.tidal_indicator,
              pd_regimes.tidal_percentage,
              pd_regimes.no_cycles_per_apd,
              pd_regimes.overnight_volume,
              pd_regimes.apd_machine_pac,
              pd_regimes.created_at,
              pd_regimes.updated_at,
              pd_regimes.therapy_time,
              pd_regimes.fill_volume,
              pd_regimes.delivery_interval,
              pd_regimes.system_id,
              pd_regimes.additional_manual_exchange_volume,
              pd_regimes.tidal_full_drain_every_three_cycles,
              pd_regimes.daily_volume,
              pd_regimes.assistance_type
             FROM renalware.pd_regimes
            WHERE ((pd_regimes.start_date >= CURRENT_DATE) AND (pd_regimes.end_date IS NULL))
          ), current_apd_regimes AS (
           SELECT current_regimes.id,
              current_regimes.patient_id,
              current_regimes.start_date,
              current_regimes.end_date,
              current_regimes.treatment,
              current_regimes.type,
              current_regimes.glucose_volume_low_strength,
              current_regimes.glucose_volume_medium_strength,
              current_regimes.glucose_volume_high_strength,
              current_regimes.amino_acid_volume,
              current_regimes.icodextrin_volume,
              current_regimes.add_hd,
              current_regimes.last_fill_volume,
              current_regimes.tidal_indicator,
              current_regimes.tidal_percentage,
              current_regimes.no_cycles_per_apd,
              current_regimes.overnight_volume,
              current_regimes.apd_machine_pac,
              current_regimes.created_at,
              current_regimes.updated_at,
              current_regimes.therapy_time,
              current_regimes.fill_volume,
              current_regimes.delivery_interval,
              current_regimes.system_id,
              current_regimes.additional_manual_exchange_volume,
              current_regimes.tidal_full_drain_every_three_cycles,
              current_regimes.daily_volume,
              current_regimes.assistance_type
             FROM current_regimes
            WHERE ((current_regimes.type)::text ~~ '%::APD%'::text)
          ), current_capd_regimes AS (
           SELECT current_regimes.id,
              current_regimes.patient_id,
              current_regimes.start_date,
              current_regimes.end_date,
              current_regimes.treatment,
              current_regimes.type,
              current_regimes.glucose_volume_low_strength,
              current_regimes.glucose_volume_medium_strength,
              current_regimes.glucose_volume_high_strength,
              current_regimes.amino_acid_volume,
              current_regimes.icodextrin_volume,
              current_regimes.add_hd,
              current_regimes.last_fill_volume,
              current_regimes.tidal_indicator,
              current_regimes.tidal_percentage,
              current_regimes.no_cycles_per_apd,
              current_regimes.overnight_volume,
              current_regimes.apd_machine_pac,
              current_regimes.created_at,
              current_regimes.updated_at,
              current_regimes.therapy_time,
              current_regimes.fill_volume,
              current_regimes.delivery_interval,
              current_regimes.system_id,
              current_regimes.additional_manual_exchange_volume,
              current_regimes.tidal_full_drain_every_three_cycles,
              current_regimes.daily_volume,
              current_regimes.assistance_type
             FROM current_regimes
            WHERE ((current_regimes.type)::text ~~ '%::CAPD%'::text)
          )
   SELECT 'APD'::text AS pd_type,
      count(current_apd_regimes.patient_id) AS patient_count,
      0 AS avg_hgb,
      0 AS pct_hgb_gt_100,
      0 AS pct_on_epo,
      0 AS pct_pth_gt_500,
      0 AS pct_phosphate_gt_1_8,
      0 AS pct_strong_medium_bag_gt_1l
     FROM current_apd_regimes
  UNION ALL
   SELECT 'CAPD'::text AS pd_type,
      count(current_capd_regimes.patient_id) AS patient_count,
      0 AS avg_hgb,
      0 AS pct_hgb_gt_100,
      0 AS pct_on_epo,
      0 AS pct_pth_gt_500,
      0 AS pct_phosphate_gt_1_8,
      0 AS pct_strong_medium_bag_gt_1l
     FROM current_capd_regimes
  UNION ALL
   SELECT 'PD'::text AS pd_type,
      count(pd_patients.id) AS patient_count,
      0 AS avg_hgb,
      0 AS pct_hgb_gt_100,
      0 AS pct_on_epo,
      0 AS pct_pth_gt_500,
      0 AS pct_phosphate_gt_1_8,
      0 AS pct_strong_medium_bag_gt_1l
     FROM pd_patients;
  SQL
end
