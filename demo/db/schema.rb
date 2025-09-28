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

ActiveRecord::Schema[8.0].define(version: 2025_09_28_122632) do
  create_schema "renalware"
  create_schema "renalware_demo"

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

  create_table "access_assessments", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.integer "type_id", null: false
    t.string "side", null: false
    t.date "performed_on", null: false
    t.date "procedure_on"
    t.text "comments"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.jsonb "document"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["created_by_id"], name: "index_access_assessments_on_created_by_id"
    t.index ["document"], name: "index_access_assessments_on_document", using: :gin
    t.index ["patient_id"], name: "index_access_assessments_on_patient_id"
    t.index ["type_id"], name: "index_access_assessments_on_type_id"
    t.index ["updated_by_id"], name: "index_access_assessments_on_updated_by_id"
  end

  create_table "access_catheter_insertion_techniques", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "description", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "access_needling_assessments", comment: "Stores 'Ease of Needling Vascular Access' aka MAGIC score - see enum", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.enum "difficulty", null: false, enum_type: "access_needling_assessment_difficulties"
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_access_needling_assessments_on_created_by_id"
    t.index ["patient_id", "created_at"], name: "index_access_needling_assessments_on_patient_id_and_created_at"
    t.index ["patient_id"], name: "index_access_needling_assessments_on_patient_id"
    t.index ["updated_by_id"], name: "index_access_needling_assessments_on_updated_by_id"
  end

  create_table "access_plan_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "position", default: 0, null: false
    t.index ["deleted_at"], name: "index_access_plan_types_on_deleted_at"
    t.index ["position"], name: "index_access_plan_types_on_position"
  end

  create_table "access_plans", id: :serial, force: :cascade do |t|
    t.integer "plan_type_id", null: false
    t.text "notes"
    t.integer "patient_id", null: false
    t.integer "decided_by_id"
    t.integer "updated_by_id", null: false
    t.integer "created_by_id", null: false
    t.datetime "terminated_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index "patient_id, COALESCE(terminated_at, '1970-01-01 00:00:00'::timestamp without time zone)", name: "access_plan_uniqueness", unique: true
    t.index ["created_by_id"], name: "index_access_plans_on_created_by_id"
    t.index ["decided_by_id"], name: "index_access_plans_on_decided_by_id"
    t.index ["patient_id"], name: "index_access_plans_on_patient_id"
    t.index ["plan_type_id"], name: "index_access_plans_on_plan_type_id"
    t.index ["terminated_at"], name: "index_access_plans_on_terminated_at"
    t.index ["updated_by_id"], name: "index_access_plans_on_updated_by_id"
  end

  create_table "access_procedures", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.integer "type_id", null: false
    t.string "side"
    t.date "performed_on", null: false
    t.boolean "first_procedure"
    t.string "catheter_make"
    t.string "catheter_lot_no"
    t.text "outcome"
    t.text "notes"
    t.date "first_used_on"
    t.date "failed_on"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "performed_by"
    t.integer "pd_catheter_insertion_technique_id"
    t.index ["created_by_id"], name: "index_access_procedures_on_created_by_id"
    t.index ["patient_id"], name: "index_access_procedures_on_patient_id"
    t.index ["pd_catheter_insertion_technique_id"], name: "access_procedure_pd_catheter_tech_idx"
    t.index ["performed_by"], name: "index_access_procedures_on_performed_by"
    t.index ["type_id"], name: "index_access_procedures_on_type_id"
    t.index ["updated_by_id"], name: "index_access_procedures_on_updated_by_id"
  end

  create_table "access_profiles", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.date "formed_on", null: false
    t.date "started_on"
    t.date "terminated_on"
    t.integer "type_id", null: false
    t.string "side", null: false
    t.text "notes"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "decided_by_id"
    t.index ["created_by_id"], name: "index_access_profiles_on_created_by_id"
    t.index ["decided_by_id"], name: "index_access_profiles_on_decided_by_id"
    t.index ["patient_id"], name: "index_access_profiles_on_patient_id"
    t.index ["started_on"], name: "index_access_profiles_on_started_on"
    t.index ["terminated_on"], name: "index_access_profiles_on_terminated_on"
    t.index ["type_id"], name: "index_access_profiles_on_type_id"
    t.index ["updated_by_id"], name: "index_access_profiles_on_updated_by_id"
  end

  create_table "access_sites", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "access_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "abbreviation"
    t.string "rr02_code"
    t.string "rr41_code"
    t.boolean "hd_vascular", default: true, null: false
  end

  create_table "access_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "access_versions_type_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activesupport_cache_entries", primary_key: "key", id: :binary, force: :cascade do |t|
    t.binary "value", null: false
    t.string "version"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "expires_at", precision: nil
    t.index ["created_at"], name: "index_activesupport_cache_entries_on_created_at"
    t.index ["expires_at"], name: "index_activesupport_cache_entries_on_expires_at"
    t.index ["version"], name: "index_activesupport_cache_entries_on_version"
  end

  create_table "address_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_address_versions_on_item_type_and_item_id"
  end

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.string "addressable_type", null: false
    t.integer "addressable_id", null: false
    t.string "street_1"
    t.string "street_2"
    t.string "county"
    t.string "town"
    t.string "postcode"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name"
    t.string "organisation_name"
    t.string "telephone"
    t.string "email"
    t.string "street_3"
    t.integer "country_id"
    t.text "region"
    t.index ["addressable_id"], name: "index_addresses_on_addressable_id"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id", unique: true
    t.index ["country_id"], name: "index_addresses_on_country_id"
  end

  create_table "admission_admissions", force: :cascade do |t|
    t.bigint "hospital_ward_id", null: false
    t.bigint "patient_id", null: false
    t.date "admitted_on", null: false
    t.string "admission_type", null: false
    t.string "consultant"
    t.bigint "modality_at_admission_id"
    t.text "reason_for_admission", null: false
    t.text "notes"
    t.date "transferred_on"
    t.string "transferred_to"
    t.date "discharged_on"
    t.string "discharge_destination"
    t.string "destination_notes"
    t.text "discharge_summary"
    t.date "summarised_on"
    t.bigint "summarised_by_id"
    t.bigint "updated_by_id", null: false
    t.bigint "created_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "feed_id"
    t.text "visit_number"
    t.string "room"
    t.string "bed"
    t.string "building"
    t.string "floor"
    t.string "consultant_code"
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

  create_table "admission_consult_sites", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_admission_consult_sites_on_name"
  end

  create_table "admission_consults", force: :cascade do |t|
    t.bigint "hospital_ward_id"
    t.bigint "patient_id", null: false
    t.bigint "seen_by_id"
    t.date "started_on"
    t.date "ended_on"
    t.date "decided_on"
    t.date "transferred_on"
    t.string "transfer_priority"
    t.string "aki_risk"
    t.string "consult_type"
    t.string "contact_number"
    t.boolean "requires_aki_nurse", default: false, null: false
    t.text "description"
    t.bigint "updated_by_id", null: false
    t.bigint "created_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "other_site_or_ward"
    t.bigint "consult_site_id"
    t.boolean "rrt", default: false, null: false
    t.integer "priority"
    t.boolean "e_alert", default: false, null: false
    t.bigint "specialty_id"
    t.index ["consult_site_id"], name: "index_admission_consults_on_consult_site_id"
    t.index ["created_by_id"], name: "index_admission_consults_on_created_by_id"
    t.index ["hospital_ward_id"], name: "index_admission_consults_on_hospital_ward_id"
    t.index ["patient_id"], name: "index_admission_consults_on_patient_id"
    t.index ["priority"], name: "index_admission_consults_on_priority"
    t.index ["seen_by_id"], name: "index_admission_consults_on_seen_by_id"
    t.index ["specialty_id"], name: "index_admission_consults_on_specialty_id"
    t.index ["updated_by_id"], name: "index_admission_consults_on_updated_by_id"
  end

  create_table "admission_request_reasons", force: :cascade do |t|
    t.string "description", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_admission_request_reasons_on_deleted_at"
  end

  create_table "admission_requests", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.integer "reason_id", null: false
    t.bigint "hospital_unit_id"
    t.text "notes"
    t.string "priority", null: false
    t.integer "position", default: 0, null: false
    t.datetime "deleted_at", precision: nil
    t.integer "updated_by_id", null: false
    t.integer "created_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["created_by_id"], name: "index_admission_requests_on_created_by_id"
    t.index ["deleted_at"], name: "index_admission_requests_on_deleted_at"
    t.index ["hospital_unit_id"], name: "index_admission_requests_on_hospital_unit_id"
    t.index ["patient_id", "deleted_at"], name: "index_admission_requests_on_patient_id_and_deleted_at", unique: true
    t.index ["position"], name: "index_admission_requests_on_position"
    t.index ["reason_id"], name: "index_admission_requests_on_reason_id"
    t.index ["updated_by_id"], name: "index_admission_requests_on_updated_by_id"
  end

  create_table "admission_specialties", force: :cascade do |t|
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_admission_specialties_on_name", unique: true
  end

  create_table "admission_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_admission_versions_on_item_type_and_item_id"
  end

  create_table "clinic_appointments", id: :serial, force: :cascade do |t|
    t.datetime "starts_at", precision: nil, null: false
    t.integer "patient_id", null: false
    t.integer "clinic_id", null: false
    t.integer "becomes_visit_id"
    t.text "outcome_notes"
    t.text "dna_notes"
    t.string "feed_id"
    t.bigint "consultant_id"
    t.text "clinic_description"
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.text "visit_number"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "ends_at"
    t.text "source_clinic_name", comment: "The name of the clinic in the source system"
    t.index ["clinic_id"], name: "index_clinic_appointments_on_clinic_id"
    t.index ["consultant_id"], name: "index_clinic_appointments_on_consultant_id"
    t.index ["created_by_id"], name: "index_clinic_appointments_on_created_by_id"
    t.index ["patient_id"], name: "index_clinic_appointments_on_patient_id"
    t.index ["updated_by_id"], name: "index_clinic_appointments_on_updated_by_id"
    t.index ["visit_number"], name: "index_clinic_appointments_on_visit_number"
  end

  create_table "clinic_clinics", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.string "visit_class_name"
    t.string "code"
    t.datetime "deleted_at", precision: nil
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.integer "appointments_count", default: 0
    t.integer "clinic_visits_count", default: 0
    t.bigint "default_modality_description_id"
    t.index ["code"], name: "index_clinic_clinics_on_code", unique: true, where: "(deleted_at IS NULL)"
    t.index ["created_by_id"], name: "index_clinic_clinics_on_created_by_id"
    t.index ["default_modality_description_id"], name: "index_clinic_clinics_on_default_modality_description_id"
    t.index ["deleted_at"], name: "index_clinic_clinics_on_deleted_at"
    t.index ["updated_by_id"], name: "index_clinic_clinics_on_updated_by_id"
    t.index ["user_id"], name: "index_clinic_clinics_on_user_id"
  end

  create_table "clinic_consultants", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "telephone"
    t.datetime "deleted_at", precision: nil
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.integer "appointments_count", default: 0
    t.index ["code"], name: "index_clinic_consultants_on_code", unique: true, where: "(deleted_at IS NULL)"
    t.index ["created_by_id"], name: "index_clinic_consultants_on_created_by_id"
    t.index ["deleted_at"], name: "index_clinic_consultants_on_deleted_at"
    t.index ["name"], name: "index_clinic_consultants_on_name", unique: true, where: "(deleted_at IS NULL)"
    t.index ["updated_by_id"], name: "index_clinic_consultants_on_updated_by_id"
  end

  create_table "clinic_mappings", force: :cascade do |t|
    t.string "name_in_feed", null: false
    t.bigint "clinic_id"
    t.boolean "default_clinic", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name_in_feed)::text)", name: "index_clinic_mappings_lower_name_in_feed", unique: true, comment: "Case insensitive index on HL7 clinic name"
    t.index ["clinic_id"], name: "index_clinic_mappings_on_clinic_id"
    t.index ["default_clinic"], name: "index_clinic_mappings_on_default_true", unique: true, where: "(default_clinic = true)", comment: "Enforces that there can only be one default clinic"
  end

  create_table "clinic_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "clinic_versions_type_id"
  end

  create_table "clinic_visit_locations", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "default_location", default: false, null: false
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["created_by_id"], name: "index_clinic_visit_locations_on_created_by_id"
    t.index ["default_location"], name: "index_clinic_visit_locations_on_default_location", unique: true, where: "((default_location = true) AND (deleted_at IS NULL))"
    t.index ["deleted_at"], name: "index_clinic_visit_locations_on_deleted_at"
    t.index ["name"], name: "index_clinic_visit_locations_on_name", unique: true
    t.index ["updated_by_id"], name: "index_clinic_visit_locations_on_updated_by_id"
  end

  create_table "clinic_visits", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.date "date", null: false
    t.float "height"
    t.float "weight"
    t.integer "systolic_bp"
    t.integer "diastolic_bp"
    t.string "urine_blood"
    t.string "urine_protein"
    t.text "notes"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "clinic_id", null: false
    t.time "time"
    t.text "admin_notes"
    t.integer "pulse"
    t.boolean "did_not_attend", default: false, null: false
    t.decimal "temperature", precision: 3, scale: 1
    t.integer "standing_systolic_bp"
    t.integer "standing_diastolic_bp"
    t.jsonb "document", default: {}, null: false
    t.string "type"
    t.decimal "body_surface_area", precision: 8, scale: 2
    t.decimal "total_body_water", precision: 8, scale: 2
    t.decimal "bmi", precision: 10, scale: 1, comment: "Body Mass Index calculated using a before_save when the clinic visit is updated"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.bigint "location_id"
    t.string "urine_glucose"
    t.index ["clinic_id"], name: "index_clinic_visits_on_clinic_id"
    t.index ["created_by_id"], name: "index_clinic_visits_on_created_by_id"
    t.index ["document"], name: "index_clinic_visits_on_document", using: :gin
    t.index ["location_id"], name: "index_clinic_visits_on_location_id"
    t.index ["patient_id"], name: "index_clinic_visits_on_patient_id"
    t.index ["type"], name: "index_clinic_visits_on_type"
    t.index ["updated_by_id"], name: "index_clinic_visits_on_updated_by_id"
  end

  create_table "clinical_allergies", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.text "description", null: false
    t.datetime "recorded_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_clinical_allergies_on_created_by_id"
    t.index ["deleted_at"], name: "index_clinical_allergies_on_deleted_at"
    t.index ["patient_id"], name: "index_clinical_allergies_on_patient_id"
    t.index ["updated_by_id"], name: "index_clinical_allergies_on_updated_by_id"
  end

  create_table "clinical_body_compositions", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.integer "modality_description_id"
    t.date "assessed_on", null: false
    t.decimal "overhydration", precision: 3, scale: 1, null: false
    t.decimal "volume_of_distribution", precision: 4, scale: 1, null: false
    t.decimal "total_body_water", precision: 4, scale: 1, null: false
    t.decimal "extracellular_water", precision: 4, scale: 1, null: false
    t.decimal "intracellular_water", precision: 3, scale: 1, null: false
    t.decimal "lean_tissue_index", precision: 4, scale: 1, null: false
    t.decimal "fat_tissue_index", precision: 4, scale: 1, null: false
    t.decimal "lean_tissue_mass", precision: 4, scale: 1, null: false
    t.decimal "fat_tissue_mass", precision: 4, scale: 1, null: false
    t.decimal "adipose_tissue_mass", precision: 4, scale: 1, null: false
    t.decimal "body_cell_mass", precision: 4, scale: 1, null: false
    t.decimal "quality_of_reading", precision: 6, scale: 3, null: false
    t.text "notes"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "assessor_id", null: false
    t.enum "pre_post_hd", enum_type: "clinical_body_composition_pre_post_hd"
    t.float "weight"
    t.index ["assessor_id"], name: "index_clinical_body_compositions_on_assessor_id"
    t.index ["created_by_id"], name: "index_clinical_body_compositions_on_created_by_id"
    t.index ["modality_description_id"], name: "index_clinical_body_compositions_on_modality_description_id"
    t.index ["patient_id"], name: "index_clinical_body_compositions_on_patient_id"
    t.index ["updated_by_id"], name: "index_clinical_body_compositions_on_updated_by_id"
  end

  create_table "clinical_dry_weights", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.float "weight", null: false
    t.date "assessed_on", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "assessor_id", null: false
    t.float "minimum_weight", comment: "Set by the clinicial, if the patient's weight drops below this value then the clinican may decide change drugs etc"
    t.float "maximum_weight", comment: "Set by the clinicial, if the patient's weight rises above this value then the clinican may decide change drugs etc"
    t.index ["assessor_id"], name: "index_clinical_dry_weights_on_assessor_id"
    t.index ["created_by_id"], name: "index_clinical_dry_weights_on_created_by_id"
    t.index ["patient_id", "created_at"], name: "index_clinical_dry_weights_on_patient_id_created_at", order: { created_at: :desc }, comment: "Ordered index to speed up latest dry weight queries"
    t.index ["patient_id"], name: "index_clinical_dry_weights_on_patient_id"
    t.index ["updated_by_id"], name: "index_clinical_dry_weights_on_updated_by_id"
  end

  create_table "clinical_igan_risks", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.decimal "risk", precision: 5, scale: 2, null: false, comment: "The risk of a 50% decline in estimated GFR or progression to end-stage renal disease 4.2 years after renal biopsy. Calculated using an external website and is a %value eg 40.1%"
    t.text "workings", comment: "The calculation output or summary (a block of text) which the user can copy to the clipboard manually from the from the external website, and paste into RW to be saved here. Details the parameters they input as well as the calculated risk"
    t.text "text", comment: "The calculation output or summary (a block of text) which the user can copy to the clipboard manually from the from the external website, and paste into RW to be saved here. Details the parameters they input as well as the calculated risk"
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_clinical_igan_risks_on_created_by_id"
    t.index ["patient_id"], name: "index_clinical_igan_risks_on_patient_id"
    t.index ["updated_by_id"], name: "index_clinical_igan_risks_on_updated_by_id"
  end

  create_table "clinical_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_clinical_versions_on_item_type_and_item_id"
  end

  create_table "death_causes", id: :serial, force: :cascade do |t|
    t.integer "code"
    t.string "description"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_death_causes_on_code", unique: true
  end

  create_table "death_locations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at", precision: nil
    t.integer "patients_preferred_count", default: 0, null: false, comment: "Counter cache for the number of patients preferring this location"
    t.integer "patients_actual_count", default: 0, null: false, comment: "Counter cache for the number of patients who died at this location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rr_outcome_code"
    t.string "rr_outcome_text"
    t.index "TRIM(BOTH FROM lower((name)::text))", name: "idx_death_locations_name", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_death_locations_on_deleted_at"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at", precision: nil
    t.datetime "locked_at", precision: nil
    t.datetime "failed_at", precision: nil
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "directory_people", force: :cascade do |t|
    t.string "given_name", null: false
    t.string "family_name", null: false
    t.string "title"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["created_by_id"], name: "index_directory_people_on_created_by_id"
    t.index ["updated_by_id"], name: "index_directory_people_on_updated_by_id"
  end

  create_table "drug_dmd_actual_medical_products", force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.string "virtual_medical_product_code"
    t.string "trade_family_code"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "index_drug_dmd_actual_medical_products_on_code", unique: true
  end

  create_table "drug_dmd_matches", force: :cascade do |t|
    t.bigint "drug_id"
    t.integer "prescriptions_count"
    t.string "drug_name"
    t.string "form_name"
    t.string "vtm_name"
    t.boolean "approved_vtm_match", default: false, null: false
    t.string "trade_family_name"
    t.boolean "approved_trade_family_match", default: false
    t.index ["drug_id"], name: "index_drug_dmd_matches_on_drug_id", unique: true
  end

  create_table "drug_dmd_virtual_medical_products", force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.string "form_code"
    t.string "route_code"
    t.string "atc_code"
    t.string "unit_of_measure_code_deprecated"
    t.string "strength_numerator_value"
    t.string "basis_of_strength"
    t.string "virtual_therapeutic_moiety_code"
    t.boolean "inactive", default: false, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "unit_dose_uom_code", comment: "dm+d name VMP.UNIT_DOSE_UOMCD"
    t.string "unit_dose_form_size_uom_code", comment: "dm+d name VMP.UDFS_UOMCD"
    t.string "active_ingredient_strength_numerator_uom_code", comment: "dm+d name VMP.STRNT_NMRTR_UOMCD"
    t.index ["code"], name: "index_drug_dmd_virtual_medical_products_on_code", unique: true
  end

  create_table "drug_dmd_virtual_therapeutic_moieties", force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.boolean "inactive", default: false, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "index_drug_dmd_vtm_on_code", unique: true
  end

  create_table "drug_forms", force: :cascade do |t|
    t.string "name"
    t.string "code", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "index_drug_forms_on_code", unique: true
  end

  create_table "drug_frequencies", force: :cascade do |t|
    t.string "name", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "doses_per_week", precision: 5, scale: 2, comment: "Examples: daily = 7, weekly = 1, twice daily = 14, monthly = 0.25"
    t.integer "position", default: 1, null: false
    t.index ["name"], name: "index_drug_frequencies_on_name", unique: true
    t.index ["position"], name: "index_drug_frequencies_on_position"
  end

  create_table "drug_homecare_forms", comment: "X-ref table that says which drug_type is supplied by which (homecare) supplier and the data required (see form_name and form_version) to programmatically select and create the right PDF Homecare Supply form for them (using the renalware-forms gem) so this can be printed out and signed.", force: :cascade do |t|
    t.bigint "drug_type_id", null: false
    t.bigint "supplier_id", null: false
    t.string "form_name", null: false, comment: "The lower-case programmatic name used for this provider, eg 'fresenius'"
    t.string "form_version", null: false, comment: "A number e.g. '1' that specified what version of the homecare supply formshould be created"
    t.string "prescription_durations", default: [], null: false, comment: "An array of options where each integer is a number of units - these will be displayed as dropdown options presented to the user, and checkboxes on the homecare delivery form PDF. E.g [3,6] will be displayed as options '3 months' and '6 months' (see also prescription_duration_unit)", array: true
    t.integer "prescription_duration_default", comment: "The default option to pre-select when displaying prescription_duration_options"
    t.enum "prescription_duration_unit", null: false, comment: "E.g. 'week' or 'month'", enum_type: "duration"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["drug_type_id", "supplier_id"], name: "index_drug_homecare_forms_on_drug_type_id_and_supplier_id", unique: true, comment: "A supplier can only have one form active for any drug type"
    t.index ["supplier_id"], name: "index_drug_homecare_forms_on_supplier_id"
  end

  create_table "drug_patient_group_directions", comment: "Patient group directions (PGDs) are written instructions to help you supply or administer medicines to patients, usually in planned circumstances https://www.gov.uk/government/publications/patient-group-directions-pgds/ patient-group-directions-who-can-use-them", force: :cascade do |t|
    t.string "name", null: false, comment: "E.g. Ceftriaxone INJECTION"
    t.string "code", comment: "E.g. DA/57"
    t.date "starts_on", comment: "The date the PGD is effective from e.g. Apr-24-2021"
    t.date "ends_on", comment: "The date the PGD is expires e.g. Apr-24-2024"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["code"], name: "index_drug_patient_group_directions_on_code", unique: true, where: "((ends_on IS NULL) AND (deleted_at IS NULL))"
  end

  create_table "drug_suppliers", comment: "A list of suppliers who deliver drugs eg for homecare", force: :cascade do |t|
    t.string "name", null: false, comment: "The providers display name e.g. 'Fresenius'"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "drug_trade_families", force: :cascade do |t|
    t.string "name"
    t.string "code", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "index_drug_trade_families_on_code", unique: true
  end

  create_table "drug_trade_family_classifications", force: :cascade do |t|
    t.bigint "drug_id", null: false
    t.bigint "trade_family_id", null: false
    t.boolean "enabled", default: false, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["drug_id", "trade_family_id"], name: "index_drug_trade_family_class_on_drug_id_and_trade_family", unique: true
    t.index ["drug_id"], name: "index_drug_trade_family_classifications_on_drug_id"
    t.index ["trade_family_id"], name: "index_drug_trade_family_classifications_on_trade_family_id"
  end

  create_table "drug_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "position", default: 0, null: false, comment: "Controls display order"
    t.integer "weighting", default: 0, null: false, comment: "More important drug types have a higher value so their colour trumps other types a drug might have."
    t.enum "colour", comment: "A CSS colour e.f. '#A12A12'", enum_type: "enum_colour_name"
    t.string "atc_codes", array: true
    t.index ["code"], name: "index_drug_types_on_code", unique: true
    t.index ["name"], name: "index_drug_types_on_name", unique: true
  end

  create_table "drug_types_drugs", force: :cascade do |t|
    t.integer "drug_id", null: false
    t.integer "drug_type_id", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["drug_id", "drug_type_id"], name: "index_drug_types_drugs_on_drug_id_and_drug_type_id", unique: true
    t.index ["drug_type_id"], name: "index_drug_types_drugs_on_drug_type_id"
  end

  create_table "drug_unit_of_measures", force: :cascade do |t|
    t.string "name"
    t.string "code", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "index_drug_unit_of_measures_on_code", unique: true
  end

  create_table "drug_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_drug_versions_on_item_type_and_item_id"
  end

  create_table "drug_vmp_classifications", force: :cascade do |t|
    t.bigint "drug_id", null: false
    t.string "code", null: false
    t.bigint "form_id"
    t.bigint "route_id"
    t.bigint "unit_of_measure_id"
    t.integer "trade_family_ids", default: [], array: true
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.boolean "inactive", default: false, null: false
    t.bigint "unit_dose_uom_id"
    t.bigint "unit_dose_form_size_uom_id"
    t.bigint "active_ingredient_strength_numerator_uom_id"
    t.index ["active_ingredient_strength_numerator_uom_id"], name: "index_drug_vmp_classifications_on_active_ing_st_num_uom_id"
    t.index ["code"], name: "index_drug_vmp_classifications_on_code", unique: true
    t.index ["drug_id"], name: "index_drug_vmp_classifications_on_drug_id"
    t.index ["form_id"], name: "index_drug_vmp_classifications_on_form_id"
    t.index ["route_id"], name: "index_drug_vmp_classifications_on_route_id"
    t.index ["unit_dose_form_size_uom_id"], name: "index_drug_vmp_classifications_on_unit_dose_form_size_uom_id"
    t.index ["unit_dose_uom_id"], name: "index_drug_vmp_classifications_on_unit_dose_uom_id"
    t.index ["unit_of_measure_id"], name: "index_drug_vmp_classifications_on_unit_of_measure_id"
  end

  create_table "drugs", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "description"
    t.string "read_code"
    t.string "code"
    t.boolean "inactive", default: false, null: false
    t.index ["code"], name: "index_drugs_on_code", unique: true
    t.index ["deleted_at"], name: "index_drugs_on_deleted_at"
  end

  create_table "event_categories", force: :cascade do |t|
    t.string "name", null: false
    t.integer "position", default: 10, null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_event_categories_on_deleted_at"
    t.index ["name"], name: "index_event_categories_on_name", unique: true
  end

  create_table "event_subtypes", force: :cascade do |t|
    t.bigint "event_type_id", null: false
    t.string "name", null: false
    t.text "description"
    t.integer "position", default: 0, null: false, comment: "The order of the subtype within an event type, if >1 subtypes"
    t.jsonb "definition", default: "{}", null: false
    t.bigint "updated_by_id", null: false
    t.bigint "created_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "deactivated_at", precision: nil
    t.boolean "active", default: true
    t.index ["created_by_id"], name: "index_event_subtypes_on_created_by_id"
    t.index ["deactivated_at"], name: "index_event_subtypes_on_deactivated_at"
    t.index ["event_type_id"], name: "index_event_subtypes_on_event_type_id"
    t.index ["updated_by_id"], name: "index_event_subtypes_on_updated_by_id"
  end

  create_table "event_type_alert_triggers", comment: "Matching alerts are displayed on patient pages", force: :cascade do |t|
    t.bigint "event_type_id", null: false
    t.text "when_event_document_contains"
    t.text "when_event_description_contains"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["event_type_id"], name: "index_event_type_alert_triggers_on_event_type_id"
  end

  create_table "event_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "event_class_name"
    t.string "slug"
    t.bigint "category_id", null: false
    t.boolean "save_pdf_to_electronic_public_register", default: false, null: false
    t.string "title"
    t.boolean "hidden", default: false, null: false
    t.integer "events_count", default: 0, null: false, comment: "Counter cache column which Rails will update and which stores the count of events created with this type"
    t.string "external_document_type_code", comment: "A code eg 'MDT' used as metadata when renderimg the event to a PDF"
    t.string "external_document_type_description", comment: "See comment for external_document_type_code"
    t.boolean "superadmin_can_always_change", default: true, null: false
    t.integer "author_change_window_hours", default: 0, null: false, comment: "Period post-creation within which an event of this type can be edited by the author"
    t.integer "admin_change_window_hours", default: 0, null: false, comment: "Period post-creation within which an event of this type can be edited by an admin (or superadmin if superadmin_can_always_change is false"
    t.index ["category_id"], name: "index_event_types_on_category_id"
    t.index ["deleted_at"], name: "index_event_types_on_deleted_at"
    t.index ["hidden"], name: "index_event_types_on_hidden"
    t.index ["slug"], name: "index_event_types_on_slug", unique: true
  end

  create_table "event_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_event_versions_on_item_type_and_item_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.datetime "date_time", precision: nil, null: false
    t.integer "event_type_id"
    t.string "description"
    t.text "notes"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.string "type", null: false
    t.jsonb "document"
    t.datetime "deleted_at", precision: nil
    t.bigint "subtype_id"
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

  create_table "feed_file_types", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.text "prompt", null: false
    t.string "download_url_title"
    t.string "download_url"
    t.string "filename_validation_pattern", default: ".*", null: false
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_feed_file_types_on_name"
  end

  create_table "feed_files", id: :serial, force: :cascade do |t|
    t.integer "file_type_id", null: false
    t.string "location", null: false
    t.integer "status", default: 0, null: false
    t.text "result"
    t.integer "time_taken"
    t.integer "attempts", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id"
    t.index ["created_by_id"], name: "index_feed_files_on_created_by_id"
    t.index ["file_type_id"], name: "index_feed_files_on_file_type_id"
    t.index ["updated_by_id"], name: "index_feed_files_on_updated_by_id"
  end

  create_table "feed_gps", force: :cascade do |t|
    t.text "code", null: false
    t.text "name", null: false
    t.text "telephone"
    t.text "street_1"
    t.text "street_2"
    t.text "street_3"
    t.text "town"
    t.text "county"
    t.text "postcode"
    t.string "status"
    t.index ["code"], name: "index_feed_gps_on_code", unique: true
  end

  create_table "feed_hl7_test_messages", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.text "body", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_feed_hl7_test_messages_on_name"
  end

  create_table "feed_logs", comment: "Stores links to a feed_message and a candidate/close-matched patient where eg a patient with the incoming nhs_number is found but their DOB differs. This allows an admin to review the log and diagnose the issue.", force: :cascade do |t|
    t.enum "log_type", null: false, enum_type: "enum_feed_log_type"
    t.enum "log_reason", null: false, enum_type: "enum_feed_log_reason"
    t.bigint "patient_id"
    t.bigint "message_id"
    t.enum "message_type", enum_type: "hl7_message_type"
    t.enum "event_type", enum_type: "hl7_event_type"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["log_reason"], name: "index_feed_logs_on_log_reason"
    t.index ["log_type"], name: "index_feed_logs_on_log_type"
    t.index ["message_id"], name: "index_feed_logs_on_message_id"
    t.index ["patient_id"], name: "index_feed_logs_on_patient_id"
  end

  create_table "feed_message_replays", force: :cascade do |t|
    t.bigint "replay_request_id", null: false
    t.bigint "message_id", null: false
    t.boolean "success", default: false, null: false
    t.text "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "urn"
    t.index ["message_id"], name: "index_feed_message_replays_on_message_id"
    t.index ["replay_request_id"], name: "index_feed_message_replays_on_replay_request_id"
    t.index ["urn"], name: "index_feed_message_replays_on_urn"
  end

  create_table "feed_messages", id: :serial, force: :cascade do |t|
    t.string "event_code_deprecated"
    t.string "header_id", null: false
    t.text "body", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "body_hash"
    t.string "nhs_number"
    t.boolean "processed", default: false
    t.jsonb "patient_identifiers", default: {}, null: false
    t.enum "message_type", enum_type: "hl7_message_type"
    t.enum "event_type", enum_type: "hl7_event_type"
    t.string "local_patient_id"
    t.string "local_patient_id_2"
    t.string "local_patient_id_3"
    t.string "local_patient_id_4"
    t.string "local_patient_id_5"
    t.enum "orc_order_status", enum_type: "enum_hl7_orc_order_status"
    t.date "dob"
    t.string "orc_filler_order_number"
    t.datetime "sent_at"
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
    t.index ["sent_at"], name: "index_feed_messages_on_sent_at"
  end

  create_table "feed_msg_queue", force: :cascade do |t|
    t.integer "feed_msg_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_msg_id"], name: "index_feed_msg_queue_on_feed_msg_id", unique: true
  end

  create_table "feed_msgs", force: :cascade do |t|
    t.datetime "sent_at", precision: nil, null: false
    t.integer "version", default: 1, null: false
    t.datetime "processed_at", precision: nil
    t.enum "message_type", null: false, enum_type: "hl7_message_type"
    t.enum "event_type", null: false, enum_type: "hl7_event_type"
    t.string "orc_filler_order_number"
    t.enum "orc_order_status", enum_type: "enum_hl7_orc_order_status"
    t.string "message_control_id"
    t.text "body", null: false
    t.string "nhs_number"
    t.string "local_patient_id"
    t.string "local_patient_id_2"
    t.string "local_patient_id_3"
    t.string "local_patient_id_4"
    t.string "local_patient_id_5"
    t.date "dob"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_control_id"], name: "index_feed_msgs_on_message_control_id"
    t.index ["orc_filler_order_number"], name: "index_feed_msgs_on_orc_filler_order_number"
    t.index ["sent_at"], name: "index_feed_msgs_on_sent_at"
  end

  create_table "feed_outgoing_documents", comment: "A queue of documents (letters, events) that require processing by an external system e.g. Mirth. For example when a letter is approved, a hospital's Renalware host app may listener for that event and write a row to this table, including the (polymorphic) details of the document (in this case the class name and id of the letter). When Mirth or the external system queries the Renalware API for for waiting queued documents, it will return documents referenced here that have a state of 'queued'. The renderable relation must implement the expected methods required to render to the requested format e.g. HL7 (and in the future FHIR).", force: :cascade do |t|
    t.string "renderable_type", null: false
    t.bigint "renderable_id", null: false, comment: "The letter/event/etc to be processed"
    t.enum "state", default: "queued", null: false, enum_type: "feed_outgoing_document_state"
    t.json "printing_options", default: {}
    t.uuid "external_uuid", default: -> { "gen_random_uuid()" }, comment: "E.g. the Mirth message id"
    t.text "error"
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "error_code"
    t.datetime "errored_at", precision: nil
    t.datetime "retried_at", precision: nil
    t.text "comments"
    t.index ["created_by_id"], name: "index_feed_outgoing_documents_on_created_by_id"
    t.index ["external_uuid"], name: "index_feed_outgoing_documents_on_external_uuid", unique: true
    t.index ["renderable_type", "renderable_id"], name: "index_feed_outgoing_documents_on_renderable"
    t.index ["updated_by_id"], name: "index_feed_outgoing_documents_on_updated_by_id"
  end

  create_table "feed_practice_gps", force: :cascade do |t|
    t.text "gp_code", null: false
    t.text "practice_code", null: false
    t.date "joined_on"
    t.date "left_on"
    t.integer "primary_care_physician_id"
    t.integer "practice_id"
  end

  create_table "feed_raw_hl7_message_errors", force: :cascade do |t|
    t.text "body", null: false
    t.text "error_message"
    t.text "error_message_backtrace"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "sent_at", null: false
    t.index ["sent_at"], name: "index_feed_raw_hl7_message_errors_on_sent_at"
  end

  create_table "feed_raw_hl7_messages", force: :cascade do |t|
    t.string "body"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "sent_at"
    t.index ["created_at"], name: "index_feed_raw_hl7_messages_on_created_at", comment: "We query for rows ordering by created_at asc to give us a chance to process in FIFO order, so having an ordered index means when we use a LIMIT (batching) in the query, rows will be determined by index scan without having to look to the end of the table - or something like that! In fact the index is implicitly ordered already but having created_at: :asc here makes our intention more explicit."
    t.index ["sent_at"], name: "index_feed_raw_hl7_messages_on_sent_at"
  end

  create_table "feed_replay_requests", force: :cascade do |t|
    t.jsonb "criteria", default: {}
    t.datetime "started_at", null: false
    t.datetime "finished_at"
    t.integer "total_messages", default: 0, null: false
    t.integer "failed_messages", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "patient_id", null: false
    t.text "error_message"
    t.text "reason"
    t.index ["criteria"], name: "index_feed_replay_requests_on_criteria", using: :gin
    t.index ["patient_id"], name: "index_feed_replay_requests_on_patient_id"
  end

  create_table "feed_sausage_queue_deprecated", force: :cascade do |t|
    t.integer "feed_sausage_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_sausage_id"], name: "index_feed_sausage_queue_deprecated_on_feed_sausage_id"
  end

  create_table "feed_sausages_deprecated", force: :cascade do |t|
    t.datetime "sent_at", precision: nil, null: false
    t.integer "version", default: 1, null: false
    t.datetime "processed_at", precision: nil
    t.enum "message_type", null: false, enum_type: "hl7_message_type"
    t.enum "event_type", null: false, enum_type: "hl7_event_type"
    t.string "orc_filler_order_number"
    t.enum "orc_order_status", enum_type: "enum_hl7_orc_order_status"
    t.string "message_control_id"
    t.text "body", null: false
    t.string "nhs_number"
    t.string "local_patient_id"
    t.string "local_patient_id_2"
    t.string "local_patient_id_3"
    t.string "local_patient_id_4"
    t.string "local_patient_id_5"
    t.date "dob"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_control_id"], name: "index_feed_sausages_deprecated_on_message_control_id", unique: true
    t.index ["orc_filler_order_number"], name: "index_feed_sausages_deprecated_on_orc_filler_order_number", unique: true, where: "((orc_filler_order_number IS NOT NULL) AND ((orc_filler_order_number)::text <> ''::text))"
    t.index ["sent_at"], name: "index_feed_sausages_deprecated_on_sent_at"
  end

  create_table "geography_local_authority_districts", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.integer "imd_rank", comment: "A simple Index of Multiple Deprivation (IMD) ranking of the LA from most to least deprived."
    t.integer "imd_pct", comment: "Percentage - where the most deprived 1% of LAs are 1 and the next most deprived 1% are 2 etc."
    t.integer "imd_decile", comment: "Grouping the most deprived 10% of LA as Decile 1 and the second most deprived 10% as decile 2 etc."
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "index_geography_local_authority_districts_on_code", unique: true
    t.index ["name"], name: "index_geography_local_authority_districts_on_name", unique: true
  end

  create_table "geography_lower_super_output_areas", comment: "LSOAs are a type of census geography that were created to allow for comparisons across\ndifferent parts of the country. LSOAs fall within the boundaries of Local Authority\nDistricts (LADs). LOSAa comprise between 400 and 1,200 households and have a usually\nresident population between 1,000 and 3,000 persons. LSOAs are made up of groups of\nOutput Areas (OAs), usually four or five.\n", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.integer "imd_rank", comment: "A simple Index of Multiple Deprivation (IMD) ranking of the LSOA from most to least deprived."
    t.integer "imd_pct", comment: "Percentage - where the most deprived 1% of LSOAs are 1 and the next most deprived 1% are 2 etc."
    t.integer "imd_decile", comment: "Grouping the most deprived 10% of LSOAs as Decile 1 and the second most deprived 10% as decile 2 etc."
    t.bigint "middle_super_output_area_id", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "index_geography_lower_super_output_areas_on_code", unique: true
    t.index ["middle_super_output_area_id"], name: "idx_on_middle_super_output_area_id_b9987db7f1"
  end

  create_table "geography_middle_super_output_areas", comment: "MSOAs are groups of Lower Layer Super Output Areas (LSOAs) -  usually four or five - that\nare used to publish statistics. They are designed to contain between 5,000 and 15,000\nresidents and 2,000 and 6,000 households. MSOAs are generated automatically by zone-design\nsoftware using census data. They are often used when statistics cannot be published at the\nLSOA level because they could be disclosive of an individual's data. As of 2021, there were\n6,856 MSOAs in England and 408 in Wales.\n", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.bigint "local_authority_district_id", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code", "local_authority_district_id"], name: "idx_on_code_local_authority_district_id_fe2b0c7d98", unique: true
    t.index ["code"], name: "index_geography_middle_super_output_areas_on_code", unique: true
    t.index ["local_authority_district_id"], name: "idx_on_local_authority_district_id_103e1854df"
    t.index ["name"], name: "index_geography_middle_super_output_areas_on_name"
  end

  create_table "geography_output_areas", comment: "Output Areas (OAs) are the lowest level of geographical area for census statistics and\nwere first created following the 2001 Census\n", force: :cascade do |t|
    t.string "code", null: false
    t.bigint "lower_super_output_area_id", null: false
    t.index ["code"], name: "index_geography_output_areas_on_code", unique: true
    t.index ["lower_super_output_area_id"], name: "index_geography_output_areas_on_lower_super_output_area_id"
  end

  create_table "geography_postcodes", force: :cascade do |t|
    t.string "postal_code", null: false
    t.bigint "lower_super_output_area_id", null: false
    t.index ["lower_super_output_area_id"], name: "index_geography_postcodes_on_lower_super_output_area_id"
    t.index ["postal_code"], name: "index_geography_postcodes_on_postal_code", unique: true
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.text "error"
    t.integer "error_event", limit: 2
    t.text "error_backtrace", array: true
    t.uuid "process_id"
    t.interval "duration"
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
    t.index ["process_id", "created_at"], name: "index_good_job_executions_on_process_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
    t.integer "lock_type", limit: 2
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at", precision: nil
    t.datetime "performed_at", precision: nil
    t.datetime "finished_at", precision: nil
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at", precision: nil
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.text "labels", array: true
    t.uuid "locked_by_id"
    t.datetime "locked_at"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["locked_by_id"], name: "index_good_jobs_on_locked_by_id", where: "(locked_by_id IS NOT NULL)"
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["priority", "scheduled_at"], name: "index_good_jobs_on_priority_scheduled_at_unfinished_unlocked", where: "((finished_at IS NULL) AND (locked_by_id IS NULL))"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "hd_acuity_assessments", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.decimal "ratio", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_hd_acuity_assessments_on_created_by_id"
    t.index ["patient_id"], name: "index_hd_acuity_assessments_on_patient_id"
    t.index ["updated_by_id"], name: "index_hd_acuity_assessments_on_updated_by_id"
    t.check_constraint "ratio = ANY (ARRAY[0.25, 0.33, 0.5, 1.0])", name: "check_ratio_valid_values"
  end

  create_table "hd_cannulation_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "qhd33_code", comment: "Needling Method (RR50)"
    t.index ["deleted_at"], name: "index_hd_cannulation_types_on_deleted_at"
  end

  create_table "hd_dialysates", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "sodium_content", null: false
    t.string "sodium_content_uom", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.decimal "bicarbonate_content", precision: 10, scale: 2
    t.string "bicarbonate_content_uom", default: "mmol/L"
    t.decimal "calcium_content", precision: 10, scale: 2
    t.string "calcium_content_uom", default: "mmol/L"
    t.decimal "glucose_content", precision: 10, scale: 2
    t.string "glucose_content_uom", default: "g/L"
    t.decimal "potassium_content", precision: 10, scale: 2
    t.string "potassium_content_uom", default: "mmol/L"
    t.index ["deleted_at"], name: "index_hd_dialysates_on_deleted_at"
  end

  create_table "hd_dialysers", id: :serial, force: :cascade do |t|
    t.string "group", null: false
    t.string "name", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.decimal "membrane_surface_area", precision: 10, scale: 2
    t.decimal "membrane_surface_area_coefficient_k0a", precision: 10, scale: 2
  end

  create_table "hd_diaries", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "hospital_unit_id", null: false
    t.integer "master_diary_id"
    t.integer "week_number"
    t.integer "year"
    t.boolean "master", default: false, null: false
    t.integer "updated_by_id", null: false
    t.integer "created_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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

  create_table "hd_diary_slots", force: :cascade do |t|
    t.integer "diary_id", null: false
    t.integer "station_id", null: false
    t.integer "day_of_week", null: false
    t.integer "diurnal_period_code_id", null: false
    t.bigint "patient_id", null: false
    t.integer "updated_by_id", null: false
    t.integer "created_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "archived", default: false, null: false
    t.datetime "archived_at", precision: nil
    t.time "arrival_time"
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

  create_table "hd_diurnal_period_codes", force: :cascade do |t|
    t.string "code", null: false
    t.text "description"
    t.integer "sort_order", default: 0, null: false
    t.index ["code"], name: "index_hd_diurnal_period_codes_on_code", unique: true
  end

  create_table "hd_patient_statistics", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "hospital_unit_id", null: false
    t.integer "month"
    t.integer "year"
    t.boolean "rolling"
    t.decimal "pre_mean_systolic_blood_pressure", precision: 10, scale: 2
    t.decimal "pre_mean_diastolic_blood_pressure", precision: 10, scale: 2
    t.decimal "post_mean_systolic_blood_pressure", precision: 10, scale: 2
    t.decimal "post_mean_diastolic_blood_pressure", precision: 10, scale: 2
    t.decimal "lowest_systolic_blood_pressure", precision: 10, scale: 2
    t.decimal "highest_systolic_blood_pressure", precision: 10, scale: 2
    t.decimal "mean_fluid_removal", precision: 10, scale: 2
    t.decimal "mean_weight_loss", precision: 10, scale: 2
    t.decimal "mean_machine_ktv", precision: 10, scale: 2
    t.decimal "mean_blood_flow", precision: 10, scale: 2
    t.decimal "mean_litres_processed", precision: 10, scale: 2
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "session_count", default: 0, null: false
    t.integer "number_of_missed_sessions"
    t.integer "dialysis_minutes_shortfall"
    t.decimal "dialysis_minutes_shortfall_percentage", precision: 10, scale: 2
    t.decimal "mean_ufr", precision: 10, scale: 2
    t.decimal "mean_weight_loss_as_percentage_of_body_weight", precision: 10, scale: 2
    t.integer "number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct"
    t.jsonb "pathology_snapshot", default: {}, null: false
    t.index ["hospital_unit_id"], name: "index_hd_patient_statistics_on_hospital_unit_id"
    t.index ["month"], name: "index_hd_patient_statistics_on_month"
    t.index ["patient_id", "month", "year"], name: "index_hd_patient_statistics_on_patient_id_and_month_and_year", unique: true
    t.index ["patient_id", "rolling"], name: "index_hd_patient_statistics_on_patient_id_and_rolling", unique: true
    t.index ["patient_id"], name: "index_hd_patient_statistics_on_patient_id"
    t.index ["rolling"], name: "index_hd_patient_statistics_on_rolling"
    t.index ["year"], name: "index_hd_patient_statistics_on_year"
  end

  create_table "hd_preference_sets", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "hospital_unit_id"
    t.string "other_schedule"
    t.date "entered_on"
    t.text "notes"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "schedule_definition_id"
    t.index ["created_by_id"], name: "index_hd_preference_sets_on_created_by_id"
    t.index ["hospital_unit_id"], name: "index_hd_preference_sets_on_hospital_unit_id"
    t.index ["patient_id"], name: "index_hd_preference_sets_on_patient_id"
    t.index ["schedule_definition_id"], name: "index_hd_preference_sets_on_schedule_definition_id"
    t.index ["updated_by_id"], name: "index_hd_preference_sets_on_updated_by_id"
  end

  create_table "hd_prescription_administration_reasons", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_hd_prescription_administration_reasons_on_name", unique: true
  end

  create_table "hd_prescription_administrations", id: :serial, force: :cascade do |t|
    t.integer "hd_session_id"
    t.integer "prescription_id", null: false
    t.boolean "administered"
    t.text "notes"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "administered_by_id"
    t.bigint "witnessed_by_id"
    t.boolean "administrator_authorised", default: false, null: false
    t.boolean "witness_authorised", default: false, null: false
    t.bigint "reason_id"
    t.datetime "deleted_at", precision: nil
    t.bigint "patient_id"
    t.date "recorded_on"
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

  create_table "hd_profiles", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.integer "hospital_unit_id"
    t.string "other_schedule"
    t.integer "prescribed_time"
    t.date "prescribed_on"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.jsonb "document"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "prescriber_id"
    t.integer "named_nurse_id_legacy"
    t.integer "transport_decider_id"
    t.datetime "deactivated_at", precision: nil
    t.boolean "active", default: true
    t.integer "schedule_definition_id"
    t.bigint "dialysate_id"
    t.time "scheduled_time"
    t.string "home_machine_identifier", comment: "eg serial number of Baxter Home AK98 dialyser with which we sync via HDCloud API"
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

  create_table "hd_provider_units", force: :cascade do |t|
    t.bigint "hospital_unit_id", null: false
    t.bigint "hd_provider_id", null: false
    t.string "providers_reference"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["hd_provider_id", "hospital_unit_id"], name: "index_hd_provider_units_on_hd_provider_id_and_hospital_unit_id", unique: true
    t.index ["hd_provider_id"], name: "index_renalware.hd_provider_units_on_hd_provider_id"
    t.index ["hospital_unit_id"], name: "index_renalware.hd_provider_units_on_hospital_unit_id"
    t.index ["providers_reference"], name: "index_renalware.hd_provider_units_on_providers_reference"
  end

  create_table "hd_providers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "hd_schedule_definitions", force: :cascade do |t|
    t.integer "days", default: [], null: false, array: true
    t.integer "diurnal_period_id", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "days_text"
    t.integer "sort_order", default: 0, null: false
    t.index ["days"], name: "index_hd_schedule_definitions_on_days", using: :gin
    t.index ["diurnal_period_id"], name: "index_hd_schedule_definitions_on_diurnal_period_id"
    t.exclusion_constraint "diurnal_period_id WITH =, days WITH =", using: :gist, name: "days_array_unique_scoped_to_period"
  end

  create_table "hd_session_form_batch_items", force: :cascade do |t|
    t.bigint "batch_id", null: false
    t.integer "printable_id", null: false
    t.integer "status", limit: 2, default: 0, null: false
    t.index ["batch_id", "printable_id"], name: "index_hd_session_form_batch_items_on_batch_id_and_printable_id", unique: true
    t.index ["status"], name: "index_hd_session_form_batch_items_on_status"
  end

  create_table "hd_session_form_batches", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.jsonb "query_params", default: {}, null: false
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.string "filepath"
    t.string "last_error"
    t.integer "batch_items_count"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["created_by_id"], name: "index_hd_session_form_batches_on_created_by_id"
    t.index ["status"], name: "index_hd_session_form_batches_on_status"
    t.index ["updated_by_id"], name: "index_hd_session_form_batches_on_updated_by_id"
  end

  create_table "hd_session_patient_group_directions", force: :cascade do |t|
    t.bigint "session_id", null: false
    t.bigint "patient_group_direction_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_group_direction_id"], name: "idx_hd_session_pgds_pgd_id"
    t.index ["session_id", "patient_group_direction_id"], name: "idx_hd_session_pgds_session_pgd"
    t.index ["session_id"], name: "index_hd_session_patient_group_directions_on_session_id"
  end

  create_table "hd_sessions", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.integer "hospital_unit_id"
    t.integer "modality_description_id"
    t.date "performed_on"
    t.time "start_time"
    t.time "end_time"
    t.integer "duration"
    t.text "notes"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.jsonb "document"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "signed_on_by_id"
    t.integer "signed_off_by_id"
    t.string "type", null: false
    t.datetime "signed_off_at", precision: nil
    t.integer "profile_id"
    t.integer "dry_weight_id"
    t.bigint "dialysate_id"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.bigint "external_id"
    t.datetime "deleted_at", precision: nil
    t.datetime "started_at", precision: nil
    t.datetime "stopped_at", precision: nil
    t.bigint "provider_id"
    t.string "machine_ip_address"
    t.bigint "hd_station_id", comment: "The HD Station (eg 'Bay 1 Bed 2') where the patient was dialysed"
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

  create_table "hd_slot_request_access_states", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "position", default: 0, null: false
    t.index "lower(name)", name: "index_hd_slot_request_access_states_on_name", unique: true
  end

  create_table "hd_slot_request_deletion_reasons", force: :cascade do |t|
    t.string "reason"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_hd_slot_request_deletion_reasons_on_deleted_at"
  end

  create_table "hd_slot_request_locations", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "position", default: 0, null: false
    t.index "lower(name)", name: "index_hd_slot_request_locations_on_name", unique: true
  end

  create_table "hd_slot_requests", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.enum "urgency", null: false, enum_type: "enum_hd_slot_request_urgency"
    t.boolean "inpatient", default: false, null: false
    t.boolean "late_presenter", default: false, null: false, comment: "known to service <90 days"
    t.boolean "boolean", default: false, null: false, comment: "known to service <90 days"
    t.boolean "suitable_for_twilight_slots", default: false, null: false
    t.text "specific_requirements", comment: "transport requirements, blood borne viruses etc"
    t.text "notes"
    t.datetime "allocated_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "deletion_reason_id"
    t.boolean "external_referral", default: false, null: false
    t.boolean "medically_fit_for_discharge", default: false, null: false, comment: "The datetime the MFFD checkbox was checked"
    t.datetime "medically_fit_for_discharge_at", comment: "The datetime the MFFD checkbox was checked"
    t.bigint "medically_fit_for_discharge_by_id", comment: "The id of the user show checked the MFFD checkbox on the HD Slot Request form"
    t.bigint "location_id"
    t.bigint "access_state_id"
    t.boolean "requires_bbv_slot", default: false, null: false
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

  create_table "hd_station_locations", force: :cascade do |t|
    t.string "name", null: false
    t.string "colour", null: false
    t.index ["name"], name: "index_hd_station_locations_on_name"
  end

  create_table "hd_stations", force: :cascade do |t|
    t.bigint "hospital_unit_id", null: false
    t.integer "position", default: 0, null: false
    t.string "name"
    t.integer "updated_by_id", null: false
    t.integer "created_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "location_id"
    t.index ["created_by_id"], name: "index_hd_stations_on_created_by_id"
    t.index ["deleted_at"], name: "index_hd_stations_on_deleted_at"
    t.index ["hospital_unit_id"], name: "index_hd_stations_on_hospital_unit_id"
    t.index ["location_id"], name: "index_hd_stations_on_location_id"
    t.index ["position"], name: "index_hd_stations_on_position"
    t.index ["updated_by_id"], name: "index_hd_stations_on_updated_by_id"
  end

  create_table "hd_transmission_logs", force: :cascade do |t|
    t.bigint "parent_id"
    t.string "direction", null: false
    t.string "format", null: false
    t.string "status"
    t.bigint "hd_provider_unit_id"
    t.bigint "patient_id"
    t.string "filepath"
    t.text "payload"
    t.jsonb "result", default: {}
    t.text "error_messages", default: [], array: true
    t.datetime "transmitted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "external_session_id"
    t.bigint "session_id"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
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

  create_table "hd_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "hd_versions_type_id"
  end

  create_table "hd_vnd_risk_assessments", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.enum "risk1", null: false, comment: "What is the likelihood that the staff (or carer) will fail to observe an actual or potential VND for this patient?", enum_type: "hd_vnd_risk_level_itemised"
    t.enum "risk2", null: false, comment: "What is the likelihood that the patient will fail to raise the alarm if they experience VND?", enum_type: "hd_vnd_risk_level_itemised"
    t.enum "risk3", null: false, comment: "What is the likelihood of the patient behaving in a way that could lead to VND?", enum_type: "hd_vnd_risk_level_itemised"
    t.enum "risk4", null: false, comment: "What is the likelihood of the taping failing to ensure that the needle is secure throughout dialysis?", enum_type: "hd_vnd_risk_level_itemised"
    t.integer "overall_risk_score", null: false, comment: "Overall risk score for a serious Venous Needle Dislodgement incident eg 6"
    t.enum "overall_risk_level", null: false, comment: "Overall risk level for a serious Venous Needle Dislodgement incident eg 'high'", enum_type: "hd_vnd_risk_level_overall"
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_hd_vnd_risk_assessments_on_created_by_id"
    t.index ["deleted_at"], name: "index_hd_vnd_risk_assessments_on_deleted_at"
    t.index ["patient_id"], name: "index_hd_vnd_risk_assessments_on_patient_id"
    t.index ["updated_by_id"], name: "index_hd_vnd_risk_assessments_on_updated_by_id"
  end

  create_table "help_tour_annotations", force: :cascade do |t|
    t.bigint "page_id", null: false
    t.integer "position", default: 1, null: false
    t.string "title"
    t.string "text", null: false
    t.string "attached_to_selector", null: false
    t.string "attached_to_position", default: "bottom", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["page_id", "attached_to_selector"], name: "idx_on_page_id_attached_to_selector_1d87c582e9", unique: true
    t.index ["page_id"], name: "index_help_tour_annotations_on_page_id"
  end

  create_table "help_tour_pages", force: :cascade do |t|
    t.string "name"
    t.string "route", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index "lower((route)::text)", name: "index_help_tour_pages_on_lower_route", unique: true
  end

  create_table "hospital_centres", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.string "location"
    t.boolean "active"
    t.boolean "is_transplant_site", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "info"
    t.string "trust_name"
    t.string "trust_caption"
    t.boolean "host_site", default: false, null: false
    t.string "abbrev"
    t.boolean "default_site", default: false, null: false
    t.integer "departments_count", default: 0, null: false, comment: "Counter cache for the number of departments at this centre"
    t.integer "units_count", default: 0, null: false, comment: "Counter cache for the number of units at this centre"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.integer "position", default: 10, null: false, comment: "Allows us to float hard-to-find options like 'Other' and 'Non-UK' the top of of dropdown lists"
    t.index ["abbrev"], name: "index_hospital_centres_on_abbrev", unique: true
    t.index ["code"], name: "index_hospital_centres_on_code"
    t.index ["host_site"], name: "index_hospital_centres_on_host_site"
  end

  create_table "hospital_departments", comment: "Can be assigned for example to a Letters::Letterhead. Useful for e.g. when including the sending organisation's details in a GP Connect message.", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "hospital_centre_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_hospital_departments_on_deleted_at"
    t.index ["hospital_centre_id"], name: "index_hospital_departments_on_hospital_centre_id"
  end

  create_table "hospital_units", id: :serial, force: :cascade do |t|
    t.integer "hospital_centre_id", null: false
    t.string "name", null: false
    t.string "unit_code", null: false
    t.string "renal_registry_code", null: false
    t.string "unit_type", null: false
    t.boolean "is_hd_site", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "alias"
    t.string "ods_code"
    t.index ["alias"], name: "index_hospital_units_on_alias", unique: true
    t.index ["hospital_centre_id"], name: "index_hospital_units_on_hospital_centre_id"
    t.index ["is_hd_site"], name: "index_hospital_units_on_is_hd_site"
  end

  create_table "hospital_wards", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "hospital_unit_id", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "code"
    t.boolean "active", default: true, null: false
    t.index ["code"], name: "index_hospital_wards_on_code"
    t.index ["hospital_unit_id"], name: "index_hospital_wards_on_hospital_unit_id"
    t.index ["name", "hospital_unit_id"], name: "index_hospital_wards_on_name_and_hospital_unit_id", unique: true, where: "(deleted_at IS NOT NULL)"
  end

  create_table "letter_archives", id: :serial, force: :cascade do |t|
    t.text "content", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "letter_id", null: false
    t.binary "pdf_content", comment: "Binary PDF letter data created by e.g. prawn. Definitive record of what was sent"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.index ["created_by_id"], name: "index_letter_archives_on_created_by_id"
    t.index ["letter_id"], name: "index_letter_archives_on_letter_id"
    t.index ["updated_by_id"], name: "index_letter_archives_on_updated_by_id"
    t.index ["uuid"], name: "index_letter_archives_on_uuid", unique: true
  end

  create_table "letter_batch_items", force: :cascade do |t|
    t.bigint "letter_id", null: false
    t.bigint "batch_id", null: false
    t.integer "status", limit: 2, default: 0, null: false
    t.index ["batch_id", "status"], name: "index_letter_batch_items_on_batch_id_and_status"
    t.index ["letter_id", "batch_id"], name: "index_letter_batch_items_on_letter_id_and_batch_id", unique: true
  end

  create_table "letter_batches", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.jsonb "query_params", default: {}, null: false
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.integer "batch_items_count"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "filepath"
    t.index ["created_by_id"], name: "index_letter_batches_on_created_by_id"
    t.index ["status"], name: "index_letter_batches_on_status"
    t.index ["updated_by_id"], name: "index_letter_batches_on_updated_by_id"
  end

  create_table "letter_contact_descriptions", id: :serial, force: :cascade do |t|
    t.string "system_code", null: false
    t.string "name", null: false
    t.integer "position", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_letter_contact_descriptions_on_name", unique: true
    t.index ["position"], name: "index_letter_contact_descriptions_on_position", unique: true
    t.index ["system_code"], name: "index_letter_contact_descriptions_on_system_code", unique: true
  end

  create_table "letter_contacts", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "person_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "default_cc", default: false, null: false
    t.integer "description_id", null: false
    t.string "other_description"
    t.text "notes"
    t.index ["description_id"], name: "index_letter_contacts_on_description_id"
    t.index ["patient_id"], name: "index_letter_contacts_on_patient_id"
    t.index ["person_id", "patient_id"], name: "index_letter_contacts_on_person_id_and_patient_id", unique: true
  end

  create_table "letter_descriptions", id: :serial, force: :cascade do |t|
    t.string "text", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "position", default: 0, null: false
    t.datetime "deleted_at", precision: nil
    t.string "section_identifiers", default: [], array: true
    t.bigint "snomed_document_type_id"
    t.string "section_identifier"
    t.index ["deleted_at"], name: "index_letter_descriptions_on_deleted_at"
    t.index ["snomed_document_type_id"], name: "index_letter_descriptions_on_snomed_document_type_id"
  end

  create_table "letter_electronic_receipts", force: :cascade do |t|
    t.bigint "letter_id", null: false
    t.bigint "recipient_id", null: false
    t.datetime "read_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_group_id", comment: "If the user chose a user group as a the eCC recipient (rather than a user) then we split up the group and store each member as a row, but assign the letter_group_id for reference"
    t.index ["letter_id"], name: "index_letter_electronic_receipts_on_letter_id"
    t.index ["read_at"], name: "index_letter_electronic_receipts_on_read_at"
    t.index ["recipient_id"], name: "index_letter_electronic_receipts_on_recipient_id"
    t.index ["user_group_id"], name: "index_letter_electronic_receipts_on_user_group_id"
  end

  create_table "letter_letterheads", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "site_code", null: false
    t.string "unit_info", null: false
    t.string "trust_name", null: false
    t.string "trust_caption", null: false
    t.text "site_info"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "include_pathology_in_letter_body", default: true
    t.bigint "hospital_department_id"
    t.index ["hospital_department_id"], name: "index_letter_letterheads_on_hospital_department_id"
  end

  create_table "letter_letters", id: :serial, force: :cascade do |t|
    t.string "event_type"
    t.integer "event_id"
    t.integer "patient_id"
    t.string "type", null: false
    t.date "legacy_issued_on"
    t.string "description"
    t.string "salutation"
    t.text "body"
    t.text "notes"
    t.datetime "signed_at", precision: nil
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "letterhead_id", null: false
    t.integer "author_id", null: false
    t.boolean "clinical"
    t.string "enclosures"
    t.datetime "pathology_timestamp", precision: nil
    t.jsonb "pathology_snapshot", default: {}
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.datetime "submitted_for_approval_at", precision: nil
    t.bigint "submitted_for_approval_by_id"
    t.datetime "approved_at", precision: nil
    t.bigint "approved_by_id"
    t.datetime "completed_at", precision: nil
    t.bigint "completed_by_id"
    t.integer "page_count"
    t.bigint "topic_id"
    t.datetime "deleted_at"
    t.text "deletion_notes"
    t.bigint "deleted_by_id"
    t.enum "gp_send_status", default: "not_applicable", null: false, comment: "Captures the status of out attempt to send a copy of the letter to the GP over MESH using eg GP Connect.", enum_type: "enum_letters_gp_send_status"
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

  create_table "letter_mailshot_items", comment: "A record of the letters sent in a mailshot", force: :cascade do |t|
    t.bigint "mailshot_id", null: false
    t.bigint "letter_id", null: false
    t.index ["letter_id"], name: "index_letter_mailshot_items_on_letter_id"
    t.index ["mailshot_id", "letter_id"], name: "index_letter_mailshot_items_on_mailshot_id_and_letter_id", unique: true, comment: "A sanity check that a letter appears only once in a mailshot"
  end

  create_table "letter_mailshot_mailshots", comment: "A mailshot is an adhoc letter sent to a group of patients", force: :cascade do |t|
    t.string "description", null: false, comment: "Some text to identify the mailshot purpose. Will be written to letter_letters.description column when letter created"
    t.string "sql_view_name", null: false, comment: "The name of the SQL view chosen as the data source"
    t.text "body", null: false, comment: "The body text that will be inserted into each letter"
    t.bigint "letterhead_id", null: false
    t.bigint "author_id", null: false
    t.integer "letters_count", comment: "Counter cache column which Rails will update"
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.enum "status", enum_type: "background_job_status"
    t.text "last_error"
    t.index ["author_id"], name: "index_letter_mailshot_mailshots_on_author_id"
    t.index ["created_by_id"], name: "index_letter_mailshot_mailshots_on_created_by_id"
    t.index ["letterhead_id"], name: "index_letter_mailshot_mailshots_on_letterhead_id"
    t.index ["updated_by_id"], name: "index_letter_mailshot_mailshots_on_updated_by_id"
  end

  create_table "letter_mesh_operations", comment: "Each row represents a MESH API message. There are two types of message - outbound XML FHIR messages containing the letter content and supporting metadata - inbound XML FHIR messages containing a business or infrastructure response. The direction column specifies the direction.", force: :cascade do |t|
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.enum "direction", default: "outbound", null: false, comment: "See enum for options", enum_type: "enum_mesh_message_direction"
    t.enum "action", null: false, enum_type: "enum_mesh_api_action"
    t.bigint "transmission_id", comment: "A reference to the transmission 'transaction'"
    t.bigint "parent_id", comment: "Parent operation - if if we are a download_message operation which needs to be associated with the earlier, parent send_message operation"
    t.text "mesh_message_id", comment: "The MESH message id for this message"
    t.jsonb "request_headers", comment: "Optional, useful for testing"
    t.jsonb "response_headers", comment: "Optional, useful for testing"
    t.text "payload", comment: "The XML message body"
    t.text "response_body", comment: "The response body (eg JSON) if the message is outbound"
    t.text "unhandled_error", comment: "Stores an unexpected exception"
    t.integer "http_response_code", comment: "eg 200, 401"
    t.text "http_response_description", comment: "e.g. OK, Unauthorised"
    t.boolean "http_error", default: false, null: false, comment: "true is eg response status > 299"
    t.text "mesh_response_error_code", comment: "MESH EPL mailbox/NHS number error code eg EPL-153"
    t.text "mesh_response_error_description", comment: "e.g. for EPL-153, 'NHS Number not found'"
    t.text "mesh_response_error_event", comment: "eg SEND"
    t.boolean "mesh_error", default: false, null: false, comment: "true if a MESH error was returned from a API call"
    t.enum "itk3_response_type", comment: "Incoming messages, where they are an async response to a previously sent message will be of type 'infrastructure' or 'business'", enum_type: "enum_mesh_itk3_response_type"
    t.text "itk3_response_code", comment: "from MessageHeader/response/code, e.g. fatal-error"
    t.text "itk3_operation_outcome_type", comment: "from OperationOutcome/issue/code, eg processing, security etc"
    t.text "itk3_operation_outcome_severity", comment: "from MessageHeader/response/severity, e.g. fatal, success"
    t.text "itk3_operation_outcome_code", comment: "from OperationOutcome/issues/details/coding/code - a numeric code e.g. 20001"
    t.text "itk3_operation_outcome_description", comment: "from OperationOutcome/issues/details/coding/display - code description eg 'Handling Specification Error'"
    t.boolean "itk3_error", default: false, null: false, comment: "true if an ITK3 error was returned in a business or infrastructure reply"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "reconciliation_error", default: false, null: false
    t.text "reconciliation_error_description"
    t.index ["action"], name: "index_letter_mesh_operations_on_action"
    t.index ["created_at"], name: "index_letter_mesh_operations_on_created_at"
    t.index ["direction"], name: "index_letter_mesh_operations_on_direction"
    t.index ["itk3_response_type"], name: "index_letter_mesh_operations_on_itk3_response_type"
    t.index ["parent_id"], name: "index_letter_mesh_operations_on_parent_id"
    t.index ["reconciliation_error"], name: "index_letter_mesh_operations_on_reconciliation_error"
    t.index ["transmission_id"], name: "index_letter_mesh_operations_on_transmission_id"
    t.index ["updated_at"], name: "index_letter_mesh_operations_on_updated_at"
  end

  create_table "letter_mesh_transmissions", force: :cascade do |t|
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.bigint "letter_id", null: false, comment: "A reference to the letter being sent"
    t.enum "status", default: "pending", null: false, enum_type: "enum_mesh_transmission_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comment"
    t.uuid "active_job_id"
    t.datetime "cancelled_at"
    t.string "sent_to_practice_ods_code"
    t.index ["active_job_id"], name: "index_letter_mesh_transmissions_on_active_job_id"
    t.index ["created_at"], name: "index_letter_mesh_transmissions_on_created_at"
    t.index ["letter_id"], name: "index_letter_mesh_transmissions_on_letter_id"
    t.index ["sent_to_practice_ods_code"], name: "index_letter_mesh_transmissions_on_sent_to_practice_ods_code"
    t.index ["status"], name: "index_letter_mesh_transmissions_on_status"
    t.index ["updated_at"], name: "index_letter_mesh_transmissions_on_updated_at"
  end

  create_table "letter_qr_encoded_online_reference_links", force: :cascade do |t|
    t.bigint "letter_id", null: false
    t.bigint "online_reference_link_id", null: false
    t.index ["letter_id", "online_reference_link_id"], name: "letter_online_references_uniq_idx", unique: true, comment: "A letter cannot have duplicate online references"
  end

  create_table "letter_recipients", id: :serial, force: :cascade do |t|
    t.string "role", null: false
    t.string "person_role", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "letter_id", null: false
    t.string "addressee_type"
    t.integer "addressee_id"
    t.datetime "emailed_at", precision: nil
    t.datetime "printed_at", precision: nil
    t.index ["addressee_type", "addressee_id"], name: "index_letter_recipients_on_addressee_type_and_addressee_id"
    t.index ["emailed_at"], name: "index_letter_recipients_on_emailed_at"
    t.index ["letter_id"], name: "index_letter_recipients_on_letter_id"
    t.index ["printed_at"], name: "index_letter_recipients_on_printed_at"
    t.index ["role"], name: "index_letter_recipients_on_role"
  end

  create_table "letter_section_snapshots", force: :cascade do |t|
    t.bigint "letter_id", null: false
    t.string "section_identifier"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["letter_id", "section_identifier"], name: "index_unique_on_letter_id_and_section_identifier", unique: true
    t.index ["letter_id"], name: "index_letter_section_snapshots_on_letter_id"
  end

  create_table "letter_signatures", id: :serial, force: :cascade do |t|
    t.datetime "signed_at", precision: nil, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "letter_id", null: false
    t.integer "user_id", null: false
    t.index ["letter_id"], name: "index_letter_signatures_on_letter_id"
    t.index ["user_id"], name: "index_letter_signatures_on_user_id"
  end

  create_table "letter_snomed_document_types", comment: "SNOMED codes and their description that are attached to a letter description (aka letter topic) and used as the FHIR Composition.document_type in GP Connect messages. There can be only one default type, and this is used wherever a letter description has no associated SNOMED document type.", force: :cascade do |t|
    t.text "title", null: false
    t.text "code", null: false
    t.boolean "default_type", default: false, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "index_letter_snomed_document_types_on_code", unique: true
    t.index ["default_type"], name: "index_letter_snomed_document_types_on_default_type", unique: true, where: "(default_type = true)"
    t.index ["title"], name: "index_letter_snomed_document_types_on_title", unique: true
  end

  create_table "low_clearance_dialysis_plans", force: :cascade do |t|
    t.string "code", null: false, comment: "Required only for migration from the code-based enumeration"
    t.string "name", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_low_clearance_dialysis_plans_on_code", unique: true
    t.index ["deleted_at"], name: "index_low_clearance_dialysis_plans_on_deleted_at"
    t.index ["name"], name: "index_low_clearance_dialysis_plans_on_name", unique: true
  end

  create_table "low_clearance_profiles", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.jsonb "document"
    t.bigint "updated_by_id", null: false
    t.bigint "created_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "referrer_id"
    t.bigint "dialysis_plan_id"
    t.index ["created_by_id"], name: "index_low_clearance_profiles_on_created_by_id"
    t.index ["dialysis_plan_id"], name: "index_low_clearance_profiles_on_dialysis_plan_id"
    t.index ["document"], name: "index_low_clearance_profiles_on_document", using: :gin
    t.index ["patient_id"], name: "index_low_clearance_profiles_on_patient_id", unique: true
    t.index ["referrer_id"], name: "index_low_clearance_profiles_on_referrer_id"
    t.index ["updated_by_id"], name: "index_low_clearance_profiles_on_updated_by_id"
  end

  create_table "low_clearance_referrers", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "hidden", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_low_clearance_referrers_on_name", unique: true
  end

  create_table "low_clearance_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_low_clearance_versions_on_item_type_and_item_id"
  end

  create_table "medication_delivery_event_prescriptions", comment: "A cross reference table between delivery_events and prescriptions", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "prescription_id", null: false
    t.index ["event_id", "prescription_id"], name: "idx_medication_delivery_event_prescriptions", unique: true
  end

  create_table "medication_delivery_events", force: :cascade do |t|
    t.bigint "homecare_form_id", null: false
    t.bigint "drug_type_id", null: false
    t.bigint "patient_id", null: false
    t.string "reference_number"
    t.integer "prescription_duration"
    t.boolean "printed", default: false, null: false
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["created_by_id"], name: "index_medication_delivery_events_on_created_by_id"
    t.index ["deleted_at"], name: "index_medication_delivery_events_on_deleted_at"
    t.index ["drug_type_id"], name: "index_medication_delivery_events_on_drug_type_id"
    t.index ["homecare_form_id"], name: "index_medication_delivery_events_on_homecare_form_id"
    t.index ["patient_id"], name: "index_medication_delivery_events_on_patient_id"
    t.index ["updated_by_id"], name: "index_medication_delivery_events_on_updated_by_id"
  end

  create_table "medication_prescription_terminations", id: :serial, force: :cascade do |t|
    t.date "terminated_on", null: false
    t.text "notes"
    t.integer "prescription_id", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "terminated_on_set_by_user", default: false, null: false, comment: "If true, the system will not attempt to set to prescribed_on + 6 months if prescriptions administer_on_hd=true"
    t.index ["created_by_id"], name: "index_medication_prescription_terminations_on_created_by_id"
    t.index ["prescription_id"], name: "index_medication_prescription_terminations_on_prescription_id"
    t.index ["updated_by_id"], name: "index_medication_prescription_terminations_on_updated_by_id"
  end

  create_table "medication_prescription_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_medication_prescription_versions_on_item_type_and_item_id"
  end

  create_table "medication_prescriptions", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "drug_id", null: false
    t.string "treatable_type", null: false
    t.integer "treatable_id", null: false
    t.string "dose_amount", null: false
    t.string "dose_unit"
    t.integer "medication_route_id", null: false
    t.string "route_description"
    t.string "frequency", null: false
    t.text "notes"
    t.date "prescribed_on", null: false
    t.integer "provider", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.boolean "administer_on_hd", default: false, null: false
    t.date "last_delivery_date"
    t.date "next_delivery_date"
    t.bigint "unit_of_measure_id"
    t.bigint "trade_family_id"
    t.bigint "form_id"
    t.integer "legacy_drug_id", comment: "Keep the previous drug id as a reference in case of issues with DMD migration"
    t.integer "legacy_medication_route_id", comment: "Keep the previous route id as a reference in case of issues with DMD migration"
    t.string "frequency_comment"
    t.boolean "stat", comment: "Can be chosen when administer_on_hd is true. Prescriptions marked as 'stat' will be marked as terminated automatically once given."
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

  create_table "medication_routes", id: :serial, force: :cascade do |t|
    t.string "legacy_code"
    t.string "name", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "rr_code"
    t.string "code"
    t.integer "weighting", default: 0, null: false
    t.index ["code"], name: "index_medication_routes_on_code", unique: true
    t.index ["weighting"], name: "index_medication_routes_on_weighting"
  end

  create_table "messaging_messages", force: :cascade do |t|
    t.text "body", null: false
    t.string "subject", null: false
    t.boolean "urgent", default: false, null: false
    t.datetime "sent_at", precision: nil, null: false
    t.bigint "patient_id", null: false
    t.bigint "author_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "replying_to_message_id"
    t.string "type", null: false
    t.boolean "public", default: false, null: false, comment: "If true, the message will be displayed on a patient's clinical summary and their messages page. If false (ie private), the message can only be viewed by the sender (in their sent messages) and by the recipients. New messages once this migration is run will always have public=true. Historical messages will remain private."
    t.index ["author_id"], name: "index_messaging_messages_on_author_id"
    t.index ["patient_id"], name: "index_messaging_messages_on_patient_id"
    t.index ["replying_to_message_id"], name: "index_messaging_messages_on_replying_to_message_id"
    t.index ["subject"], name: "index_messaging_messages_on_subject"
    t.index ["type"], name: "index_messaging_messages_on_type"
  end

  create_table "messaging_receipts", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.bigint "recipient_id", null: false
    t.datetime "read_at", precision: nil
    t.index ["message_id"], name: "index_messaging_receipts_on_message_id"
    t.index ["read_at"], name: "index_messaging_receipts_on_read_at"
    t.index ["recipient_id"], name: "idx_unread_messaging_receipts", where: "(read_at IS NULL)"
    t.index ["recipient_id"], name: "index_messaging_receipts_on_recipient_id"
  end

  create_table "modality_change_types", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.boolean "default", default: false, null: false
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "require_source_hospital_centre", default: false, null: false, comment: "When true, a source hospital must be chosen when adding the modality"
    t.boolean "require_destination_hospital_centre", default: false, null: false, comment: "When true, a destination hospital must be chosen when adding the modality"
    t.index ["created_by_id"], name: "index_modality_change_types_on_created_by_id"
    t.index ["default"], name: "index_modality_change_types_on_default", unique: true, where: "(\"default\" = true)"
    t.index ["deleted_at"], name: "index_modality_change_types_on_deleted_at"
    t.index ["updated_by_id"], name: "index_modality_change_types_on_updated_by_id"
  end

  create_table "modality_descriptions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "type"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "hidden", default: false, null: false
    t.bigint "ukrdc_modality_code_id"
    t.string "code"
    t.boolean "ignore_for_aki_alerts", default: false, null: false, comment: "If true, HL7 AKI scores are ignored when the patient has this current modality"
    t.boolean "ignore_for_kfre", default: false, null: false, comment: "If true, we will attempt to generate a KFRE on receipt of ACR/PCR result when the patient has this current modality"
    t.index ["code"], name: "index_modality_descriptions_on_code", unique: true
    t.index ["deleted_at"], name: "index_modality_descriptions_on_deleted_at"
    t.index ["id", "type"], name: "index_modality_descriptions_on_id_and_type"
    t.index ["ignore_for_kfre"], name: "index_modality_descriptions_on_ignore_for_kfre"
    t.index ["name"], name: "index_modality_descriptions_on_name"
    t.index ["type"], name: "index_modality_descriptions_on_type"
    t.index ["ukrdc_modality_code_id"], name: "index_modality_descriptions_on_ukrdc_modality_code_id"
  end

  create_table "modality_modalities", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "description_id", null: false
    t.integer "reason_id"
    t.string "modal_change_type_deprecated"
    t.text "notes"
    t.date "started_on", null: false
    t.date "ended_on"
    t.string "state", default: "current", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.bigint "change_type_id"
    t.bigint "source_hospital_centre_id", comment: "Source hospital when modality is transferred in."
    t.bigint "destination_hospital_centre_id", comment: "Destination hospital when modality is transferred out."
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

  create_table "modality_reasons", id: :serial, force: :cascade do |t|
    t.string "type"
    t.integer "rr_code"
    t.string "description"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["id", "type"], name: "index_modality_reasons_on_id_and_type"
  end

  create_table "modality_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_modality_versions_on_item_type_and_item_id"
  end

  create_table "monitoring_mirth_channel_groups", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_monitoring_mirth_channel_groups_on_uuid", unique: true
  end

  create_table "monitoring_mirth_channel_stats", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.integer "received", default: 0, null: false
    t.integer "sent", default: 0, null: false
    t.integer "error", default: 0, null: false
    t.integer "queued", default: 0, null: false
    t.integer "filtered", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_monitoring_mirth_channel_stats_on_channel_id"
    t.index ["created_at"], name: "index_monitoring_mirth_channel_stats_on_created_at"
  end

  create_table "monitoring_mirth_channels", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.bigint "channel_group_id"
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_group_id"], name: "index_monitoring_mirth_channels_on_channel_group_id"
    t.index ["uuid"], name: "index_monitoring_mirth_channels_on_uuid", unique: true
  end

  create_table "old_passwords", force: :cascade do |t|
    t.string "encrypted_password", null: false
    t.string "password_archivable_type", null: false
    t.integer "password_archivable_id", null: false
    t.datetime "created_at", precision: nil
    t.index ["password_archivable_type", "password_archivable_id"], name: "index_password_archivable"
  end

  create_table "pathology_calculation_sources", force: :cascade do |t|
    t.bigint "calculated_observation_id", null: false, comment: "Id of the calculated observation e.g. URR derived from pre and post UREA"
    t.bigint "source_observation_id", null: false, comment: "Id of an observation used in the calculation e.g. a UREA observation"
    t.index ["calculated_observation_id", "source_observation_id"], name: "pathology_calculation_sources_idx", unique: true
  end

  create_table "pathology_chart_series", comment: "Defines the series displayed on a predefined chart", force: :cascade do |t|
    t.bigint "chart_id", null: false
    t.bigint "observation_description_id", null: false
    t.enum "axis", default: "y1", null: false, enum_type: "pathology_chart_axis"
    t.string "colour", comment: "Usually null, but can override the colour in the chartable row here"
    t.jsonb "options", default: {}, comment: "Optional hash to override default series settings"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["chart_id"], name: "index_pathology_chart_series_on_chart_id"
    t.index ["observation_description_id"], name: "idx_path_cst_obx"
  end

  create_table "pathology_charts", comment: "Pre-defined charts that can appear in various places", force: :cascade do |t|
    t.string "title", null: false, comment: "Appears on the page next to the chart"
    t.text "description", comment: "For admin use only"
    t.integer "display_group", default: 1, null: false, comment: "For grouping charts"
    t.integer "display_order", default: 1, null: false, comment: "Position of chart in a group"
    t.string "scope", default: "charts", null: false, comment: "E.g. page location for chart"
    t.boolean "enabled", default: true, null: false
    t.bigint "owner_id", comment: "If set, only this user sees this chart"
    t.jsonb "options", default: {}, comment: "Optional hash to override default chart settings"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["enabled"], name: "index_pathology_charts_on_enabled"
    t.index ["owner_id"], name: "index_pathology_charts_on_owner_id"
    t.index ["title"], name: "index_pathology_charts_on_title", unique: true
  end

  create_table "pathology_code_group_memberships", force: :cascade do |t|
    t.bigint "code_group_id", null: false
    t.bigint "observation_description_id", null: false
    t.integer "subgroup", default: 1, null: false
    t.integer "position_within_subgroup", default: 1, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["code_group_id", "observation_description_id"], name: "index_pathology_code_group_memberships_uniq", unique: true
    t.index ["code_group_id"], name: "index_pathology_code_group_memberships_on_code_group_id"
    t.index ["created_by_id"], name: "index_pathology_code_group_memberships_on_created_by_id"
    t.index ["observation_description_id"], name: "pathology_code_group_membership_obx"
    t.index ["updated_by_id"], name: "index_pathology_code_group_memberships_on_updated_by_id"
  end

  create_table "pathology_code_groups", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.string "title"
    t.boolean "context_specific", default: false, null: false
    t.enum "subgroup_colours", array: true, enum_type: "enum_colour_name"
    t.text "subgroup_titles", default: [], array: true
    t.index ["created_by_id"], name: "index_pathology_code_groups_on_created_by_id"
    t.index ["name"], name: "index_pathology_code_groups_on_name", unique: true
    t.index ["updated_by_id"], name: "index_pathology_code_groups_on_updated_by_id"
  end

  create_table "pathology_current_observation_sets", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.jsonb "values", default: {}
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["patient_id"], name: "index_pathology_current_observation_sets_on_patient_id", unique: true
    t.index ["values"], name: "index_pathology_current_observation_sets_on_values", using: :gin
  end

  create_table "pathology_labs", id: :serial, force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "pathology_measurement_units", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.bigint "ukrdc_measurement_unit_id"
    t.index ["name"], name: "index_pathology_measurement_units_on_name", unique: true
    t.index ["ukrdc_measurement_unit_id"], name: "index_pathology_measurement_units_ukrdc_mu"
  end

  create_table "pathology_observation_descriptions", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.integer "measurement_unit_id"
    t.string "loinc_code"
    t.integer "display_group"
    t.integer "display_order"
    t.integer "letter_group"
    t.integer "letter_order"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "rr_type", default: 0, null: false
    t.integer "rr_coding_standard", default: 0, null: false
    t.string "legacy_code"
    t.float "lower_threshold", comment: "Value below which a result can be seen as abnormal"
    t.float "upper_threshold", comment: "Value above which a result can be seen as abnormal"
    t.integer "suggested_measurement_unit_id"
    t.boolean "virtual", default: false, null: false
    t.string "chart_colour"
    t.boolean "chart_logarithmic", default: false, null: false
    t.string "chart_sql_function_name", comment: "A custom json-returning SQL function returning a calculated/derived series. Must accept an integer (patient id) and date (start date to search from)"
    t.bigint "created_by_sender_id", comment: "The feed source that dynmically created this OBX"
    t.integer "observations_count", default: 0
    t.datetime "last_observed_at", precision: nil
    t.enum "colour", enum_type: "enum_colour_name"
    t.index ["code"], name: "index_pathology_observation_descriptions_on_code", unique: true
    t.index ["created_by_sender_id"], name: "pathology_observation_descriptions_sender"
    t.index ["display_group", "display_order"], name: "obx_unique_display_grouping"
    t.index ["letter_group", "letter_order"], name: "obx_unique_letter_grouping"
    t.index ["measurement_unit_id"], name: "index_pathology_observation_descriptions_on_measurement_unit_id"
  end

  create_table "pathology_observation_requests", id: :serial, force: :cascade do |t|
    t.string "requestor_order_number"
    t.string "requestor_name", null: false
    t.datetime "requested_at", precision: nil, null: false
    t.integer "patient_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "description_id", null: false
    t.string "filler_order_number"
    t.integer "feed_message_id", comment: "Reference to the feed_message from which this observation_request was created. There is no constraint on this relationship as feed_messages can be housekept."
    t.index ["description_id"], name: "index_pathology_observation_requests_on_description_id"
    t.index ["feed_message_id"], name: "index_pathology_observation_requests_on_feed_message_id"
    t.index ["patient_id"], name: "index_pathology_observation_requests_on_patient_id"
    t.index ["requested_at"], name: "index_pathology_observation_requests_on_requested_at"
    t.index ["requestor_order_number"], name: "index_pathology_observation_requests_on_requestor_order_number"
  end

  create_table "pathology_observations", id: :serial, force: :cascade do |t|
    t.string "result", null: false
    t.text "comment"
    t.datetime "observed_at", precision: nil, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "description_id", null: false
    t.integer "request_id", null: false
    t.boolean "cancelled"
    t.float "nresult", comment: "The result column cast to a float, for ease of using graphing and claculations.Will be null if the result has a text value that cannot be coreced into a number"
    t.text "legacy_comment"
    t.enum "result_status", comment: "OBX.11 - Observation Result Status\nDefinition:\nC Record coming over is a correction and thus replaces a final result\nD Deletes the OBX record\nF Final results; Can only be changed with a corrected result.\nI Specimen in lab; results pending\nN Not asked\nO Order detail description only (no result)\nP Preliminary results\nR Results entered -- not verified\nS Partial results. Deprecated. Retained only for backward compatibility as of V2.6.\nU Results status change to final without retransmitting results already sent as preliminary\nW Post original as wrong, e.g., transmitted for wrong patient\nX Results cannot be obtained for this observation\n", enum_type: "enum_hl7_observation_result_status_codes"
    t.index ["description_id"], name: "index_pathology_observations_on_description_id"
    t.index ["observed_at"], name: "index_pathology_observations_on_observed_at"
    t.index ["request_id"], name: "index_pathology_observations_on_request_id"
  end

  create_table "pathology_obx_mappings", comment: "In a multi-site installation, one hospital might use a different OBX code (eg HB or HBN) from the one Renalware expects (in this case HGB). This table enables that mapping so that incoming OBX results from different sites are mapped to a single observation_description. This table defines the expected MSH sending facility/app to match against.", force: :cascade do |t|
    t.string "code_alias", null: false, comment: "The hosp-specific code eg 'HB'"
    t.text "comment", comment: "Optional text to help understand mapping issues"
    t.bigint "sender_id", null: false, comment: "A definition of the sending facility (eg RAJ01) and sending app (eg WinPath)"
    t.bigint "observation_description_id", null: false, comment: "The Renalware standarised OBX we are mapping to"
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code_alias", "sender_id"], name: "pathology_obx_mappings_uniqueness", unique: true, comment: "Ensures only one mapping row per sender + code_alias."
    t.index ["code_alias"], name: "index_pathology_obx_mappings_on_code_alias"
    t.index ["created_by_id"], name: "index_pathology_obx_mappings_on_created_by_id"
    t.index ["observation_description_id"], name: "index_pathology_obx_mappings_on_observation_description_id"
    t.index ["sender_id"], name: "index_pathology_obx_mappings_on_sender_id"
    t.index ["updated_by_id"], name: "index_pathology_obx_mappings_on_updated_by_id"
  end

  create_table "pathology_request_descriptions", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.integer "required_observation_description_id"
    t.integer "expiration_days", default: 0, null: false
    t.integer "lab_id", null: false
    t.string "bottle_type"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["code"], name: "index_pathology_request_descriptions_on_code", unique: true
    t.index ["lab_id"], name: "index_pathology_request_descriptions_on_lab_id"
    t.index ["required_observation_description_id"], name: "prd_required_observation_description_id_idx"
  end

  create_table "pathology_request_descriptions_requests_requests", id: :serial, force: :cascade do |t|
    t.integer "request_id", null: false
    t.integer "request_description_id", null: false
    t.index ["request_description_id"], name: "prdr_requests_description_id_idx"
    t.index ["request_id"], name: "prdr_requests_request_id_idx"
  end

  create_table "pathology_requests_drug_categories", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_pathology_requests_drug_categories_on_name"
  end

  create_table "pathology_requests_drugs_drug_categories", id: :serial, force: :cascade do |t|
    t.integer "drug_id", null: false
    t.integer "drug_category_id", null: false
    t.index ["drug_category_id"], name: "prddc_drug_category_id_idx"
    t.index ["drug_id"], name: "index_pathology_requests_drugs_drug_categories_on_drug_id"
  end

  create_table "pathology_requests_global_rule_sets", id: :serial, force: :cascade do |t|
    t.integer "request_description_id", null: false
    t.string "frequency_type", null: false
    t.integer "clinic_id"
    t.index ["clinic_id"], name: "index_pathology_requests_global_rule_sets_on_clinic_id"
    t.index ["request_description_id"], name: "prddc_request_description_id_idx"
  end

  create_table "pathology_requests_global_rules", id: :serial, force: :cascade do |t|
    t.integer "rule_set_id"
    t.string "type"
    t.string "param_id"
    t.string "param_comparison_operator"
    t.string "param_comparison_value"
    t.string "rule_set_type", null: false
    t.index ["id", "type"], name: "index_pathology_requests_global_rules_on_id_and_type"
    t.index ["rule_set_id", "rule_set_type"], name: "prgr_rule_set_id_and_rule_set_type_idx"
    t.index ["rule_set_type"], name: "index_pathology_requests_global_rules_on_rule_set_type"
  end

  create_table "pathology_requests_patient_rules", id: :serial, force: :cascade do |t|
    t.text "test_description"
    t.integer "sample_number_bottles"
    t.string "sample_type"
    t.string "frequency_type"
    t.integer "patient_id"
    t.date "start_date"
    t.date "end_date"
    t.integer "lab_id"
    t.index ["lab_id"], name: "index_pathology_requests_patient_rules_on_lab_id"
    t.index ["patient_id"], name: "index_pathology_requests_patient_rules_on_patient_id"
  end

  create_table "pathology_requests_patient_rules_requests", id: :serial, force: :cascade do |t|
    t.integer "request_id", null: false
    t.integer "patient_rule_id", null: false
    t.index ["patient_rule_id"], name: "prprr_patient_rule_id_idx"
    t.index ["request_id"], name: "index_pathology_requests_patient_rules_requests_on_request_id"
  end

  create_table "pathology_requests_requests", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "clinic_id", null: false
    t.string "telephone", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "template", null: false
    t.boolean "high_risk", null: false
    t.bigint "consultant_id"
    t.index ["clinic_id"], name: "index_pathology_requests_requests_on_clinic_id"
    t.index ["consultant_id"], name: "index_pathology_requests_requests_on_consultant_id"
    t.index ["created_by_id"], name: "index_pathology_requests_requests_on_created_by_id"
    t.index ["patient_id"], name: "index_pathology_requests_requests_on_patient_id"
    t.index ["updated_by_id"], name: "index_pathology_requests_requests_on_updated_by_id"
  end

  create_table "pathology_requests_sample_types", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_pathology_requests_sample_types_on_code", unique: true
    t.index ["name"], name: "index_pathology_requests_sample_types_on_name", unique: true
  end

  create_table "pathology_senders", comment: "The HL7 MSH segment defines a sending application and sending facility e.g. at MSE Basildon 'MSH|^~&|WinPath|RAJ01|RenalWare|MSE|202110261045||ORU^R01|116182217|P|2.3|1||AL' has application 'WinPath' and facility 'RAJ01' (in this case fcaility is the hospital code but that is not guaranteed), and at Kings e.g. 'MSH|^~&|HM|LBE|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||' contains application 'HM' and facility 'LBE'. Defining in this table the expected HL7 sending facilities (and optional applications) allows us to use these definitions when creating OBX mappings - for instance we can delcare that the OBX code 'HB' from sending facility 'RAJ32' should map to the observation description with code 'HGB'.", force: :cascade do |t|
    t.string "sending_facility", null: false, comment: "From MSH segment"
    t.string "sending_application", default: "*", null: false, comment: "From MSH segment"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["sending_facility", "sending_application"], name: "pathology_senders_idx", unique: true
  end

  create_table "pathology_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_pathology_versions_on_item_type_and_item_id"
  end

  create_table "patient_alerts", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.text "notes"
    t.boolean "urgent", default: false, null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "covid_19", default: false, null: false
    t.index ["created_by_id"], name: "index_patient_alerts_on_created_by_id"
    t.index ["deleted_at"], name: "index_patient_alerts_on_deleted_at"
    t.index ["patient_id"], name: "index_patient_alerts_on_patient_id"
    t.index ["updated_by_id"], name: "index_patient_alerts_on_updated_by_id"
  end

  create_table "patient_attachment_types", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.boolean "store_file_externally", default: false, null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_patient_attachment_types_on_deleted_at"
    t.index ["name"], name: "index_patient_attachment_types_on_name", unique: true
  end

  create_table "patient_attachments", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "attachment_type_id", null: false
    t.string "name"
    t.text "description"
    t.string "external_location"
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.date "document_date"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["attachment_type_id"], name: "index_patient_attachments_on_attachment_type_id"
    t.index ["created_by_id"], name: "index_patient_attachments_on_created_by_id"
    t.index ["deleted_at"], name: "index_patient_attachments_on_deleted_at"
    t.index ["document_date"], name: "index_patient_attachments_on_document_date"
    t.index ["name"], name: "index_patient_attachments_on_name"
    t.index ["patient_id"], name: "index_patient_attachments_on_patient_id"
    t.index ["updated_by_id"], name: "index_patient_attachments_on_updated_by_id"
  end

  create_table "patient_bookmarks", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "notes"
    t.boolean "urgent", default: false, null: false
    t.datetime "deleted_at", precision: nil
    t.string "tags"
    t.index "patient_id, user_id, COALESCE(deleted_at, '1970-01-01 00:00:00'::timestamp without time zone)", name: "patient_bookmarks_uniqueness", unique: true
    t.index ["deleted_at"], name: "index_patient_bookmarks_on_deleted_at", where: "(deleted_at IS NULL)"
    t.index ["patient_id"], name: "index_patient_bookmarks_on_patient_id"
    t.index ["urgent"], name: "index_patient_bookmarks_on_urgent"
    t.index ["user_id"], name: "index_patient_bookmarks_on_user_id"
  end

  create_table "patient_ethnicities", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "cfh_name"
    t.string "rr18_code"
    t.index ["cfh_name"], name: "index_patient_ethnicities_on_cfh_name"
  end

  create_table "patient_languages", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.index ["code"], name: "index_patient_languages_on_code", unique: true
  end

  create_table "patient_marital_statuses", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_patient_marital_statuses_on_code", unique: true
  end

  create_table "patient_master_index_deprecated", force: :cascade do |t|
    t.bigint "patient_id"
    t.string "nhs_number"
    t.string "hospital_number"
    t.string "title"
    t.string "family_name"
    t.string "middle_name"
    t.string "given_name"
    t.string "suffix"
    t.string "sex"
    t.date "born_on"
    t.datetime "died_at", precision: nil
    t.string "ethnicity"
    t.string "practice_code"
    t.string "gp_code"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["hospital_number"], name: "index_patient_master_index_deprecated_on_hospital_number"
    t.index ["nhs_number"], name: "index_patient_master_index_deprecated_on_nhs_number"
    t.index ["patient_id"], name: "index_patient_master_index_deprecated_on_patient_id"
  end

  create_table "patient_practice_memberships", id: :serial, force: :cascade do |t|
    t.integer "practice_id", null: false
    t.integer "primary_care_physician_id", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.date "last_change_date"
    t.date "joined_on"
    t.date "left_on"
    t.boolean "active", default: true, null: false
    t.index ["deleted_at"], name: "index_patient_practice_memberships_on_deleted_at"
    t.index ["practice_id", "primary_care_physician_id"], name: "idx_practice_membership", unique: true
    t.index ["practice_id"], name: "index_patient_practice_memberships_on_practice_id"
    t.index ["primary_care_physician_id"], name: "index_patient_practice_memberships_on_primary_care_physician_id"
  end

  create_table "patient_practices", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "email"
    t.string "code", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "telephone"
    t.date "last_change_date"
    t.boolean "active", default: true, null: false
    t.string "mesh_mailbox_id", comment: "e.g. YGM24GPXXX. Populated by a call to MESHAPI endpointlookup.\nUsed when sending letters using TransferOfCare via MESH.\n"
    t.string "mesh_mailbox_description", comment: "Mailbox description eg GP Connect TPP Mailbox One.\nPopulated by a call to MESHAPI endpointlookup.\n"
    t.index ["code"], name: "index_patient_practices_on_code", unique: true
  end

  create_table "patient_primary_care_physicians", id: :serial, force: :cascade do |t|
    t.string "given_name"
    t.string "family_name"
    t.string "code"
    t.string "practitioner_type", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "telephone"
    t.datetime "deleted_at", precision: nil
    t.string "name"
    t.index ["code"], name: "index_patient_primary_care_physicians_on_code", unique: true
    t.index ["deleted_at"], name: "index_patient_primary_care_physicians_on_deleted_at"
    t.index ["name"], name: "index_patient_primary_care_physicians_on_name"
  end

  create_table "patient_religions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", comment: "eg 'E' for 'Jain'"
    t.index ["code"], name: "index_patient_religions_on_code"
  end

  create_table "patient_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "patient_versions_versions_type_id"
  end

  create_table "patient_worries", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "updated_by_id", null: false
    t.integer "created_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "notes"
    t.bigint "worry_category_id"
    t.datetime "deleted_at"
    t.index ["created_by_id"], name: "index_patient_worries_on_created_by_id"
    t.index ["deleted_at"], name: "index_patient_worries_on_deleted_at"
    t.index ["patient_id"], name: "index_patient_worries_on_patient_id", unique: true, where: "(deleted_at IS NULL)"
    t.index ["updated_by_id"], name: "index_patient_worries_on_updated_by_id"
    t.index ["worry_category_id"], name: "index_patient_worries_on_worry_category_id"
  end

  create_table "patient_worry_categories", force: :cascade do |t|
    t.string "name", null: false
    t.integer "worries_count", default: 0, null: false, comment: "Counter cache for the number of worries with this category"
    t.datetime "deleted_at", precision: nil
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["created_by_id"], name: "index_patient_worry_categories_on_created_by_id"
    t.index ["deleted_at"], name: "index_patient_worry_categories_on_deleted_at"
    t.index ["name"], name: "index_patient_worry_categories_on_name", unique: true, where: "(deleted_at IS NULL)", comment: "Disallow duplicate undeleted names"
    t.index ["updated_by_id"], name: "index_patient_worry_categories_on_updated_by_id"
  end

  create_table "patients", id: :serial, force: :cascade do |t|
    t.string "nhs_number"
    t.string "local_patient_id"
    t.string "family_name", null: false
    t.string "given_name", null: false
    t.date "born_on", null: false
    t.boolean "paediatric_patient_indicator", default: false, null: false
    t.string "sex"
    t.integer "ethnicity_id"
    t.string "hospital_centre_code"
    t.string "primary_esrf_centre"
    t.date "died_on"
    t.integer "first_cause_id"
    t.integer "second_cause_id"
    t.text "death_notes"
    t.boolean "cc_on_all_letters", default: true, null: false
    t.date "cc_decision_on"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "practice_id"
    t.integer "primary_care_physician_id"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.string "title"
    t.string "suffix"
    t.string "marital_status"
    t.string "telephone1"
    t.string "telephone2"
    t.string "email"
    t.jsonb "document"
    t.integer "religion_id"
    t.integer "language_id"
    t.string "allergy_status", default: "unrecorded", null: false
    t.datetime "allergy_status_updated_at", precision: nil
    t.string "local_patient_id_2"
    t.string "local_patient_id_3"
    t.string "local_patient_id_4"
    t.string "local_patient_id_5"
    t.string "external_patient_id"
    t.boolean "send_to_renalreg", default: false, null: false
    t.boolean "send_to_rpv", default: false, null: false
    t.date "renalreg_decision_on"
    t.date "rpv_decision_on"
    t.string "renalreg_recorded_by"
    t.string "rpv_recorded_by"
    t.text "ukrdc_external_id", default: -> { "uuid_generate_v4()" }
    t.integer "country_of_birth_id"
    t.integer "legacy_patient_id"
    t.uuid "secure_id", default: -> { "uuid_generate_v4()" }, null: false
    t.datetime "sent_to_ukrdc_at", precision: nil
    t.datetime "checked_for_ukrdc_changes_at", precision: nil
    t.bigint "hospital_centre_id"
    t.bigint "named_consultant_id"
    t.text "next_of_kin"
    t.bigint "named_nurse_id"
    t.bigint "preferred_death_location_id"
    t.text "preferred_death_location_notes"
    t.bigint "actual_death_location_id"
    t.boolean "ukrdc_anonymise", default: false, null: false
    t.date "ukrdc_anonymise_decision_on"
    t.string "ukrdc_anonymise_recorded_by"
    t.string "renal_registry_id"
    t.bigint "marital_status_id"
    t.enum "confidentiality", default: "normal", null: false, comment: "Correspondence will not be sent via GP Connect if set to restricted", enum_type: "enum_confidentiality"
    t.string "ehr_person_identifier", comment: "For use with an EHR eg Millennium. This is a unique identifier for the patient in the EHR system, and maybe be populated during the HL7 ingestion that creates the patient. SHould not be searchable from, or displayed in, the UI."
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

  create_table "pd_adequacy_results", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.date "performed_on", null: false
    t.integer "dial_24_vol_in"
    t.integer "dial_24_vol_out"
    t.boolean "dial_24_missing", default: false, null: false
    t.integer "urine_24_vol"
    t.boolean "urine_24_missing", default: false, null: false
    t.float "serum_urea"
    t.float "serum_creatinine"
    t.float "plasma_glc"
    t.float "serum_ab"
    t.float "dialysate_urea"
    t.float "dialysate_creatinine"
    t.float "dialysate_glu"
    t.float "dialysate_na"
    t.float "dialysate_protein"
    t.float "urine_urea"
    t.float "urine_creatinine"
    t.float "urine_na"
    t.float "urine_k"
    t.float "total_creatinine_clearance"
    t.float "pertitoneal_creatinine_clearance"
    t.float "renal_creatinine_clearance"
    t.float "total_ktv"
    t.float "pertitoneal_ktv"
    t.float "renal_ktv"
    t.float "dietry_protein_intake"
    t.boolean "complete", default: false, null: false
    t.datetime "deleted_at", precision: nil
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.float "height"
    t.float "weight"
    t.index ["created_by_id"], name: "index_pd_adequacy_results_on_created_by_id"
    t.index ["deleted_at"], name: "index_pd_adequacy_results_on_deleted_at"
    t.index ["patient_id"], name: "index_pd_adequacy_results_on_patient_id"
    t.index ["updated_by_id"], name: "index_pd_adequacy_results_on_updated_by_id"
  end

  create_table "pd_assessments", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.jsonb "document"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["created_by_id"], name: "index_pd_assessments_on_created_by_id"
    t.index ["patient_id"], name: "index_pd_assessments_on_patient_id"
    t.index ["updated_by_id"], name: "index_pd_assessments_on_updated_by_id"
  end

  create_table "pd_bag_types", id: :serial, force: :cascade do |t|
    t.string "manufacturer", null: false
    t.string "description", null: false
    t.decimal "glucose_content", precision: 4, scale: 2, null: false
    t.boolean "amino_acid"
    t.boolean "icodextrin"
    t.boolean "low_glucose_degradation"
    t.boolean "low_sodium"
    t.integer "sodium_content"
    t.integer "lactate_content"
    t.integer "bicarbonate_content"
    t.decimal "calcium_content", precision: 3, scale: 2
    t.decimal "magnesium_content", precision: 3, scale: 2
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "glucose_strength", null: false
    t.index ["deleted_at"], name: "index_pd_bag_types_on_deleted_at"
  end

  create_table "pd_exit_site_infections", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.date "diagnosis_date", null: false
    t.text "treatment"
    t.text "outcome"
    t.text "notes"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "recurrent"
    t.boolean "cleared"
    t.boolean "catheter_removed"
    t.string "clinical_presentation", array: true
    t.index ["clinical_presentation"], name: "index_pd_exit_site_infections_on_clinical_presentation", using: :gin
    t.index ["patient_id"], name: "index_pd_exit_site_infections_on_patient_id"
  end

  create_table "pd_fluid_descriptions", id: :serial, force: :cascade do |t|
    t.string "description"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "pd_infection_organisms", id: :serial, force: :cascade do |t|
    t.integer "organism_code_id", null: false
    t.text "sensitivity"
    t.string "infectable_type"
    t.integer "infectable_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "resistance"
    t.index ["infectable_id", "infectable_type"], name: "idx_infection_organisms_type"
    t.index ["organism_code_id", "infectable_id", "infectable_type"], name: "idx_infection_organisms", unique: true
  end

  create_table "pd_organism_codes", id: :serial, force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "pd_peritonitis_episode_type_descriptions", id: :serial, force: :cascade do |t|
    t.string "term"
    t.string "definition"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "pd_peritonitis_episode_types", id: :serial, force: :cascade do |t|
    t.integer "peritonitis_episode_id", null: false
    t.integer "peritonitis_episode_type_description_id", null: false
    t.index ["peritonitis_episode_id", "peritonitis_episode_type_description_id"], name: "pd_peritonitis_episode_types_unique_id", unique: true
    t.index ["peritonitis_episode_type_description_id"], name: "index_pd_peritonitis_episode_types_description_id"
  end

  create_table "pd_peritonitis_episodes", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.date "diagnosis_date", null: false
    t.date "treatment_start_date"
    t.date "treatment_end_date"
    t.integer "episode_type_id"
    t.boolean "catheter_removed"
    t.boolean "line_break"
    t.boolean "exit_site_infection"
    t.boolean "diarrhoea"
    t.boolean "abdominal_pain"
    t.integer "fluid_description_id"
    t.integer "white_cell_total"
    t.integer "white_cell_neutro"
    t.integer "white_cell_lympho"
    t.integer "white_cell_degen"
    t.integer "white_cell_other"
    t.text "notes"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["episode_type_id"], name: "index_pd_peritonitis_episodes_on_episode_type_id"
    t.index ["fluid_description_id"], name: "index_pd_peritonitis_episodes_on_fluid_description_id"
    t.index ["patient_id"], name: "index_pd_peritonitis_episodes_on_patient_id"
  end

  create_table "pd_pet_adequacy_results", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.date "pet_date"
    t.string "pet_type"
    t.decimal "pet_duration", precision: 8, scale: 1
    t.integer "pet_net_uf"
    t.decimal "dialysate_creat_plasma_ratio", precision: 8, scale: 2
    t.decimal "dialysate_glucose_start", precision: 8, scale: 1
    t.decimal "dialysate_glucose_end", precision: 8, scale: 1
    t.date "adequacy_date"
    t.decimal "ktv_total", precision: 8, scale: 2
    t.decimal "ktv_dialysate", precision: 8, scale: 2
    t.decimal "ktv_rrf", precision: 8, scale: 2
    t.integer "crcl_total"
    t.integer "crcl_dialysate"
    t.integer "crcl_rrf"
    t.integer "daily_uf"
    t.integer "daily_urine"
    t.date "date_rff"
    t.integer "creat_value"
    t.decimal "dialysate_effluent_volume", precision: 8, scale: 2
    t.date "date_creat_clearance"
    t.date "date_creat_value"
    t.decimal "urine_urea_conc", precision: 8, scale: 1
    t.integer "urine_creat_conc"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.decimal "dietry_protein_intake", precision: 8, scale: 2
    t.index ["created_by_id"], name: "index_pd_pet_adequacy_results_on_created_by_id"
    t.index ["patient_id"], name: "index_pd_pet_adequacy_results_on_patient_id"
    t.index ["updated_by_id"], name: "index_pd_pet_adequacy_results_on_updated_by_id"
  end

  create_table "pd_pet_dextrose_concentrations", force: :cascade do |t|
    t.string "name", null: false
    t.float "value", null: false
    t.boolean "hidden", default: false, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_pd_pet_dextrose_concentrations_on_name", unique: true
    t.index ["value"], name: "index_pd_pet_dextrose_concentrations_on_value", unique: true
  end

  create_table "pd_pet_results", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.date "performed_on", null: false
    t.enum "test_type", null: false, enum_type: "pd_pet_type"
    t.integer "volume_in"
    t.integer "volume_out"
    t.bigint "dextrose_concentration_id"
    t.integer "infusion_time"
    t.integer "drain_time"
    t.integer "overnight_volume_in"
    t.integer "overnight_volume_out"
    t.bigint "overnight_dextrose_concentration_id"
    t.integer "overnight_dwell_time"
    t.float "sample_0hr_time"
    t.float "sample_0hr_urea"
    t.float "sample_0hr_creatinine"
    t.float "sample_0hr_glc"
    t.float "sample_0hr_sodium"
    t.float "sample_0hr_protein"
    t.float "sample_2hr_time"
    t.float "sample_2hr_urea"
    t.float "sample_2hr_creatinine"
    t.float "sample_2hr_glc"
    t.float "sample_2hr_sodium"
    t.float "sample_2hr_protein"
    t.float "sample_4hr_time"
    t.float "sample_4hr_urea"
    t.float "sample_4hr_creatinine"
    t.float "sample_4hr_glc"
    t.float "sample_4hr_sodium"
    t.float "sample_4hr_protein"
    t.float "sample_6hr_time"
    t.float "sample_6hr_urea"
    t.float "sample_6hr_creatinine"
    t.float "sample_6hr_glc"
    t.float "sample_6hr_sodium"
    t.float "sample_6hr_protein"
    t.float "serum_time"
    t.float "serum_urea"
    t.float "serum_creatinine"
    t.float "plasma_glc"
    t.float "serum_ab"
    t.float "serum_na"
    t.integer "net_uf"
    t.float "d_pcr"
    t.boolean "complete", default: false, null: false
    t.datetime "deleted_at", precision: nil
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["created_by_id"], name: "index_pd_pet_results_on_created_by_id"
    t.index ["deleted_at"], name: "index_pd_pet_results_on_deleted_at"
    t.index ["dextrose_concentration_id"], name: "index_pd_pet_results_on_dextrose_concentration_id"
    t.index ["overnight_dextrose_concentration_id"], name: "index_pd_pet_results_on_overnight_dextrose_concentration_id"
    t.index ["patient_id"], name: "index_pd_pet_results_on_patient_id"
    t.index ["updated_by_id"], name: "index_pd_pet_results_on_updated_by_id"
  end

  create_table "pd_regime_bags", id: :serial, force: :cascade do |t|
    t.integer "regime_id", null: false
    t.integer "bag_type_id", null: false
    t.integer "volume", null: false
    t.integer "per_week"
    t.boolean "monday"
    t.boolean "tuesday"
    t.boolean "wednesday"
    t.boolean "thursday"
    t.boolean "friday"
    t.boolean "saturday"
    t.boolean "sunday"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "role"
    t.boolean "capd_overnight_bag", default: false, null: false
    t.index ["bag_type_id"], name: "index_pd_regime_bags_on_bag_type_id"
    t.index ["regime_id"], name: "index_pd_regime_bags_on_regime_id"
  end

  create_table "pd_regime_terminations", id: :serial, force: :cascade do |t|
    t.date "terminated_on", null: false
    t.integer "regime_id", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["created_by_id"], name: "index_pd_regime_terminations_on_created_by_id"
    t.index ["regime_id"], name: "index_pd_regime_terminations_on_regime_id"
    t.index ["updated_by_id"], name: "index_pd_regime_terminations_on_updated_by_id"
  end

  create_table "pd_regimes", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.string "treatment", null: false
    t.string "type"
    t.integer "glucose_volume_low_strength"
    t.integer "glucose_volume_medium_strength"
    t.integer "glucose_volume_high_strength"
    t.integer "amino_acid_volume"
    t.integer "icodextrin_volume"
    t.boolean "add_hd"
    t.integer "last_fill_volume"
    t.boolean "tidal_indicator"
    t.integer "tidal_percentage"
    t.integer "no_cycles_per_apd"
    t.integer "overnight_volume"
    t.string "apd_machine_pac"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "therapy_time"
    t.integer "fill_volume"
    t.string "delivery_interval"
    t.integer "system_id"
    t.integer "additional_manual_exchange_volume"
    t.boolean "tidal_full_drain_every_three_cycles", default: true
    t.integer "daily_volume"
    t.string "assistance_type"
    t.integer "dwell_time"
    t.string "exchanges_done_by"
    t.string "exchanges_done_by_if_other"
    t.text "exchanges_done_by_notes"
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_pd_regimes_on_created_by_id"
    t.index ["id", "type"], name: "index_pd_regimes_on_id_and_type"
    t.index ["patient_id"], name: "index_pd_regimes_on_patient_id"
    t.index ["system_id"], name: "index_pd_regimes_on_system_id"
    t.index ["updated_by_id"], name: "index_pd_regimes_on_updated_by_id"
  end

  create_table "pd_systems", id: :serial, force: :cascade do |t|
    t.string "pd_type", null: false
    t.string "name", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_pd_systems_on_deleted_at"
    t.index ["pd_type"], name: "index_pd_systems_on_pd_type"
  end

  create_table "pd_training_sessions", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "training_site_id", null: false
    t.jsonb "document"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "training_type_id", null: false
    t.index ["created_by_id"], name: "index_pd_training_sessions_on_created_by_id"
    t.index ["patient_id"], name: "index_pd_training_sessions_on_patient_id"
    t.index ["training_site_id"], name: "index_pd_training_sessions_on_training_site_id"
    t.index ["training_type_id"], name: "index_pd_training_sessions_on_training_type_id"
    t.index ["updated_by_id"], name: "index_pd_training_sessions_on_updated_by_id"
  end

  create_table "pd_training_sites", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "pd_training_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "problem_comorbidities", comment: "A single comobidity problem for a patient. A patient can only have one per description", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "description_id", null: false
    t.enum "recognised", default: "unknown", null: false, enum_type: "tristate_type"
    t.date "recognised_at", comment: "Note often only year is known"
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "malignancy_site_id"
    t.string "diabetes_type"
    t.index ["created_by_id"], name: "index_problem_comorbidities_on_created_by_id"
    t.index ["description_id"], name: "index_problem_comorbidities_on_description_id"
    t.index ["malignancy_site_id"], name: "index_problem_comorbidities_on_malignancy_site_id"
    t.index ["patient_id", "description_id"], name: "index_problem_comorbidities_on_patient_id_and_description_id", unique: true, comment: "Only 1 unique description allowed per patient"
    t.index ["patient_id"], name: "index_problem_comorbidities_on_patient_id"
    t.index ["updated_by_id"], name: "index_problem_comorbidities_on_updated_by_id"
  end

  create_table "problem_comorbidity_descriptions", comment: "The supported list of cormbidities that can be recorded for a patient", force: :cascade do |t|
    t.text "name", null: false
    t.integer "position", default: 0, null: false, comment: "Display order"
    t.string "snomed_code", comment: "Used in UKRDC exports"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "has_malignancy_site", default: false, null: false
    t.boolean "has_diabetes_type", default: false, null: false
    t.index ["deleted_at"], name: "index_problem_comorbidity_descriptions_on_deleted_at"
    t.index ["name"], name: "index_problem_comorbidity_descriptions_on_name", unique: true, where: "(deleted_at IS NULL)"
    t.index ["position"], name: "index_problem_comorbidity_descriptions_on_position"
  end

  create_table "problem_malignancy_sites", force: :cascade do |t|
    t.text "description", null: false
    t.string "rr_19_code", comment: "Renal Registry dataset v5 RR19 code"
    t.index ["description"], name: "index_problem_malignancy_sites_on_description", unique: true
  end

  create_table "problem_notes", id: :serial, force: :cascade do |t|
    t.integer "problem_id"
    t.text "description", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.index ["created_by_id"], name: "index_problem_notes_on_created_by_id"
    t.index ["deleted_at"], name: "index_problem_notes_on_deleted_at"
    t.index ["problem_id"], name: "index_problem_notes_on_problem_id"
    t.index ["updated_by_id"], name: "index_problem_notes_on_updated_by_id"
  end

  create_table "problem_problems", id: :serial, force: :cascade do |t|
    t.integer "position", default: 0, null: false
    t.integer "patient_id", null: false
    t.string "description", null: false
    t.date "date"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id"
    t.string "snomed_id"
    t.enum "date_display_style", enum_type: "problem_date_display_style_enum"
    t.index ["created_by_id"], name: "index_problem_problems_on_created_by_id"
    t.index ["deleted_at"], name: "index_problem_problems_on_deleted_at"
    t.index ["patient_id"], name: "index_problem_problems_on_patient_id"
    t.index ["position"], name: "index_problem_problems_on_position"
    t.index ["updated_by_id"], name: "index_problem_problems_on_updated_by_id"
  end

  create_table "problem_radar_cohorts", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_problem_radar_cohorts_on_name", unique: true
  end

  create_table "problem_radar_diagnoses", force: :cascade do |t|
    t.bigint "cohort_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description_regex", comment: "Optional regex eg 'AH (amyloidosis|amylidos.*)' against which patient problem descriptions will be matched (in addition to matching purely against the diagnosis.name) when trying to ascertain if the patient has this rare renal diagnosis. Supporting regexes allows for problem variants and for spelling mistakes in non-SNOMED coded problems."
    t.text "snomed_regex", comment: "Optional regex eg '(123123|345345|123123123123.*)' against which patient problem snomed_codes will be matched (in addition to matching purely against the diagnosis.name) when trying to ascertain if the patient has this rare renal disease. Supporting regexes allows us to match a problem that has a SNOMED code that is the exact match, parent or child of the target RaDaR diagnosis SNOMED code."
    t.index ["cohort_id", "name"], name: "index_problem_radar_diagnoses_on_cohort_id_and_name", unique: true
    t.index ["cohort_id"], name: "index_problem_radar_diagnoses_on_cohort_id"
  end

  create_table "problem_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_problem_versions_on_item_type_and_item_id"
  end

  create_table "remote_monitoring_frequencies", force: :cascade do |t|
    t.interval "period", null: false
    t.datetime "deleted_at"
    t.integer "position", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_remote_monitoring_frequencies_on_deleted_at"
    t.index ["period"], name: "index_remote_monitoring_frequencies_on_period", unique: true, where: "(deleted_at IS NULL)"
    t.index ["position"], name: "index_remote_monitoring_frequencies_on_position"
  end

  create_table "remote_monitoring_referral_reasons", force: :cascade do |t|
    t.text "description", null: false
    t.datetime "deleted_at"
    t.integer "position", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_remote_monitoring_referral_reasons_on_deleted_at"
    t.index ["description"], name: "index_remote_monitoring_referral_reasons_on_description", unique: true, where: "(deleted_at IS NULL)"
    t.index ["position"], name: "index_remote_monitoring_referral_reasons_on_position"
  end

  create_table "renal_aki_alert_actions", force: :cascade do |t|
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_renal_aki_alert_actions_on_name"
  end

  create_table "renal_aki_alerts", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "action_id"
    t.bigint "hospital_ward_id"
    t.boolean "hotlist", default: false, null: false
    t.string "action"
    t.text "notes"
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "max_cre"
    t.date "cre_date"
    t.integer "max_aki"
    t.date "aki_date"
    t.bigint "hospital_centre_id"
    t.index ["action"], name: "index_renal_aki_alerts_on_action"
    t.index ["action_id"], name: "index_renal_aki_alerts_on_action_id"
    t.index ["created_by_id"], name: "index_renal_aki_alerts_on_created_by_id"
    t.index ["hospital_centre_id"], name: "index_renal_aki_alerts_on_hospital_centre_id"
    t.index ["hospital_ward_id"], name: "index_renal_aki_alerts_on_hospital_ward_id"
    t.index ["hotlist"], name: "index_renal_aki_alerts_on_hotlist"
    t.index ["patient_id"], name: "index_renal_aki_alerts_on_patient_id"
    t.index ["updated_by_id"], name: "index_renal_aki_alerts_on_updated_by_id"
  end

  create_table "renal_prd_descriptions", id: :serial, force: :cascade do |t|
    t.string "code"
    t.string "term"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_renal_prd_descriptions_on_code", unique: true
  end

  create_table "renal_profiles", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.date "esrf_on"
    t.date "first_seen_on"
    t.float "weight_at_esrf"
    t.string "modality_at_esrf"
    t.integer "prd_description_id"
    t.date "comorbidities_updated_on"
    t.jsonb "document"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["document"], name: "index_renal_profiles_on_document", using: :gin
    t.index ["patient_id"], name: "index_renal_profiles_on_patient_id", unique: true
    t.index ["prd_description_id"], name: "index_renal_profiles_on_prd_description_id"
  end

  create_table "renal_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_renal_versions_on_item_type_and_item_id"
  end

  create_table "reporting_audits", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "view_name", null: false
    t.datetime "refreshed_at", precision: nil
    t.string "refresh_schedule", default: "1 0 * * 1-6"
    t.text "display_configuration", default: "{}", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "description"
    t.boolean "materialized", default: true, null: false
    t.boolean "enabled", default: true, null: false
  end

  create_table "research_investigatorships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "study_id", null: false
    t.bigint "updated_by_id", null: false
    t.bigint "created_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "type"
    t.jsonb "document"
    t.date "started_on"
    t.date "left_on"
    t.boolean "manager", default: false, null: false
    t.index ["created_by_id"], name: "index_research_investigatorships_on_created_by_id"
    t.index ["deleted_at"], name: "index_research_investigatorships_on_deleted_at"
    t.index ["document"], name: "index_research_investigatorships_on_document", using: :gin
    t.index ["study_id"], name: "index_research_investigatorships_on_study_id"
    t.index ["updated_by_id"], name: "index_research_investigatorships_on_updated_by_id"
    t.index ["user_id"], name: "index_research_investigatorships_on_user_id"
  end

  create_table "research_participations", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "study_id", null: false
    t.date "joined_on", null: false
    t.date "left_on"
    t.datetime "deleted_at", precision: nil
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "external_id"
    t.string "type"
    t.jsonb "document"
    t.integer "external_id_deprecated", comment: "Backup of external_id taken before changing its type from int to text"
    t.string "external_reference"
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

  create_table "research_studies", force: :cascade do |t|
    t.string "code", null: false
    t.string "description", null: false
    t.string "leader"
    t.text "notes"
    t.date "started_on"
    t.date "terminated_on"
    t.datetime "deleted_at", precision: nil
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "application_url"
    t.string "namespace"
    t.string "type"
    t.jsonb "document"
    t.boolean "private", default: false, null: false
    t.index ["code"], name: "index_research_studies_on_code", unique: true, where: "(deleted_at IS NULL)"
    t.index ["created_by_id"], name: "index_research_studies_on_created_by_id"
    t.index ["deleted_at"], name: "index_research_studies_on_deleted_at"
    t.index ["description"], name: "index_research_studies_on_description"
    t.index ["document"], name: "index_research_studies_on_document", using: :gin
    t.index ["leader"], name: "index_research_studies_on_leader"
    t.index ["private"], name: "index_research_studies_on_private"
    t.index ["updated_by_id"], name: "index_research_studies_on_updated_by_id"
  end

  create_table "research_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.integer "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_research_versions_on_item_type_and_item_id"
    t.index ["whodunnit"], name: "index_research_versions_on_whodunnit"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "hidden", default: false, null: false
    t.boolean "enforce", default: false, null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "roles_users", force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
    t.index ["role_id"], name: "index_roles_users_on_role_id"
    t.index ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id", unique: true
  end

  create_table "snippets_snippets", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.datetime "last_used_on", precision: nil
    t.integer "times_used", default: 0, null: false
    t.integer "author_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["author_id"], name: "index_snippets_snippets_on_author_id"
    t.index ["title"], name: "index_snippets_snippets_on_title"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.binary "key", null: false
    t.binary "value", null: false
    t.datetime "created_at", null: false
    t.bigint "key_hash", null: false
    t.integer "byte_size", null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "survey_questions", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.string "code", null: false
    t.string "label"
    t.integer "position", default: 0, null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "validation_regex"
    t.string "label_abbrv", comment: "If populated, used instead of label when displaying the table, to save space"
    t.index ["code", "survey_id"], name: "index_survey_questions_on_code_and_survey_id", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_survey_questions_on_deleted_at"
    t.index ["position"], name: "index_survey_questions_on_position"
    t.index ["survey_id", "code"], name: "index_survey_questions_on_survey_id_and_code", unique: true, where: "(deleted_at IS NULL)"
    t.index ["survey_id"], name: "index_survey_questions_on_survey_id"
  end

  create_table "survey_responses", force: :cascade do |t|
    t.date "answered_on", null: false
    t.bigint "patient_id", null: false
    t.bigint "question_id", null: false
    t.string "value"
    t.string "reference"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "patient_question_text"
    t.index ["answered_on", "patient_id", "question_id"], name: "survey_responses_compound_index"
    t.index ["patient_id"], name: "index_survey_responses_on_patient_id"
    t.index ["question_id"], name: "index_survey_responses_on_question_id"
  end

  create_table "survey_surveys", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "description"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_survey_surveys_on_code", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_survey_surveys_on_deleted_at"
    t.index ["name"], name: "index_survey_surveys_on_name", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "system_api_logs", force: :cascade do |t|
    t.string "identifier", null: false
    t.string "status", null: false
    t.integer "records_added", default: 0, null: false
    t.integer "records_updated", default: 0, null: false
    t.boolean "dry_run", default: false, null: false
    t.text "error"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "pages", default: 0, null: false
    t.text "values", default: [], array: true
    t.decimal "elapsed_ms", comment: "Used for benchmarking"
    t.index ["identifier"], name: "index_system_api_logs_on_identifier"
    t.index ["status"], name: "index_system_api_logs_on_status"
  end

  create_table "system_components", comment: "Available ruby display widgets for use e.g. in dashboards", force: :cascade do |t|
    t.string "class_name", null: false, comment: "Component class eg Renalware::.."
    t.string "name", null: false, comment: "Friendly component name e.g. 'Letters in Progress'"
    t.boolean "dashboard", default: true, null: false, comment: "If true, can use on dashboards"
    t.string "roles", comment: "Who can use or be assigned this component"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["class_name"], name: "index_system_components_on_class_name"
    t.index ["name"], name: "index_system_components_on_name", unique: true
    t.index ["roles"], name: "index_system_components_on_roles"
  end

  create_table "system_countries", force: :cascade do |t|
    t.string "name", null: false
    t.string "alpha2", null: false
    t.string "alpha3", null: false
    t.integer "position"
    t.index ["alpha2"], name: "index_system_countries_on_alpha2"
    t.index ["alpha3"], name: "index_system_countries_on_alpha3"
    t.index ["name"], name: "index_system_countries_on_name", unique: true
    t.index ["position"], name: "index_system_countries_on_position"
  end

  create_table "system_dashboard_components", comment: "Defines dashboard content", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "component_id"
    t.integer "position", default: 1, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["component_id"], name: "index_system_dashboard_components_on_component_id"
    t.index ["dashboard_id", "component_id"], name: "idx_dashboard_component_useage_unique", unique: true, comment: "Allow only one instance of a component on any dashboard"
    t.index ["dashboard_id", "position"], name: "idx_dashboard_component_position", unique: true, comment: "Position must be unique within a dashboard"
  end

  create_table "system_dashboards", force: :cascade do |t|
    t.string "name", comment: "A named dashboard e.g. default, hd_nurse"
    t.text "description"
    t.bigint "user_id", comment: "If present, this dashboard belongs to a user e.g. they have customised a named dashboard to make it their own"
    t.bigint "cloned_from_dashboard_id", comment: "Is the user customised their dashboard we store the original here"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["cloned_from_dashboard_id"], name: "index_system_dashboards_on_cloned_from_dashboard_id"
    t.index ["name"], name: "index_system_dashboards_on_name", unique: true
    t.index ["user_id"], name: "index_system_dashboards_on_user_id", unique: true
  end

  create_table "system_downloads", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "deleted_at", precision: nil
    t.bigint "updated_by_id", null: false
    t.bigint "created_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "view_count", default: 0, null: false
    t.index ["created_by_id"], name: "index_system_downloads_on_created_by_id"
    t.index ["deleted_at"], name: "index_system_downloads_on_deleted_at"
    t.index ["name"], name: "index_system_downloads_on_name", unique: true
    t.index ["updated_by_id"], name: "index_system_downloads_on_updated_by_id"
  end

  create_table "system_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.datetime "time", precision: nil
    t.string "name"
    t.jsonb "properties"
    t.index ["name", "time"], name: "index_system_events_on_name_and_time"
    t.index ["properties"], name: "index_system_events_on_properties_jsonb_path_ops", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_system_events_on_user_id"
    t.index ["visit_id"], name: "index_system_events_on_visit_id"
  end

  create_table "system_logs", force: :cascade do |t|
    t.enum "severity", default: "info", null: false, enum_type: "system_log_severity"
    t.enum "group", default: "users", null: false, enum_type: "system_log_group"
    t.bigint "owner_id", comment: "Optional - if targetted at a specific user"
    t.text "message"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["group"], name: "index_system_logs_on_group"
    t.index ["owner_id"], name: "index_system_logs_on_owner_id"
    t.index ["severity"], name: "index_system_logs_on_severity"
  end

  create_table "system_messages", force: :cascade do |t|
    t.string "title"
    t.text "body", null: false
    t.integer "message_type", default: 0, null: false
    t.string "severity"
    t.datetime "display_from", precision: nil, null: false
    t.datetime "display_until", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "system_nag_definitions", comment: "Registers a 'missing data nag' sql function and the text to display if the function evaluates to true", force: :cascade do |t|
    t.enum "scope", null: false, enum_type: "system_nag_definition_scope"
    t.integer "importance", default: 1, null: false
    t.text "description", null: false
    t.text "hint", comment: "May be displayed when hovering over the nag"
    t.text "sql_function_name", null: false
    t.text "title", comment: "If present, text eg ('CFS:') displayed to the left of the content in a nag"
    t.boolean "enabled", default: true, null: false
    t.text "relative_link"
    t.integer "always_expire_cache_after_minutes", default: 60, null: false, comment: "Number of minutes to cache this nag before the cache is automatically invalidated. The cache may be invalidated earlier if the nag_definition.updated_at or patient.updated_at timestamps change."
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["description"], name: "index_system_nag_definitions_on_description", unique: true
    t.index ["enabled"], name: "index_system_nag_definitions_on_enabled"
    t.index ["scope", "importance"], name: "index_system_nag_definitions_on_scope_and_importance"
  end

  create_table "system_online_reference_links", force: :cascade do |t|
    t.string "title", null: false, comment: "The name of this resource, for display in the UI only"
    t.string "url", null: false, comment: "A URL linking to a helpful online reference for patients. May be rendered as a QR code."
    t.text "description", comment: "Text displayed alongside the link or QR code"
    t.integer "usage_count", default: 0
    t.datetime "last_used_at", precision: nil
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "include_in_letters_from", comment: "If set, the QR code will be included in any new letters created on orafter this date - ie its the start of the window of auto-inclusion"
    t.date "include_in_letters_until", comment: "If 'include_in_letters_from' is set, letters created after this date will no longer have the QR code automatically inserted - ie its the end of the window of auto-inclusion"
    t.index ["created_by_id"], name: "index_system_online_reference_links_on_created_by_id"
    t.index ["title"], name: "index_system_online_reference_links_on_title", unique: true
    t.index ["updated_by_id"], name: "index_system_online_reference_links_on_updated_by_id"
    t.index ["url"], name: "index_system_online_reference_links_on_url", unique: true
  end

  create_table "system_templates", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "title"
    t.string "description", null: false
    t.text "body", null: false
    t.index ["name"], name: "index_system_templates_on_name"
  end

  create_table "system_user_feedback", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.string "category", null: false
    t.text "comment", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "admin_notes"
    t.boolean "acknowledged"
    t.index ["author_id"], name: "index_system_user_feedback_on_author_id"
    t.index ["category"], name: "index_system_user_feedback_on_category"
  end

  create_table "system_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_system_versions_on_item_type_and_item_id"
  end

  create_table "system_view_calls", force: :cascade do |t|
    t.bigint "view_metadata_id", null: false
    t.bigint "user_id", null: false
    t.datetime "called_at", null: false
    t.index ["user_id"], name: "index_system_view_calls_on_user_id"
    t.index ["view_metadata_id", "user_id", "called_at"], name: "idx_system_view_calls_all"
    t.index ["view_metadata_id"], name: "index_system_view_calls_on_view_metadata_id"
  end

  create_table "system_view_metadata", comment: "Holds descriptive and layout data to help us construct data-driven parts of the Renalware UI e.g. MDMs", force: :cascade do |t|
    t.text "schema_name", null: false
    t.text "view_name", null: false
    t.text "slug", comment: "May be used in urls - must be lower case with no spaces"
    t.text "scope", comment: "e.g. PD"
    t.text "parent_name"
    t.bigint "parent_id", comment: "Self-join in case a view should have children"
    t.text "title", comment: "A label that may appear in the UI"
    t.jsonb "columns", default: [], null: false, comment: "Array of column_names. If empty, all cols displayed. Array order is the display order"
    t.jsonb "filters", default: [], null: false, comment: "Array of filter definition for generating filters. Must be the name of a column in the SQL view. "
    t.integer "position", default: 0, null: false
    t.text "description", comment: "A description of the SQL view's function"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.enum "display_type", default: "tabular", null: false, enum_type: "system_view_display_type"
    t.enum "category", default: "mdm", null: false, enum_type: "system_view_category"
    t.string "sub_category"
    t.boolean "materialized", default: false, null: false
    t.datetime "materialized_view_refreshed_at", precision: nil
    t.text "refresh_schedule", comment: "Cron or fugit schedule string for refreshing the view if it is materialized eg 'every day at 6am' or '0 * * * *' (every hour) or @hourly (turns into '0 * * * *') or '0 0 L * *' (last day of month at 00:00)"
    t.boolean "refresh_concurrently", default: false, null: false, comment: "where refresh_schedule is set, if refresh_concurrently is true then provided the materialised view has a unique index, the data will be reloaded without locking the table for selects - which is clearly advantageous"
    t.enum "patient_landing_page", comment: "If present, any patient links generated the report associated with this row will take the user indicated landing area eg patients/123/hd, where these landing areas are routes defined by each RW module and often redirect, e.g. to a dashboard or profile page", enum_type: "enum_patient_landing_page"
    t.integer "calls_count", default: 0
    t.datetime "last_called_at"
    t.jsonb "chart", default: {}, null: false
    t.jsonb "chart_raw", default: {}, null: false
    t.index ["parent_id"], name: "index_system_view_metadata_on_parent_id"
  end

  create_table "system_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.string "search_keyword"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.datetime "started_at", precision: nil
    t.index ["user_id"], name: "index_system_visits_on_user_id"
    t.index ["visit_token"], name: "index_system_visits_on_visit_token", unique: true
  end

  create_table "transplant_donations", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.integer "recipient_id"
    t.string "state", null: false
    t.string "relationship_with_recipient", null: false
    t.string "relationship_with_recipient_other"
    t.string "blood_group_compatibility"
    t.string "mismatch_grade"
    t.string "paired_pooled_donation"
    t.date "volunteered_on"
    t.date "first_seen_on"
    t.date "workup_completed_on"
    t.date "donated_on"
    t.text "notes"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["patient_id"], name: "index_transplant_donations_on_patient_id"
    t.index ["recipient_id"], name: "index_transplant_donations_on_recipient_id"
  end

  create_table "transplant_donor_followups", id: :serial, force: :cascade do |t|
    t.integer "operation_id", null: false
    t.text "notes"
    t.boolean "followed_up"
    t.string "ukt_center_code"
    t.date "last_seen_on"
    t.boolean "lost_to_followup"
    t.boolean "transferred_for_followup"
    t.date "dead_on"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["operation_id"], name: "index_transplant_donor_followups_on_operation_id"
  end

  create_table "transplant_donor_operations", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.date "performed_on", null: false
    t.string "anaesthetist"
    t.string "donor_splenectomy_peri_or_post_operatively"
    t.string "kidney_side"
    t.string "nephrectomy_type"
    t.string "nephrectomy_type_other"
    t.string "operating_surgeon"
    t.text "notes"
    t.jsonb "document"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["document"], name: "index_transplant_donor_operations_on_document", using: :gin
    t.index ["patient_id"], name: "index_transplant_donor_operations_on_patient_id"
  end

  create_table "transplant_donor_stage_positions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "position", default: 1, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_transplant_donor_stage_positions_on_name", unique: true
    t.index ["position"], name: "index_transplant_donor_stage_positions_on_position"
  end

  create_table "transplant_donor_stage_statuses", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "position", default: 1, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_transplant_donor_stage_statuses_on_name", unique: true
    t.index ["position"], name: "index_transplant_donor_stage_statuses_on_position"
  end

  create_table "transplant_donor_stages", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "stage_position_id", null: false
    t.integer "stage_status_id", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "started_on", precision: nil, null: false
    t.datetime "terminated_on", precision: nil
    t.text "notes"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["created_by_id"], name: "index_transplant_donor_stages_on_created_by_id"
    t.index ["patient_id"], name: "index_transplant_donor_stages_on_patient_id"
    t.index ["stage_position_id"], name: "tx_donor_stage_position_idx"
    t.index ["stage_status_id"], name: "tx_donor_stage_status_idx"
    t.index ["updated_by_id"], name: "index_transplant_donor_stages_on_updated_by_id"
  end

  create_table "transplant_donor_workups", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.jsonb "document"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["document"], name: "index_transplant_donor_workups_on_document", using: :gin
    t.index ["patient_id"], name: "index_transplant_donor_workups_on_patient_id"
  end

  create_table "transplant_failure_cause_description_groups", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "transplant_failure_cause_descriptions", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.string "code", null: false
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_transplant_failure_cause_descriptions_on_code", unique: true
    t.index ["group_id"], name: "index_transplant_failure_cause_descriptions_on_group_id"
  end

  create_table "transplant_induction_agents", force: :cascade do |t|
    t.text "name", null: false
    t.integer "position", default: 0, null: false
    t.text "drug_name"
    t.text "snomed_code"
    t.text "atc_code"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index "lower(name)", name: "index_transplant_induction_agents_on_name", unique: true
  end

  create_table "transplant_investigation_types", force: :cascade do |t|
    t.string "code", null: false
    t.string "description", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_transplant_investigation_types_on_code", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_transplant_investigation_types_on_deleted_at"
  end

  create_table "transplant_recipient_followups", id: :serial, force: :cascade do |t|
    t.integer "operation_id", null: false
    t.text "notes"
    t.date "stent_removed_on"
    t.boolean "transplant_failed"
    t.date "transplant_failed_on"
    t.integer "transplant_failure_cause_description_id"
    t.string "transplant_failure_cause_other"
    t.text "transplant_failure_notes"
    t.jsonb "document"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.date "graft_nephrectomy_on"
    t.string "graft_function_onset"
    t.date "last_post_transplant_dialysis_on"
    t.date "return_to_regular_dialysis_on"
    t.index ["document"], name: "index_transplant_recipient_followups_on_document", using: :gin
    t.index ["operation_id"], name: "index_transplant_recipient_followups_on_operation_id"
    t.index ["transplant_failure_cause_description_id"], name: "tx_recip_fol_failure_cause_description_id_idx"
  end

  create_table "transplant_recipient_operations", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.date "performed_on", null: false
    t.time "theatre_case_start_time"
    t.datetime "donor_kidney_removed_from_ice_at", precision: nil
    t.string "operation_type", null: false
    t.integer "hospital_centre_id", null: false
    t.datetime "kidney_perfused_with_blood_at", precision: nil
    t.integer "cold_ischaemic_time"
    t.integer "warm_ischaemic_time"
    t.text "notes"
    t.jsonb "document"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "induction_agent_id"
    t.string "immunological_risk"
    t.index ["document"], name: "index_transplant_recipient_operations_on_document", using: :gin
    t.index ["hospital_centre_id"], name: "index_transplant_recipient_operations_on_hospital_centre_id"
    t.index ["induction_agent_id"], name: "index_transplant_recipient_operations_on_induction_agent_id"
    t.index ["patient_id"], name: "index_transplant_recipient_operations_on_patient_id"
  end

  create_table "transplant_recipient_workups", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.jsonb "document"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_transplant_recipient_workups_on_created_by_id"
    t.index ["document"], name: "index_transplant_recipient_workups_on_document", using: :gin
    t.index ["patient_id"], name: "index_transplant_recipient_workups_on_patient_id"
    t.index ["updated_by_id"], name: "index_transplant_recipient_workups_on_updated_by_id"
  end

  create_table "transplant_registration_status_descriptions", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.integer "position", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "rr_code"
    t.text "rr_comment"
    t.index ["code"], name: "index_transplant_registration_status_descriptions_on_code"
    t.index ["position"], name: "index_transplant_registration_status_descriptions_on_position"
  end

  create_table "transplant_registration_statuses", id: :serial, force: :cascade do |t|
    t.integer "registration_id"
    t.integer "description_id"
    t.date "started_on", null: false
    t.date "terminated_on"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "notes"
    t.index ["created_by_id"], name: "index_transplant_registration_statuses_on_created_by_id"
    t.index ["description_id"], name: "index_transplant_registration_statuses_on_description_id"
    t.index ["registration_id"], name: "index_transplant_registration_statuses_on_registration_id"
    t.index ["started_on"], name: "index_transplant_registration_statuses_on_started_on"
    t.index ["terminated_on"], name: "index_transplant_registration_statuses_on_terminated_on"
    t.index ["updated_by_id"], name: "index_transplant_registration_statuses_on_updated_by_id"
  end

  create_table "transplant_registrations", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.date "referred_on"
    t.date "assessed_on"
    t.date "entered_on"
    t.text "contact"
    t.text "notes"
    t.jsonb "document"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["document"], name: "index_transplant_registrations_on_document", using: :gin
    t.index ["patient_id"], name: "index_transplant_registrations_on_patient_id", unique: true
  end

  create_table "transplant_rejection_episodes", force: :cascade do |t|
    t.date "recorded_on", null: false
    t.text "notes"
    t.bigint "followup_id", null: false
    t.bigint "updated_by_id", null: false
    t.bigint "created_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "treatment_id"
    t.index ["created_by_id"], name: "index_transplant_rejection_episodes_on_created_by_id"
    t.index ["followup_id"], name: "index_transplant_rejection_episodes_on_followup_id"
    t.index ["treatment_id"], name: "index_transplant_rejection_episodes_on_treatment_id"
    t.index ["updated_by_id"], name: "index_transplant_rejection_episodes_on_updated_by_id"
  end

  create_table "transplant_rejection_treatments", force: :cascade do |t|
    t.text "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_transplant_rejection_treatments_on_name"
    t.index ["position"], name: "index_transplant_rejection_treatments_on_position"
  end

  create_table "transplant_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at", precision: nil
    t.index ["item_id"], name: "index_transplant_versions_on_item_id"
    t.index ["item_type", "item_id"], name: "tx_versions_type_id"
  end

  create_table "ukrdc_batches", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "ukrdc_measurement_units", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_ukrdc_measurement_units_on_name"
  end

  create_table "ukrdc_modality_codes", force: :cascade do |t|
    t.string "qbl_code"
    t.string "txt_code"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["qbl_code"], name: "index_ukrdc_modality_codes_on_qbl_code"
    t.index ["txt_code"], name: "index_ukrdc_modality_codes_on_txt_code"
  end

  create_table "ukrdc_transmission_logs", force: :cascade do |t|
    t.bigint "patient_id"
    t.datetime "sent_at", precision: nil
    t.integer "status", null: false
    t.uuid "request_uuid"
    t.text "payload_hash"
    t.xml "payload"
    t.text "error", default: [], array: true
    t.string "file_path"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "direction", default: 0, null: false
    t.bigint "batch_id"
    t.index ["batch_id"], name: "index_ukrdc_transmission_logs_on_batch_id"
    t.index ["patient_id"], name: "index_ukrdc_transmission_logs_on_patient_id"
    t.index ["request_uuid"], name: "index_ukrdc_transmission_logs_on_request_uuid"
  end

  create_table "ukrdc_treatments", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "clinician_id"
    t.bigint "modality_code_id", null: false
    t.bigint "modality_id"
    t.bigint "modality_description_id"
    t.bigint "hospital_centre_id"
    t.bigint "hospital_unit_id"
    t.date "started_on", null: false
    t.date "ended_on"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "hd_profile_id"
    t.bigint "pd_regime_id"
    t.integer "discharge_reason_code"
    t.string "discharge_reason_comment"
    t.string "hd_type"
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

  create_table "user_group_memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "user_group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_group_id"], name: "index_user_group_memberships_on_user_group_id"
    t.index ["user_id", "user_group_id"], name: "index_user_group_memberships_on_user_id_and_user_group_id", unique: true
    t.index ["user_id"], name: "index_user_group_memberships_on_user_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.string "name", null: false, comment: "e.g. 'Transplant Cordinators'"
    t.string "description"
    t.boolean "active", default: true, null: false, comment: "If false, the group will not be displayed anywhere prospectively"
    t.integer "memberships_count", default: 0, null: false, comment: "Counter cache for the number of memberships in this group"
    t.boolean "letter_electronic_ccs", default: false, null: false, comment: "If true, the group can be chosen from the electronic CCs recipients dropdown in letters"
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_user_groups_on_active"
    t.index ["created_by_id"], name: "index_user_groups_on_created_by_id"
    t.index ["name"], name: "index_user_groups_on_name", unique: true
    t.index ["updated_by_id"], name: "index_user_groups_on_updated_by_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "username", null: false
    t.string "given_name", null: false
    t.string "family_name", null: false
    t.string "signature"
    t.datetime "last_activity_at", precision: nil
    t.datetime "expired_at", precision: nil
    t.string "professional_position"
    t.boolean "approved", default: false, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "telephone"
    t.string "authentication_token"
    t.bigint "hospital_centre_id"
    t.boolean "asked_for_write_access", default: false, null: false
    t.boolean "consultant", default: false, null: false
    t.boolean "hidden", default: false, null: false
    t.integer "feature_flags", default: 0, null: false, comment: "OR'ed feature flag bits to enable experimental features for certain users"
    t.boolean "prescriber", default: false, null: false, comment: "A user can only add or terminate a prescription if this is set to true"
    t.string "language"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.datetime "password_changed_at", precision: nil
    t.boolean "banned", default: false, null: false
    t.text "notes"
    t.string "gmc_code"
    t.enum "nursing_experience_level", enum_type: "nursing_experience_level_enum"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.datetime "last_failed_sign_in_at"
    t.index "lower((email)::text)", name: "index_users_on_lower_email", unique: true
    t.index "lower((username)::text)", name: "index_users_on_lower_username", unique: true
    t.index ["approved"], name: "index_users_on_approved"
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

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "virology_profiles", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.jsonb "document", default: {}, null: false
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.datetime "updated_at", precision: nil
    t.datetime "created_at", precision: nil
    t.index ["created_by_id"], name: "index_virology_profiles_on_created_by_id"
    t.index ["document"], name: "index_virology_profiles_on_document", using: :gin
    t.index ["patient_id"], name: "index_virology_profiles_on_patient_id", unique: true
    t.index ["updated_by_id"], name: "index_virology_profiles_on_updated_by_id"
  end

  create_table "virology_vaccination_types", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "atc_codes", default: [], null: false, array: true
    t.index ["code"], name: "index_virology_vaccination_types_on_code", unique: true
    t.index ["name"], name: "index_virology_vaccination_types_on_name", unique: true
  end

  create_table "virology_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_virology_versions_on_item_type_and_item_id"
  end

  add_foreign_key "access_assessments", "access_types", column: "type_id"
  add_foreign_key "access_assessments", "patients"
  add_foreign_key "access_assessments", "users", column: "created_by_id", name: "access_assessments_created_by_id_fk"
  add_foreign_key "access_assessments", "users", column: "updated_by_id", name: "access_assessments_updated_by_id_fk"
  add_foreign_key "access_needling_assessments", "patients"
  add_foreign_key "access_needling_assessments", "users", column: "created_by_id"
  add_foreign_key "access_needling_assessments", "users", column: "updated_by_id"
  add_foreign_key "access_plans", "access_plan_types", column: "plan_type_id"
  add_foreign_key "access_plans", "patients"
  add_foreign_key "access_plans", "users", column: "created_by_id"
  add_foreign_key "access_plans", "users", column: "decided_by_id"
  add_foreign_key "access_plans", "users", column: "updated_by_id"
  add_foreign_key "access_procedures", "access_types", column: "type_id"
  add_foreign_key "access_procedures", "patients"
  add_foreign_key "access_procedures", "users", column: "created_by_id", name: "access_procedures_created_by_id_fk"
  add_foreign_key "access_procedures", "users", column: "updated_by_id", name: "access_procedures_updated_by_id_fk"
  add_foreign_key "access_profiles", "access_types", column: "type_id"
  add_foreign_key "access_profiles", "patients"
  add_foreign_key "access_profiles", "users", column: "created_by_id", name: "access_profiles_created_by_id_fk"
  add_foreign_key "access_profiles", "users", column: "decided_by_id"
  add_foreign_key "access_profiles", "users", column: "updated_by_id", name: "access_profiles_updated_by_id_fk"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "system_countries", column: "country_id"
  add_foreign_key "admission_admissions", "hospital_wards"
  add_foreign_key "admission_admissions", "modality_modalities", column: "modality_at_admission_id"
  add_foreign_key "admission_admissions", "patients"
  add_foreign_key "admission_admissions", "users", column: "created_by_id"
  add_foreign_key "admission_admissions", "users", column: "summarised_by_id"
  add_foreign_key "admission_admissions", "users", column: "updated_by_id"
  add_foreign_key "admission_consults", "admission_specialties", column: "specialty_id"
  add_foreign_key "admission_consults", "hospital_wards"
  add_foreign_key "admission_consults", "patients"
  add_foreign_key "admission_consults", "users", column: "created_by_id"
  add_foreign_key "admission_consults", "users", column: "seen_by_id"
  add_foreign_key "admission_consults", "users", column: "updated_by_id"
  add_foreign_key "admission_requests", "admission_request_reasons", column: "reason_id"
  add_foreign_key "admission_requests", "hospital_units"
  add_foreign_key "admission_requests", "patients"
  add_foreign_key "admission_requests", "users", column: "created_by_id"
  add_foreign_key "admission_requests", "users", column: "updated_by_id"
  add_foreign_key "clinic_appointments", "clinic_clinics", column: "clinic_id"
  add_foreign_key "clinic_appointments", "clinic_consultants", column: "consultant_id"
  add_foreign_key "clinic_appointments", "clinic_visits", column: "becomes_visit_id"
  add_foreign_key "clinic_appointments", "patients"
  add_foreign_key "clinic_appointments", "users", column: "created_by_id"
  add_foreign_key "clinic_appointments", "users", column: "updated_by_id"
  add_foreign_key "clinic_clinics", "modality_descriptions", column: "default_modality_description_id"
  add_foreign_key "clinic_clinics", "users"
  add_foreign_key "clinic_clinics", "users", column: "created_by_id"
  add_foreign_key "clinic_clinics", "users", column: "updated_by_id"
  add_foreign_key "clinic_consultants", "users", column: "created_by_id"
  add_foreign_key "clinic_consultants", "users", column: "updated_by_id"
  add_foreign_key "clinic_mappings", "clinic_clinics", column: "clinic_id"
  add_foreign_key "clinic_visit_locations", "users", column: "created_by_id"
  add_foreign_key "clinic_visit_locations", "users", column: "updated_by_id"
  add_foreign_key "clinic_visits", "clinic_clinics", column: "clinic_id"
  add_foreign_key "clinic_visits", "clinic_visit_locations", column: "location_id"
  add_foreign_key "clinic_visits", "patients", name: "clinic_visits_patient_id_fk"
  add_foreign_key "clinic_visits", "users", column: "created_by_id", name: "clinic_visits_created_by_id_fk"
  add_foreign_key "clinic_visits", "users", column: "updated_by_id", name: "clinic_visits_updated_by_id_fk"
  add_foreign_key "clinical_allergies", "patients"
  add_foreign_key "clinical_allergies", "users", column: "created_by_id"
  add_foreign_key "clinical_allergies", "users", column: "updated_by_id"
  add_foreign_key "clinical_body_compositions", "modality_descriptions"
  add_foreign_key "clinical_body_compositions", "patients"
  add_foreign_key "clinical_body_compositions", "users", column: "assessor_id"
  add_foreign_key "clinical_dry_weights", "patients"
  add_foreign_key "clinical_dry_weights", "users", column: "assessor_id"
  add_foreign_key "clinical_dry_weights", "users", column: "created_by_id", name: "hd_dry_weights_created_by_id_fk"
  add_foreign_key "clinical_dry_weights", "users", column: "updated_by_id", name: "hd_dry_weights_updated_by_id_fk"
  add_foreign_key "clinical_igan_risks", "patients"
  add_foreign_key "clinical_igan_risks", "users", column: "created_by_id"
  add_foreign_key "clinical_igan_risks", "users", column: "updated_by_id"
  add_foreign_key "directory_people", "users", column: "created_by_id", name: "directory_people_created_by_id_fk"
  add_foreign_key "directory_people", "users", column: "updated_by_id", name: "directory_people_updated_by_id_fk"
  add_foreign_key "drug_homecare_forms", "drug_suppliers", column: "supplier_id"
  add_foreign_key "drug_trade_family_classifications", "drug_trade_families", column: "trade_family_id"
  add_foreign_key "drug_trade_family_classifications", "drugs"
  add_foreign_key "drug_types_drugs", "drug_types"
  add_foreign_key "drug_types_drugs", "drugs"
  add_foreign_key "drug_vmp_classifications", "drug_forms", column: "form_id"
  add_foreign_key "drug_vmp_classifications", "drug_unit_of_measures", column: "unit_of_measure_id"
  add_foreign_key "drug_vmp_classifications", "drugs"
  add_foreign_key "drug_vmp_classifications", "medication_routes", column: "route_id"
  add_foreign_key "event_subtypes", "event_types"
  add_foreign_key "event_subtypes", "users", column: "created_by_id"
  add_foreign_key "event_subtypes", "users", column: "updated_by_id"
  add_foreign_key "event_type_alert_triggers", "event_types"
  add_foreign_key "event_types", "event_categories", column: "category_id"
  add_foreign_key "events", "event_subtypes", column: "subtype_id"
  add_foreign_key "events", "event_types"
  add_foreign_key "events", "patients"
  add_foreign_key "events", "users", column: "created_by_id", name: "events_created_by_id_fk"
  add_foreign_key "events", "users", column: "updated_by_id", name: "events_updated_by_id_fk"
  add_foreign_key "feed_files", "feed_file_types", column: "file_type_id"
  add_foreign_key "feed_logs", "feed_messages", column: "message_id"
  add_foreign_key "feed_logs", "patients"
  add_foreign_key "feed_message_replays", "feed_messages", column: "message_id"
  add_foreign_key "feed_message_replays", "feed_replay_requests", column: "replay_request_id"
  add_foreign_key "feed_outgoing_documents", "users", column: "created_by_id"
  add_foreign_key "feed_outgoing_documents", "users", column: "updated_by_id"
  add_foreign_key "feed_replay_requests", "patients"
  add_foreign_key "geography_lower_super_output_areas", "geography_middle_super_output_areas", column: "middle_super_output_area_id"
  add_foreign_key "geography_middle_super_output_areas", "geography_local_authority_districts", column: "local_authority_district_id"
  add_foreign_key "geography_output_areas", "geography_lower_super_output_areas", column: "lower_super_output_area_id"
  add_foreign_key "geography_postcodes", "geography_lower_super_output_areas", column: "lower_super_output_area_id"
  add_foreign_key "hd_acuity_assessments", "patients"
  add_foreign_key "hd_acuity_assessments", "users", column: "created_by_id"
  add_foreign_key "hd_acuity_assessments", "users", column: "updated_by_id"
  add_foreign_key "hd_diaries", "hd_diaries", column: "master_diary_id"
  add_foreign_key "hd_diaries", "hospital_units"
  add_foreign_key "hd_diaries", "users", column: "created_by_id"
  add_foreign_key "hd_diaries", "users", column: "updated_by_id"
  add_foreign_key "hd_diary_slots", "hd_diaries", column: "diary_id"
  add_foreign_key "hd_diary_slots", "hd_diurnal_period_codes", column: "diurnal_period_code_id"
  add_foreign_key "hd_diary_slots", "hd_stations", column: "station_id"
  add_foreign_key "hd_diary_slots", "patients"
  add_foreign_key "hd_diary_slots", "users", column: "created_by_id"
  add_foreign_key "hd_diary_slots", "users", column: "updated_by_id"
  add_foreign_key "hd_patient_statistics", "hospital_units"
  add_foreign_key "hd_patient_statistics", "patients"
  add_foreign_key "hd_preference_sets", "hd_schedule_definitions", column: "schedule_definition_id"
  add_foreign_key "hd_preference_sets", "hospital_units"
  add_foreign_key "hd_preference_sets", "patients"
  add_foreign_key "hd_preference_sets", "users", column: "created_by_id", name: "hd_preference_sets_created_by_id_fk"
  add_foreign_key "hd_preference_sets", "users", column: "updated_by_id", name: "hd_preference_sets_updated_by_id_fk"
  add_foreign_key "hd_prescription_administrations", "hd_prescription_administration_reasons", column: "reason_id"
  add_foreign_key "hd_prescription_administrations", "hd_sessions"
  add_foreign_key "hd_prescription_administrations", "medication_prescriptions", column: "prescription_id"
  add_foreign_key "hd_prescription_administrations", "patients"
  add_foreign_key "hd_prescription_administrations", "users", column: "administered_by_id"
  add_foreign_key "hd_prescription_administrations", "users", column: "created_by_id"
  add_foreign_key "hd_prescription_administrations", "users", column: "updated_by_id"
  add_foreign_key "hd_prescription_administrations", "users", column: "witnessed_by_id"
  add_foreign_key "hd_profiles", "hd_dialysates", column: "dialysate_id"
  add_foreign_key "hd_profiles", "hd_schedule_definitions", column: "schedule_definition_id"
  add_foreign_key "hd_profiles", "hospital_units"
  add_foreign_key "hd_profiles", "patients"
  add_foreign_key "hd_profiles", "users", column: "created_by_id", name: "hd_profiles_created_by_id_fk"
  add_foreign_key "hd_profiles", "users", column: "named_nurse_id_legacy"
  add_foreign_key "hd_profiles", "users", column: "prescriber_id"
  add_foreign_key "hd_profiles", "users", column: "transport_decider_id"
  add_foreign_key "hd_profiles", "users", column: "updated_by_id", name: "hd_profiles_updated_by_id_fk"
  add_foreign_key "hd_provider_units", "hd_providers"
  add_foreign_key "hd_provider_units", "hospital_units"
  add_foreign_key "hd_schedule_definitions", "hd_diurnal_period_codes", column: "diurnal_period_id"
  add_foreign_key "hd_session_form_batch_items", "hd_session_form_batches", column: "batch_id"
  add_foreign_key "hd_session_form_batches", "users", column: "created_by_id"
  add_foreign_key "hd_session_form_batches", "users", column: "updated_by_id"
  add_foreign_key "hd_session_patient_group_directions", "drug_patient_group_directions", column: "patient_group_direction_id"
  add_foreign_key "hd_session_patient_group_directions", "hd_sessions", column: "session_id"
  add_foreign_key "hd_sessions", "clinical_dry_weights", column: "dry_weight_id"
  add_foreign_key "hd_sessions", "hd_dialysates", column: "dialysate_id"
  add_foreign_key "hd_sessions", "hd_profiles", column: "profile_id"
  add_foreign_key "hd_sessions", "hd_providers", column: "provider_id"
  add_foreign_key "hd_sessions", "hd_stations"
  add_foreign_key "hd_sessions", "hospital_units"
  add_foreign_key "hd_sessions", "modality_descriptions"
  add_foreign_key "hd_sessions", "patients"
  add_foreign_key "hd_sessions", "users", column: "created_by_id", name: "hd_sessions_created_by_id_fk"
  add_foreign_key "hd_sessions", "users", column: "signed_off_by_id"
  add_foreign_key "hd_sessions", "users", column: "signed_on_by_id"
  add_foreign_key "hd_sessions", "users", column: "updated_by_id", name: "hd_sessions_updated_by_id_fk"
  add_foreign_key "hd_slot_requests", "hd_slot_request_access_states", column: "access_state_id"
  add_foreign_key "hd_slot_requests", "hd_slot_request_deletion_reasons", column: "deletion_reason_id"
  add_foreign_key "hd_slot_requests", "hd_slot_request_locations", column: "location_id"
  add_foreign_key "hd_slot_requests", "patients"
  add_foreign_key "hd_slot_requests", "users", column: "created_by_id"
  add_foreign_key "hd_slot_requests", "users", column: "updated_by_id"
  add_foreign_key "hd_stations", "hd_station_locations", column: "location_id"
  add_foreign_key "hd_stations", "hospital_units"
  add_foreign_key "hd_stations", "users", column: "created_by_id"
  add_foreign_key "hd_stations", "users", column: "updated_by_id"
  add_foreign_key "hd_transmission_logs", "hd_provider_units"
  add_foreign_key "hd_transmission_logs", "patients"
  add_foreign_key "hd_vnd_risk_assessments", "patients"
  add_foreign_key "hd_vnd_risk_assessments", "users", column: "created_by_id"
  add_foreign_key "hd_vnd_risk_assessments", "users", column: "updated_by_id"
  add_foreign_key "help_tour_annotations", "help_tour_pages", column: "page_id"
  add_foreign_key "hospital_departments", "hospital_centres"
  add_foreign_key "hospital_units", "hospital_centres"
  add_foreign_key "hospital_wards", "hospital_units"
  add_foreign_key "letter_archives", "letter_letters", column: "letter_id"
  add_foreign_key "letter_archives", "users", column: "created_by_id", name: "letter_archives_created_by_id_fk"
  add_foreign_key "letter_archives", "users", column: "updated_by_id", name: "letter_archives_updated_by_id_fk"
  add_foreign_key "letter_batch_items", "letter_batches", column: "batch_id"
  add_foreign_key "letter_batch_items", "letter_letters", column: "letter_id"
  add_foreign_key "letter_batches", "users", column: "created_by_id"
  add_foreign_key "letter_batches", "users", column: "updated_by_id"
  add_foreign_key "letter_contacts", "directory_people", column: "person_id"
  add_foreign_key "letter_contacts", "letter_contact_descriptions", column: "description_id"
  add_foreign_key "letter_contacts", "patients"
  add_foreign_key "letter_descriptions", "letter_snomed_document_types", column: "snomed_document_type_id"
  add_foreign_key "letter_electronic_receipts", "letter_letters", column: "letter_id"
  add_foreign_key "letter_electronic_receipts", "user_groups", validate: false
  add_foreign_key "letter_electronic_receipts", "users", column: "recipient_id"
  add_foreign_key "letter_letterheads", "hospital_departments"
  add_foreign_key "letter_letters", "letter_letterheads", column: "letterhead_id"
  add_foreign_key "letter_letters", "patients", name: "letter_letters_patient_id_fk"
  add_foreign_key "letter_letters", "users", column: "approved_by_id"
  add_foreign_key "letter_letters", "users", column: "author_id"
  add_foreign_key "letter_letters", "users", column: "completed_by_id"
  add_foreign_key "letter_letters", "users", column: "created_by_id", name: "letter_letters_created_by_id_fk"
  add_foreign_key "letter_letters", "users", column: "deleted_by_id"
  add_foreign_key "letter_letters", "users", column: "submitted_for_approval_by_id"
  add_foreign_key "letter_letters", "users", column: "updated_by_id", name: "letter_letters_updated_by_id_fk"
  add_foreign_key "letter_mailshot_items", "letter_letters", column: "letter_id"
  add_foreign_key "letter_mailshot_items", "letter_mailshot_mailshots", column: "mailshot_id"
  add_foreign_key "letter_mailshot_mailshots", "letter_letterheads", column: "letterhead_id"
  add_foreign_key "letter_mailshot_mailshots", "users", column: "author_id"
  add_foreign_key "letter_mailshot_mailshots", "users", column: "created_by_id"
  add_foreign_key "letter_mailshot_mailshots", "users", column: "updated_by_id"
  add_foreign_key "letter_mesh_operations", "letter_mesh_operations", column: "parent_id"
  add_foreign_key "letter_mesh_operations", "letter_mesh_transmissions", column: "transmission_id"
  add_foreign_key "letter_mesh_transmissions", "letter_letters", column: "letter_id"
  add_foreign_key "letter_qr_encoded_online_reference_links", "letter_letters", column: "letter_id"
  add_foreign_key "letter_qr_encoded_online_reference_links", "system_online_reference_links", column: "online_reference_link_id"
  add_foreign_key "letter_recipients", "letter_letters", column: "letter_id"
  add_foreign_key "letter_section_snapshots", "letter_letters", column: "letter_id"
  add_foreign_key "letter_signatures", "letter_letters", column: "letter_id"
  add_foreign_key "letter_signatures", "users"
  add_foreign_key "low_clearance_profiles", "low_clearance_referrers", column: "referrer_id"
  add_foreign_key "low_clearance_profiles", "patients"
  add_foreign_key "low_clearance_profiles", "users", column: "created_by_id"
  add_foreign_key "low_clearance_profiles", "users", column: "updated_by_id"
  add_foreign_key "medication_delivery_event_prescriptions", "medication_delivery_events", column: "event_id"
  add_foreign_key "medication_delivery_event_prescriptions", "medication_prescriptions", column: "prescription_id"
  add_foreign_key "medication_delivery_events", "drug_homecare_forms", column: "homecare_form_id"
  add_foreign_key "medication_delivery_events", "drug_types"
  add_foreign_key "medication_delivery_events", "users", column: "created_by_id"
  add_foreign_key "medication_delivery_events", "users", column: "updated_by_id"
  add_foreign_key "medication_prescription_terminations", "medication_prescriptions", column: "prescription_id"
  add_foreign_key "medication_prescription_terminations", "users", column: "created_by_id"
  add_foreign_key "medication_prescription_terminations", "users", column: "updated_by_id"
  add_foreign_key "medication_prescriptions", "drug_forms", column: "form_id"
  add_foreign_key "medication_prescriptions", "drug_trade_families", column: "trade_family_id"
  add_foreign_key "medication_prescriptions", "drug_unit_of_measures", column: "unit_of_measure_id"
  add_foreign_key "medication_prescriptions", "drugs"
  add_foreign_key "medication_prescriptions", "medication_routes"
  add_foreign_key "medication_prescriptions", "patients"
  add_foreign_key "medication_prescriptions", "users", column: "created_by_id"
  add_foreign_key "medication_prescriptions", "users", column: "updated_by_id"
  add_foreign_key "messaging_messages", "messaging_messages", column: "replying_to_message_id"
  add_foreign_key "messaging_messages", "patients"
  add_foreign_key "messaging_messages", "users", column: "author_id"
  add_foreign_key "messaging_receipts", "messaging_messages", column: "message_id"
  add_foreign_key "messaging_receipts", "users", column: "recipient_id"
  add_foreign_key "modality_change_types", "users", column: "created_by_id"
  add_foreign_key "modality_change_types", "users", column: "updated_by_id"
  add_foreign_key "modality_descriptions", "ukrdc_modality_codes"
  add_foreign_key "modality_modalities", "hospital_centres", column: "destination_hospital_centre_id"
  add_foreign_key "modality_modalities", "hospital_centres", column: "source_hospital_centre_id"
  add_foreign_key "modality_modalities", "modality_change_types", column: "change_type_id"
  add_foreign_key "modality_modalities", "modality_descriptions", column: "description_id"
  add_foreign_key "modality_modalities", "modality_reasons", column: "reason_id"
  add_foreign_key "modality_modalities", "patients"
  add_foreign_key "modality_modalities", "users", column: "created_by_id", name: "modality_modalities_created_by_id_fk"
  add_foreign_key "modality_modalities", "users", column: "updated_by_id", name: "modality_modalities_updated_by_id_fk"
  add_foreign_key "monitoring_mirth_channel_stats", "monitoring_mirth_channels", column: "channel_id"
  add_foreign_key "monitoring_mirth_channels", "monitoring_mirth_channel_groups", column: "channel_group_id"
  add_foreign_key "pathology_calculation_sources", "pathology_observations", column: "calculated_observation_id"
  add_foreign_key "pathology_calculation_sources", "pathology_observations", column: "source_observation_id"
  add_foreign_key "pathology_chart_series", "pathology_charts", column: "chart_id"
  add_foreign_key "pathology_chart_series", "pathology_observation_descriptions", column: "observation_description_id"
  add_foreign_key "pathology_charts", "users", column: "owner_id"
  add_foreign_key "pathology_code_group_memberships", "pathology_code_groups", column: "code_group_id"
  add_foreign_key "pathology_code_group_memberships", "pathology_observation_descriptions", column: "observation_description_id"
  add_foreign_key "pathology_code_group_memberships", "users", column: "created_by_id"
  add_foreign_key "pathology_code_group_memberships", "users", column: "updated_by_id"
  add_foreign_key "pathology_code_groups", "users", column: "created_by_id"
  add_foreign_key "pathology_code_groups", "users", column: "updated_by_id"
  add_foreign_key "pathology_current_observation_sets", "patients"
  add_foreign_key "pathology_observation_descriptions", "pathology_measurement_units", column: "measurement_unit_id"
  add_foreign_key "pathology_observation_descriptions", "pathology_measurement_units", column: "suggested_measurement_unit_id"
  add_foreign_key "pathology_observation_descriptions", "pathology_senders", column: "created_by_sender_id"
  add_foreign_key "pathology_observation_requests", "pathology_request_descriptions", column: "description_id"
  add_foreign_key "pathology_observation_requests", "patients"
  add_foreign_key "pathology_observations", "pathology_observation_descriptions", column: "description_id"
  add_foreign_key "pathology_observations", "pathology_observation_requests", column: "request_id"
  add_foreign_key "pathology_obx_mappings", "pathology_observation_descriptions", column: "observation_description_id"
  add_foreign_key "pathology_obx_mappings", "pathology_senders", column: "sender_id"
  add_foreign_key "pathology_obx_mappings", "users", column: "created_by_id"
  add_foreign_key "pathology_obx_mappings", "users", column: "updated_by_id"
  add_foreign_key "pathology_request_descriptions", "pathology_labs", column: "lab_id"
  add_foreign_key "pathology_request_descriptions", "pathology_observation_descriptions", column: "required_observation_description_id"
  add_foreign_key "pathology_request_descriptions_requests_requests", "pathology_request_descriptions", column: "request_description_id"
  add_foreign_key "pathology_request_descriptions_requests_requests", "pathology_requests_requests", column: "request_id"
  add_foreign_key "pathology_requests_drugs_drug_categories", "drugs"
  add_foreign_key "pathology_requests_drugs_drug_categories", "pathology_requests_drug_categories", column: "drug_category_id"
  add_foreign_key "pathology_requests_global_rule_sets", "clinic_clinics", column: "clinic_id"
  add_foreign_key "pathology_requests_global_rule_sets", "pathology_request_descriptions", column: "request_description_id"
  add_foreign_key "pathology_requests_global_rules", "pathology_requests_global_rule_sets", column: "rule_set_id"
  add_foreign_key "pathology_requests_patient_rules", "pathology_labs", column: "lab_id"
  add_foreign_key "pathology_requests_patient_rules", "patients"
  add_foreign_key "pathology_requests_patient_rules_requests", "pathology_requests_patient_rules", column: "patient_rule_id"
  add_foreign_key "pathology_requests_patient_rules_requests", "pathology_requests_requests", column: "request_id"
  add_foreign_key "pathology_requests_requests", "clinic_clinics", column: "clinic_id"
  add_foreign_key "pathology_requests_requests", "clinic_consultants", column: "consultant_id"
  add_foreign_key "pathology_requests_requests", "patients"
  add_foreign_key "pathology_requests_requests", "users", column: "created_by_id", name: "pathology_requests_requests_created_by_id_fk"
  add_foreign_key "pathology_requests_requests", "users", column: "updated_by_id", name: "pathology_requests_requests_updated_by_id_fk"
  add_foreign_key "patient_alerts", "patients"
  add_foreign_key "patient_alerts", "users", column: "created_by_id"
  add_foreign_key "patient_alerts", "users", column: "updated_by_id"
  add_foreign_key "patient_attachments", "patient_attachment_types", column: "attachment_type_id"
  add_foreign_key "patient_attachments", "patients"
  add_foreign_key "patient_attachments", "users", column: "created_by_id"
  add_foreign_key "patient_attachments", "users", column: "updated_by_id"
  add_foreign_key "patient_bookmarks", "patients"
  add_foreign_key "patient_bookmarks", "users"
  add_foreign_key "patient_master_index_deprecated", "patients"
  add_foreign_key "patient_practice_memberships", "patient_practices", column: "practice_id"
  add_foreign_key "patient_practice_memberships", "patient_primary_care_physicians", column: "primary_care_physician_id"
  add_foreign_key "patient_worries", "patient_worry_categories", column: "worry_category_id"
  add_foreign_key "patient_worries", "patients"
  add_foreign_key "patient_worries", "users", column: "created_by_id"
  add_foreign_key "patient_worries", "users", column: "updated_by_id"
  add_foreign_key "patient_worry_categories", "users", column: "created_by_id"
  add_foreign_key "patient_worry_categories", "users", column: "updated_by_id"
  add_foreign_key "patients", "death_causes", column: "first_cause_id"
  add_foreign_key "patients", "death_causes", column: "second_cause_id"
  add_foreign_key "patients", "death_locations", column: "actual_death_location_id"
  add_foreign_key "patients", "death_locations", column: "preferred_death_location_id"
  add_foreign_key "patients", "hospital_centres"
  add_foreign_key "patients", "patient_ethnicities", column: "ethnicity_id"
  add_foreign_key "patients", "patient_languages", column: "language_id"
  add_foreign_key "patients", "patient_marital_statuses", column: "marital_status_id"
  add_foreign_key "patients", "patient_practices", column: "practice_id", name: "patients_practice_id_fk"
  add_foreign_key "patients", "patient_primary_care_physicians", column: "primary_care_physician_id"
  add_foreign_key "patients", "patient_religions", column: "religion_id"
  add_foreign_key "patients", "system_countries", column: "country_of_birth_id"
  add_foreign_key "patients", "users", column: "created_by_id", name: "patients_created_by_id_fk"
  add_foreign_key "patients", "users", column: "named_consultant_id"
  add_foreign_key "patients", "users", column: "named_nurse_id"
  add_foreign_key "patients", "users", column: "updated_by_id", name: "patients_updated_by_id_fk"
  add_foreign_key "pd_adequacy_results", "patients"
  add_foreign_key "pd_adequacy_results", "users", column: "created_by_id"
  add_foreign_key "pd_adequacy_results", "users", column: "updated_by_id"
  add_foreign_key "pd_assessments", "patients"
  add_foreign_key "pd_assessments", "users", column: "created_by_id"
  add_foreign_key "pd_assessments", "users", column: "updated_by_id"
  add_foreign_key "pd_exit_site_infections", "patients"
  add_foreign_key "pd_infection_organisms", "pd_organism_codes", column: "organism_code_id"
  add_foreign_key "pd_peritonitis_episode_types", "pd_peritonitis_episode_type_descriptions", column: "peritonitis_episode_type_description_id"
  add_foreign_key "pd_peritonitis_episode_types", "pd_peritonitis_episodes", column: "peritonitis_episode_id"
  add_foreign_key "pd_peritonitis_episodes", "patients"
  add_foreign_key "pd_peritonitis_episodes", "pd_fluid_descriptions", column: "fluid_description_id"
  add_foreign_key "pd_peritonitis_episodes", "pd_peritonitis_episode_type_descriptions", column: "episode_type_id"
  add_foreign_key "pd_pet_adequacy_results", "patients"
  add_foreign_key "pd_pet_adequacy_results", "users", column: "created_by_id"
  add_foreign_key "pd_pet_adequacy_results", "users", column: "updated_by_id"
  add_foreign_key "pd_pet_results", "patients"
  add_foreign_key "pd_pet_results", "pd_pet_dextrose_concentrations", column: "dextrose_concentration_id"
  add_foreign_key "pd_pet_results", "pd_pet_dextrose_concentrations", column: "overnight_dextrose_concentration_id"
  add_foreign_key "pd_pet_results", "users", column: "created_by_id"
  add_foreign_key "pd_pet_results", "users", column: "updated_by_id"
  add_foreign_key "pd_regime_bags", "pd_bag_types", column: "bag_type_id"
  add_foreign_key "pd_regime_bags", "pd_regimes", column: "regime_id"
  add_foreign_key "pd_regime_terminations", "pd_regimes", column: "regime_id"
  add_foreign_key "pd_regime_terminations", "users", column: "created_by_id"
  add_foreign_key "pd_regime_terminations", "users", column: "updated_by_id"
  add_foreign_key "pd_regimes", "patients"
  add_foreign_key "pd_regimes", "pd_systems", column: "system_id", name: "pd_regimes_system_id_fk"
  add_foreign_key "pd_regimes", "users", column: "created_by_id"
  add_foreign_key "pd_regimes", "users", column: "updated_by_id"
  add_foreign_key "pd_training_sessions", "patients"
  add_foreign_key "pd_training_sessions", "pd_training_sites", column: "training_site_id", name: "pd_training_sessions_site_id_fk"
  add_foreign_key "pd_training_sessions", "pd_training_types", column: "training_type_id", name: "pd_training_sessions_type_id_fk"
  add_foreign_key "pd_training_sessions", "users", column: "created_by_id"
  add_foreign_key "pd_training_sessions", "users", column: "updated_by_id"
  add_foreign_key "problem_comorbidities", "patients"
  add_foreign_key "problem_comorbidities", "problem_comorbidity_descriptions", column: "description_id"
  add_foreign_key "problem_comorbidities", "problem_malignancy_sites", column: "malignancy_site_id"
  add_foreign_key "problem_comorbidities", "users", column: "created_by_id"
  add_foreign_key "problem_comorbidities", "users", column: "updated_by_id"
  add_foreign_key "problem_notes", "problem_problems", column: "problem_id"
  add_foreign_key "problem_notes", "users", column: "created_by_id", name: "problem_notes_created_by_id_fk"
  add_foreign_key "problem_notes", "users", column: "updated_by_id", name: "problem_notes_updated_by_id_fk"
  add_foreign_key "problem_problems", "patients"
  add_foreign_key "problem_problems", "users", column: "created_by_id"
  add_foreign_key "problem_problems", "users", column: "updated_by_id"
  add_foreign_key "problem_radar_diagnoses", "problem_radar_cohorts", column: "cohort_id"
  add_foreign_key "renal_aki_alerts", "hospital_centres"
  add_foreign_key "renal_aki_alerts", "hospital_wards"
  add_foreign_key "renal_aki_alerts", "patients"
  add_foreign_key "renal_aki_alerts", "renal_aki_alert_actions", column: "action_id"
  add_foreign_key "renal_aki_alerts", "users", column: "created_by_id"
  add_foreign_key "renal_aki_alerts", "users", column: "updated_by_id"
  add_foreign_key "renal_profiles", "patients"
  add_foreign_key "renal_profiles", "renal_prd_descriptions", column: "prd_description_id"
  add_foreign_key "research_investigatorships", "research_studies", column: "study_id"
  add_foreign_key "research_investigatorships", "users"
  add_foreign_key "research_investigatorships", "users", column: "created_by_id"
  add_foreign_key "research_investigatorships", "users", column: "updated_by_id"
  add_foreign_key "research_participations", "patients"
  add_foreign_key "research_participations", "research_studies", column: "study_id"
  add_foreign_key "research_participations", "users", column: "created_by_id"
  add_foreign_key "research_participations", "users", column: "updated_by_id"
  add_foreign_key "research_studies", "users", column: "created_by_id"
  add_foreign_key "research_studies", "users", column: "updated_by_id"
  add_foreign_key "roles_users", "roles"
  add_foreign_key "roles_users", "users"
  add_foreign_key "snippets_snippets", "users", column: "author_id"
  add_foreign_key "survey_questions", "survey_surveys", column: "survey_id"
  add_foreign_key "survey_responses", "survey_questions", column: "question_id"
  add_foreign_key "system_dashboard_components", "system_components", column: "component_id"
  add_foreign_key "system_dashboard_components", "system_dashboards", column: "dashboard_id"
  add_foreign_key "system_dashboards", "system_dashboards", column: "cloned_from_dashboard_id"
  add_foreign_key "system_downloads", "users", column: "created_by_id"
  add_foreign_key "system_downloads", "users", column: "updated_by_id"
  add_foreign_key "system_logs", "users", column: "owner_id"
  add_foreign_key "system_online_reference_links", "users", column: "created_by_id"
  add_foreign_key "system_online_reference_links", "users", column: "updated_by_id"
  add_foreign_key "system_user_feedback", "users", column: "author_id"
  add_foreign_key "system_view_calls", "system_view_metadata", column: "view_metadata_id"
  add_foreign_key "system_view_calls", "users"
  add_foreign_key "system_view_metadata", "system_view_metadata", column: "parent_id"
  add_foreign_key "transplant_donations", "patients"
  add_foreign_key "transplant_donations", "patients", column: "recipient_id", name: "transplant_donations_recipient_id_fk"
  add_foreign_key "transplant_donor_followups", "transplant_donor_operations", column: "operation_id"
  add_foreign_key "transplant_donor_operations", "patients"
  add_foreign_key "transplant_donor_stages", "patients"
  add_foreign_key "transplant_donor_stages", "transplant_donor_stage_positions", column: "stage_position_id"
  add_foreign_key "transplant_donor_stages", "transplant_donor_stage_statuses", column: "stage_status_id"
  add_foreign_key "transplant_donor_stages", "users", column: "created_by_id"
  add_foreign_key "transplant_donor_stages", "users", column: "updated_by_id"
  add_foreign_key "transplant_donor_workups", "patients"
  add_foreign_key "transplant_failure_cause_descriptions", "transplant_failure_cause_description_groups", column: "group_id"
  add_foreign_key "transplant_recipient_followups", "transplant_failure_cause_descriptions"
  add_foreign_key "transplant_recipient_followups", "transplant_recipient_operations", column: "operation_id"
  add_foreign_key "transplant_recipient_operations", "hospital_centres"
  add_foreign_key "transplant_recipient_operations", "patients"
  add_foreign_key "transplant_recipient_operations", "transplant_induction_agents", column: "induction_agent_id"
  add_foreign_key "transplant_recipient_workups", "patients"
  add_foreign_key "transplant_registration_statuses", "transplant_registration_status_descriptions", column: "description_id"
  add_foreign_key "transplant_registration_statuses", "transplant_registrations", column: "registration_id"
  add_foreign_key "transplant_registration_statuses", "users", column: "created_by_id", name: "transplant_registration_statuses_created_by_id_fk"
  add_foreign_key "transplant_registration_statuses", "users", column: "updated_by_id", name: "transplant_registration_statuses_updated_by_id_fk"
  add_foreign_key "transplant_registrations", "patients"
  add_foreign_key "transplant_rejection_episodes", "transplant_recipient_followups", column: "followup_id"
  add_foreign_key "transplant_rejection_episodes", "transplant_rejection_treatments", column: "treatment_id"
  add_foreign_key "transplant_rejection_episodes", "users", column: "created_by_id"
  add_foreign_key "transplant_rejection_episodes", "users", column: "updated_by_id"
  add_foreign_key "ukrdc_transmission_logs", "patients"
  add_foreign_key "ukrdc_transmission_logs", "ukrdc_batches", column: "batch_id"
  add_foreign_key "ukrdc_treatments", "hd_profiles"
  add_foreign_key "ukrdc_treatments", "hospital_centres"
  add_foreign_key "ukrdc_treatments", "hospital_units"
  add_foreign_key "ukrdc_treatments", "modality_descriptions"
  add_foreign_key "ukrdc_treatments", "patients"
  add_foreign_key "ukrdc_treatments", "pd_regimes"
  add_foreign_key "ukrdc_treatments", "ukrdc_modality_codes", column: "modality_code_id"
  add_foreign_key "ukrdc_treatments", "users", column: "clinician_id"
  add_foreign_key "user_group_memberships", "user_groups"
  add_foreign_key "user_group_memberships", "users"
  add_foreign_key "user_groups", "users", column: "created_by_id"
  add_foreign_key "user_groups", "users", column: "updated_by_id"
  add_foreign_key "users", "hospital_centres"
  add_foreign_key "virology_profiles", "patients"
  add_foreign_key "virology_profiles", "users", column: "created_by_id"
  add_foreign_key "virology_profiles", "users", column: "updated_by_id"

  create_view "renalware.patient_current_modalities", sql_definition: <<-SQL
      SELECT patients.id AS patient_id,
      patients.secure_id AS patient_secure_id,
      current_modality.id AS modality_id,
      modality_descriptions.id AS modality_description_id,
      modality_descriptions.name AS modality_name,
      current_modality.started_on,
      modality_descriptions.code AS modality_code
     FROM ((patients
       LEFT JOIN ( SELECT DISTINCT ON (modality_modalities.patient_id) modality_modalities.id,
              modality_modalities.patient_id,
              modality_modalities.description_id,
              modality_modalities.reason_id,
              modality_modalities.modal_change_type_deprecated AS modal_change_type,
              modality_modalities.notes,
              modality_modalities.started_on,
              modality_modalities.ended_on,
              modality_modalities.state,
              modality_modalities.created_at,
              modality_modalities.updated_at,
              modality_modalities.created_by_id,
              modality_modalities.updated_by_id
             FROM modality_modalities
            WHERE (modality_modalities.ended_on IS NULL)
            ORDER BY modality_modalities.patient_id, modality_modalities.started_on DESC, modality_modalities.created_at DESC) current_modality ON ((patients.id = current_modality.patient_id)))
       LEFT JOIN modality_descriptions ON ((modality_descriptions.id = current_modality.description_id)));
  SQL
  create_view "renalware.akcc_mdm_patients", sql_definition: <<-SQL
      SELECT p.id,
      p.secure_id,
      ((upper((p.family_name)::text) || ', '::text) || (p.given_name)::text) AS patient_name,
      p.nhs_number,
      p.local_patient_id AS hospital_numbers,
      p.sex,
      p.born_on,
      date_part('year'::text, age((p.born_on)::timestamp with time zone)) AS age,
      rprof.esrf_on,
      mx.modality_name,
      aplantype.name AS access_plan,
      (aplan.created_at)::date AS access_plan_date,
          CASE
              WHEN (pw.id > 0) THEN true
              ELSE false
          END AS on_worryboard,
      ( SELECT clinic_visits.bmi
             FROM clinic_visits
            WHERE ((clinic_visits.patient_id = p.id) AND (clinic_visits.bmi > (0)::numeric))
            ORDER BY clinic_visits.date DESC
           LIMIT 1) AS bmi,
      txrsd.name AS tx_status,
      convert_to_float(((pa."values" -> 'HGB'::text) ->> 'result'::text), NULL::double precision) AS hgb,
      (((pa."values" -> 'HGB'::text) ->> 'observed_at'::text))::date AS hgb_date,
      convert_to_float(((pa."values" -> 'URE'::text) ->> 'result'::text), NULL::double precision) AS ure,
      (((pa."values" -> 'URE'::text) ->> 'observed_at'::text))::date AS ure_date,
      convert_to_float(((pa."values" -> 'CRE'::text) ->> 'result'::text), NULL::double precision) AS cre,
      (((pa."values" -> 'CRE'::text) ->> 'observed_at'::text))::date AS cre_date,
      convert_to_float(((pa."values" -> 'EGFR'::text) ->> 'result'::text), NULL::double precision) AS egfr,
          CASE
              WHEN ((txrsd.code)::text !~~* '%permanent'::text) THEN true
              ELSE false
          END AS tx_candidate,
          CASE
              WHEN (convert_to_float(((pa."values" -> 'HGB'::text) ->> 'result'::text)) < (100.0)::double precision) THEN '< 100'::text
              WHEN (convert_to_float(((pa."values" -> 'HGB'::text) ->> 'result'::text)) > (130.0)::double precision) THEN '> 130'::text
              ELSE NULL::text
          END AS hgb_range,
          CASE
              WHEN (convert_to_float(((pa."values" -> 'URE'::text) ->> 'result'::text)) >= (30.0)::double precision) THEN '>= 30'::text
              ELSE NULL::text
          END AS urea_range,
      (((named_nurses.family_name)::text || ', '::text) || (named_nurses.given_name)::text) AS named_nurse,
      (((named_consultants.family_name)::text || ', '::text) || (named_consultants.given_name)::text) AS named_consultant,
      h.name AS hospital_centre
     FROM ((((((((((((patients p
       LEFT JOIN patient_worries pw ON ((pw.patient_id = p.id)))
       LEFT JOIN pathology_current_observation_sets pa ON ((pa.patient_id = p.id)))
       LEFT JOIN renal_profiles rprof ON ((rprof.patient_id = p.id)))
       LEFT JOIN transplant_registrations txr ON ((txr.patient_id = p.id)))
       LEFT JOIN transplant_registration_statuses txrs ON (((txrs.registration_id = txr.id) AND (txrs.terminated_on IS NULL) AND (txrs.started_on <= CURRENT_DATE))))
       LEFT JOIN transplant_registration_status_descriptions txrsd ON ((txrsd.id = txrs.description_id)))
       LEFT JOIN users named_nurses ON ((named_nurses.id = p.named_nurse_id)))
       LEFT JOIN users named_consultants ON ((named_consultants.id = p.named_consultant_id)))
       LEFT JOIN hospital_centres h ON ((h.id = p.hospital_centre_id)))
       LEFT JOIN access_plans aplan ON (((aplan.patient_id = p.id) AND (aplan.terminated_at IS NULL))))
       LEFT JOIN access_plan_types aplantype ON ((aplantype.id = aplan.plan_type_id)))
       JOIN patient_current_modalities mx ON (((mx.patient_id = p.id) AND ((mx.modality_code)::text = 'low_clearance'::text))));
  SQL
  create_view "renalware.hd_mdm_patients", sql_definition: <<-SQL
      SELECT p.id,
      p.secure_id,
      ((upper((p.family_name)::text) || ', '::text) || (p.given_name)::text) AS patient_name,
      p.nhs_number,
      p.local_patient_id AS hospital_numbers,
      p.sex,
      p.born_on,
      rprof.esrf_on,
      latest_op.performed_on AS last_operation_date,
      (date_part('year'::text, age((p.born_on)::timestamp with time zone)))::integer AS age,
      mx.modality_name,
          CASE
              WHEN (pw.id > 0) THEN true
              ELSE false
          END AS on_worryboard,
      at.name AS access,
      ( SELECT cv2.bmi
             FROM clinic_visits cv2
            WHERE ((cv2.patient_id = p.id) AND (cv2.bmi > (0)::numeric))
            ORDER BY cv2.date DESC
           LIMIT 1) AS bmi,
      ap.started_on AS access_date,
      aplantype.name AS access_plan,
      (aplan.created_at)::date AS plan_date,
      txrsd.name AS tx_status,
      unit.name AS hospital_unit,
      unit.unit_code AS dialysing_at,
      (((named_nurses.family_name)::text || ', '::text) || (named_nurses.given_name)::text) AS named_nurse,
      (((named_consultants.family_name)::text || ', '::text) || (named_consultants.given_name)::text) AS named_consultant,
      h.name AS hospital_centre,
      ((((hdp.document -> 'transport'::text) ->> 'has_transport'::text) || ': '::text) || ((hdp.document -> 'transport'::text) ->> 'type'::text)) AS transport,
      ((sched.days_text || ' '::text) || upper((diurnal.code)::text)) AS schedule,
      convert_to_float(((pa."values" -> 'HGB'::text) ->> 'result'::text), NULL::double precision) AS hgb,
      (((pa."values" -> 'HGB'::text) ->> 'observed_at'::text))::date AS hgb_date,
      convert_to_float(((pa."values" -> 'PHOS'::text) ->> 'result'::text), NULL::double precision) AS phos,
      (((pa."values" -> 'PHOS'::text) ->> 'observed_at'::text))::date AS phos_date,
      convert_to_float(((pa."values" -> 'POT'::text) ->> 'result'::text), NULL::double precision) AS pot,
      (((pa."values" -> 'POT'::text) ->> 'observed_at'::text))::date AS pot_date,
      convert_to_float(((pa."values" -> 'PTHI'::text) ->> 'result'::text), NULL::double precision) AS pthi,
      (((pa."values" -> 'PTHI'::text) ->> 'observed_at'::text))::date AS pthi_date,
      convert_to_float(((pa."values" -> 'URR'::text) ->> 'result'::text), NULL::double precision) AS urr,
      (((pa."values" -> 'URR'::text) ->> 'observed_at'::text))::date AS urr_date,
      latest_vnd.overall_risk_score AS vnd_risk_score,
      latest_vnd.overall_risk_level AS vnd_risk_level
     FROM ((((((((((((((((((((patients p
       JOIN patient_current_modalities mx ON (((mx.patient_id = p.id) AND ((mx.modality_code)::text = 'hd'::text))))
       LEFT JOIN hd_profiles hdp ON (((hdp.patient_id = p.id) AND (hdp.deactivated_at IS NULL))))
       LEFT JOIN hospital_units unit ON ((unit.id = hdp.hospital_unit_id)))
       LEFT JOIN users named_nurses ON ((named_nurses.id = p.named_nurse_id)))
       LEFT JOIN users named_consultants ON ((named_consultants.id = p.named_consultant_id)))
       LEFT JOIN patient_worries pw ON ((pw.patient_id = p.id)))
       LEFT JOIN hd_schedule_definitions sched ON ((sched.id = hdp.schedule_definition_id)))
       LEFT JOIN hd_diurnal_period_codes diurnal ON ((diurnal.id = sched.diurnal_period_id)))
       LEFT JOIN pathology_current_observation_sets pa ON ((pa.patient_id = p.id)))
       LEFT JOIN hospital_centres h ON ((h.id = p.hospital_centre_id)))
       LEFT JOIN ( SELECT DISTINCT ON (access_profiles.patient_id) access_profiles.id,
              access_profiles.patient_id,
              access_profiles.formed_on,
              access_profiles.started_on,
              access_profiles.terminated_on,
              access_profiles.type_id,
              access_profiles.side,
              access_profiles.notes,
              access_profiles.created_by_id,
              access_profiles.updated_by_id,
              access_profiles.created_at,
              access_profiles.updated_at,
              access_profiles.decided_by_id
             FROM access_profiles
            WHERE (access_profiles.terminated_on IS NULL)
            ORDER BY access_profiles.patient_id, access_profiles.created_at DESC) ap ON ((ap.patient_id = p.id)))
       LEFT JOIN access_types at ON ((at.id = ap.type_id)))
       LEFT JOIN access_plans aplan ON (((aplan.patient_id = p.id) AND (aplan.terminated_at IS NULL))))
       LEFT JOIN access_plan_types aplantype ON ((aplantype.id = aplan.plan_type_id)))
       LEFT JOIN transplant_registrations txr ON ((txr.patient_id = p.id)))
       LEFT JOIN transplant_registration_statuses txrs ON (((txrs.registration_id = txr.id) AND (txrs.terminated_on IS NULL))))
       LEFT JOIN transplant_registration_status_descriptions txrsd ON ((txrsd.id = txrs.description_id)))
       LEFT JOIN renal_profiles rprof ON ((rprof.patient_id = p.id)))
       LEFT JOIN ( SELECT DISTINCT ON (hvra.patient_id) hvra.patient_id,
              hvra.overall_risk_score,
              hvra.overall_risk_level
             FROM hd_vnd_risk_assessments hvra
            ORDER BY hvra.patient_id, hvra.updated_at DESC) latest_vnd ON ((latest_vnd.patient_id = p.id)))
       LEFT JOIN ( SELECT DISTINCT ON (transplant_recipient_operations.patient_id) transplant_recipient_operations.patient_id,
              transplant_recipient_operations.performed_on
             FROM transplant_recipient_operations
            ORDER BY transplant_recipient_operations.patient_id, transplant_recipient_operations.performed_on DESC) latest_op ON ((latest_op.patient_id = p.id)));
  SQL
  create_view "renalware.low_clearance_mdm_patients", sql_definition: <<-SQL
      SELECT p.id,
      p.secure_id,
      ((upper((p.family_name)::text) || ', '::text) || (p.given_name)::text) AS patient_name,
      p.nhs_number,
      p.local_patient_id AS hospital_numbers,
      p.sex,
      p.born_on,
      date_part('year'::text, age((p.born_on)::timestamp with time zone)) AS age,
      rprof.esrf_on,
      mx.modality_name,
          CASE
              WHEN (pw.id > 0) THEN true
              ELSE false
          END AS on_worryboard,
      ( SELECT clinic_visits.bmi
             FROM clinic_visits
            WHERE ((clinic_visits.patient_id = p.id) AND (clinic_visits.bmi > (0)::numeric))
            ORDER BY clinic_visits.date DESC
           LIMIT 1) AS bmi,
      txrsd.name AS tx_status,
      ((pa."values" -> 'HGB'::text) ->> 'result'::text) AS hgb,
      (((pa."values" -> 'HGB'::text) ->> 'observed_at'::text))::date AS hgb_date,
      ((pa."values" -> 'URE'::text) ->> 'result'::text) AS ure,
      (((pa."values" -> 'URE'::text) ->> 'observed_at'::text))::date AS ure_date,
      ((pa."values" -> 'CRE'::text) ->> 'result'::text) AS cre,
      (((pa."values" -> 'CRE'::text) ->> 'observed_at'::text))::date AS cre_date,
      ((pa."values" -> 'EGFR'::text) ->> 'result'::text) AS egfr,
          CASE
              WHEN ((txrsd.code)::text !~~* '%permanent'::text) THEN true
              ELSE false
          END AS tx_candidate,
          CASE
              WHEN (convert_to_float(((pa."values" -> 'HGB'::text) ->> 'result'::text)) < (100.0)::double precision) THEN '< 100'::text
              WHEN (convert_to_float(((pa."values" -> 'HGB'::text) ->> 'result'::text)) > (130.0)::double precision) THEN '> 130'::text
              ELSE NULL::text
          END AS hgb_range,
          CASE
              WHEN (convert_to_float(((pa."values" -> 'URE'::text) ->> 'result'::text)) >= (30.0)::double precision) THEN '>= 30'::text
              ELSE NULL::text
          END AS urea_range
     FROM (((((((patients p
       LEFT JOIN patient_worries pw ON ((pw.patient_id = p.id)))
       LEFT JOIN pathology_current_observation_sets pa ON ((pa.patient_id = p.id)))
       LEFT JOIN renal_profiles rprof ON ((rprof.patient_id = p.id)))
       LEFT JOIN transplant_registrations txr ON ((txr.patient_id = p.id)))
       LEFT JOIN transplant_registration_statuses txrs ON (((txrs.registration_id = txr.id) AND (txrs.terminated_on IS NULL) AND (txrs.started_on <= CURRENT_DATE))))
       LEFT JOIN transplant_registration_status_descriptions txrsd ON ((txrsd.id = txrs.description_id)))
       JOIN patient_current_modalities mx ON (((mx.patient_id = p.id) AND ((mx.modality_code)::text = 'low_clearance'::text))));
  SQL
  create_view "renalware.pd_mdm_patients", sql_definition: <<-SQL
      SELECT DISTINCT ON (p.id) p.id,
      p.secure_id,
      ((upper((p.family_name)::text) || ', '::text) || (p.given_name)::text) AS patient_name,
      p.nhs_number,
      p.local_patient_id AS hospital_numbers,
      p.sex,
      p.born_on,
      date_part('year'::text, age((p.born_on)::timestamp with time zone)) AS age,
      rprof.esrf_on,
      mx.modality_name,
          CASE
              WHEN (pw.id > 0) THEN true
              ELSE false
          END AS on_worryboard,
      txrsd.name AS tx_status,
          CASE pr.type
              WHEN 'Renalware::PD::APDRegime'::text THEN 'APD'::text
              WHEN 'Renalware::PD::CAPDRegime'::text THEN 'CAPD'::text
              ELSE NULL::text
          END AS pd_type,
      ( SELECT date(e.date_time) AS date
             FROM (events e
               JOIN event_types et ON ((et.id = e.event_type_id)))
            WHERE (((et.slug)::text = 'pd_line_changes'::text) AND (e.patient_id = p.id) AND (e.deleted_at IS NULL))
            ORDER BY e.date_time DESC
           LIMIT 1) AS last_line_change_date,
      pesi.diagnosis_date AS last_esi_date,
      ppe.diagnosis_date AS last_peritonitis_date,
      ( SELECT cv2.bmi
             FROM clinic_visits cv2
            WHERE ((cv2.patient_id = p.id) AND (cv2.bmi > (0)::numeric))
            ORDER BY cv2.date DESC
           LIMIT 1) AS bmi,
      convert_to_float(((pa."values" -> 'HGB'::text) ->> 'result'::text), NULL::double precision) AS hgb,
      (((pa."values" -> 'HGB'::text) ->> 'observed_at'::text))::date AS hgb_date,
      convert_to_float(((pa."values" -> 'URE'::text) ->> 'result'::text), NULL::double precision) AS ure,
      (((pa."values" -> 'URE'::text) ->> 'observed_at'::text))::date AS ure_date,
      convert_to_float(((pa."values" -> 'CRE'::text) ->> 'result'::text), NULL::double precision) AS cre,
      (((pa."values" -> 'CRE'::text) ->> 'observed_at'::text))::date AS cre_date,
      convert_to_float(((pa."values" -> 'EGFR'::text) ->> 'result'::text), NULL::double precision) AS egfr,
      (((pa."values" -> 'POT'::text) ->> 'observed_at'::text))::date AS pot_date,
      convert_to_float(((pa."values" -> 'POT'::text) ->> 'result'::text), NULL::double precision) AS pot,
      (((named_nurses.family_name)::text || ', '::text) || (named_nurses.given_name)::text) AS named_nurse,
      (((named_consultants.family_name)::text || ', '::text) || (named_consultants.given_name)::text) AS named_consultant,
      h.name AS hospital_centre
     FROM (((((((((((((patients p
       LEFT JOIN patient_worries pw ON ((pw.patient_id = p.id)))
       LEFT JOIN pathology_current_observation_sets pa ON ((pa.patient_id = p.id)))
       LEFT JOIN renal_profiles rprof ON ((rprof.patient_id = p.id)))
       LEFT JOIN transplant_registrations txr ON ((txr.patient_id = p.id)))
       LEFT JOIN transplant_registration_statuses txrs ON (((txrs.registration_id = txr.id) AND (txrs.terminated_on IS NULL))))
       LEFT JOIN transplant_registration_status_descriptions txrsd ON ((txrsd.id = txrs.description_id)))
       LEFT JOIN pd_regimes pr ON (((pr.patient_id = p.id) AND (pr.start_date <= CURRENT_DATE) AND (pr.end_date IS NULL))))
       LEFT JOIN pd_exit_site_infections pesi ON ((pesi.patient_id = p.id)))
       LEFT JOIN pd_peritonitis_episodes ppe ON ((ppe.patient_id = p.id)))
       LEFT JOIN users named_nurses ON ((named_nurses.id = p.named_nurse_id)))
       LEFT JOIN users named_consultants ON ((named_consultants.id = p.named_consultant_id)))
       LEFT JOIN hospital_centres h ON ((h.id = p.hospital_centre_id)))
       JOIN patient_current_modalities mx ON (((mx.patient_id = p.id) AND ((mx.modality_code)::text = 'pd'::text))))
    ORDER BY p.id, pr.start_date DESC, pr.created_at DESC, pesi.diagnosis_date DESC, ppe.diagnosis_date DESC;
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
     FROM ((pathology_observations
       LEFT JOIN pathology_observation_requests ON ((pathology_observations.request_id = pathology_observation_requests.id)))
       LEFT JOIN pathology_observation_descriptions ON ((pathology_observations.description_id = pathology_observation_descriptions.id)))
    ORDER BY pathology_observation_requests.patient_id, pathology_observation_descriptions.id, pathology_observations.observed_at DESC;
  SQL
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
     FROM ((((medication_prescriptions mp
       FULL JOIN medication_prescription_terminations mpt ON ((mpt.prescription_id = mp.id)))
       JOIN drugs ON ((drugs.id = mp.drug_id)))
       FULL JOIN drug_types_drugs ON ((drug_types_drugs.drug_id = drugs.id)))
       FULL JOIN drug_types ON (((drug_types_drugs.drug_type_id = drug_types.id) AND ((mpt.terminated_on IS NULL) OR (mpt.terminated_on > now())))));
  SQL
  create_view "renalware.reporting_anaemia_audit", sql_definition: <<-SQL
      SELECT e1.modality_desc AS modality,
      count(e1.patient_id) AS patient_count,
      round(avg(e2.hgb), 2) AS avg_hgb,
      round((((count(e4.hgb_gt_eq_10))::numeric / GREATEST((count(e2.hgb))::numeric, 1.0)) * 100.0), 2) AS pct_hgb_gt_eq_10,
      round((((count(e5.hgb_gt_eq_11))::numeric / GREATEST((count(e2.hgb))::numeric, 1.0)) * 100.0), 2) AS pct_hgb_gt_eq_11,
      round((((count(e6.hgb_gt_eq_13))::numeric / GREATEST((count(e2.hgb))::numeric, 1.0)) * 100.0), 2) AS pct_hgb_gt_eq_13,
      round(avg(e3.fer), 2) AS avg_fer,
      round((((count(e7.fer_gt_eq_150))::numeric / GREATEST((count(e3.fer))::numeric, 1.0)) * 100.0), 2) AS pct_fer_gt_eq_150,
      (COALESCE(sum(immunosuppressants.ct), (0)::numeric))::integer AS count_epo,
      (COALESCE(sum(mircer.ct), (0)::numeric))::integer AS count_mircer,
      (COALESCE(sum(neo.ct), (0)::numeric))::integer AS count_neo,
      (COALESCE(sum(ara.ct), (0)::numeric))::integer AS count_ara
     FROM ((((((((((( SELECT p.id AS patient_id,
              md.name AS modality_desc,
              md.code AS modality_code
             FROM ((patients p
               JOIN modality_modalities m ON ((m.patient_id = p.id)))
               JOIN modality_descriptions md ON ((m.description_id = md.id)))
            WHERE ((m.ended_on IS NULL) OR (m.ended_on > CURRENT_TIMESTAMP))) e1
       FULL JOIN ( SELECT mcp.patient_id,
              count(DISTINCT mcp.drug_id) AS ct
             FROM medication_current_prescriptions mcp
            WHERE ((mcp.drug_type_code)::text = 'immunosuppressant'::text)
            GROUP BY mcp.patient_id) immunosuppressants ON ((e1.patient_id = immunosuppressants.patient_id)))
       FULL JOIN ( SELECT mcp.patient_id,
              count(DISTINCT mcp.drug_id) AS ct
             FROM medication_current_prescriptions mcp
            WHERE ((mcp.drug_name)::text ~~ 'Mircer%'::text)
            GROUP BY mcp.patient_id) mircer ON ((e1.patient_id = mircer.patient_id)))
       FULL JOIN ( SELECT mcp.patient_id,
              count(DISTINCT mcp.drug_id) AS ct
             FROM medication_current_prescriptions mcp
            WHERE ((mcp.drug_name)::text ~~ 'Neo%'::text)
            GROUP BY mcp.patient_id) neo ON ((e1.patient_id = neo.patient_id)))
       FULL JOIN ( SELECT mcp.patient_id,
              count(DISTINCT mcp.drug_id) AS ct
             FROM medication_current_prescriptions mcp
            WHERE ((mcp.drug_name)::text ~~ 'Ara%'::text)
            GROUP BY mcp.patient_id) ara ON ((e1.patient_id = ara.patient_id)))
       LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS hgb
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'HGB'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e2 ON (true))
       LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS fer
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'FER'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e3 ON (true))
       LEFT JOIN LATERAL ( SELECT e2.hgb AS hgb_gt_eq_10
            WHERE (e2.hgb >= (10)::numeric)) e4 ON (true))
       LEFT JOIN LATERAL ( SELECT e2.hgb AS hgb_gt_eq_11
            WHERE (e2.hgb >= (11)::numeric)) e5 ON (true))
       LEFT JOIN LATERAL ( SELECT e2.hgb AS hgb_gt_eq_13
            WHERE (e2.hgb >= (13)::numeric)) e6 ON (true))
       LEFT JOIN LATERAL ( SELECT e3.fer AS fer_gt_eq_150
            WHERE (e3.fer >= (150)::numeric)) e7 ON (true))
    WHERE ((e1.modality_code)::text = ANY ((ARRAY['hd'::character varying, 'pd'::character varying, 'transplant'::character varying, 'low_clearance'::character varying, 'nephrology'::character varying])::text[]))
    GROUP BY e1.modality_desc;
  SQL
  create_view "renalware.reporting_bone_audit", sql_definition: <<-SQL
      SELECT e1.modality_desc AS modality,
      count(e1.patient_id) AS patient_count,
      round(avg(e4.cca), 2) AS avg_cca,
      round((((count(e8.cca_2_1_to_2_4))::numeric / GREATEST((count(e4.cca))::numeric, 1.0)) * 100.0), 2) AS pct_cca_2_1_to_2_4,
      round((((count(e7.pth_gt_300))::numeric / GREATEST((count(e2.pth))::numeric, 1.0)) * 100.0), 2) AS pct_pth_gt_300,
      round((((count(e6.pth_gt_800))::numeric / GREATEST((count(e2.pth))::numeric, 1.0)) * 100.0), 2) AS pct_pth_gt_800_pct,
      round(avg(e3.phos), 2) AS avg_phos,
      max(e3.phos) AS max_phos,
      round((((count(e5.phos_lt_1_8))::numeric / GREATEST((count(e3.phos))::numeric, 1.0)) * 100.0), 2) AS pct_phos_lt_1_8
     FROM (((((((( SELECT p.id AS patient_id,
              md.name AS modality_desc,
              md.code AS modality_code
             FROM ((patients p
               JOIN modality_modalities m ON ((m.patient_id = p.id)))
               JOIN modality_descriptions md ON ((m.description_id = md.id)))) e1
       LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS pth
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'PTHI'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e2 ON (true))
       LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS phos
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'PHOS'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e3 ON (true))
       LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS cca
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'CCA'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e4 ON (true))
       LEFT JOIN LATERAL ( SELECT e3.phos AS phos_lt_1_8
            WHERE (e3.phos < 1.8)) e5 ON (true))
       LEFT JOIN LATERAL ( SELECT e2.pth AS pth_gt_800
            WHERE (e2.pth > (800)::numeric)) e6 ON (true))
       LEFT JOIN LATERAL ( SELECT e2.pth AS pth_gt_300
            WHERE (e2.pth > (300)::numeric)) e7 ON (true))
       LEFT JOIN LATERAL ( SELECT e4.cca AS cca_2_1_to_2_4
            WHERE ((e4.cca >= 2.1) AND (e4.cca <= 2.4))) e8 ON (true))
    WHERE ((e1.modality_code)::text = ANY ((ARRAY['hd'::character varying, 'pd'::character varying, 'transplant'::character varying, 'low_clearance'::character varying])::text[]))
    GROUP BY e1.modality_desc;
  SQL
  create_view "renalware.supportive_care_mdm_patients", sql_definition: <<-SQL
      SELECT p.id,
      p.secure_id,
      ((upper((p.family_name)::text) || ', '::text) || (p.given_name)::text) AS patient_name,
      p.nhs_number,
      p.local_patient_id AS hospital_numbers,
      p.sex,
      p.born_on,
      date_part('year'::text, age((p.born_on)::timestamp with time zone)) AS age,
      rprof.esrf_on,
      mx.modality_name,
          CASE
              WHEN (pw.id > 0) THEN true
              ELSE false
          END AS on_worryboard,
      ( SELECT cv2.bmi
             FROM clinic_visits cv2
            WHERE ((cv2.patient_id = p.id) AND (cv2.bmi > (0)::numeric))
            ORDER BY cv2.date DESC
           LIMIT 1) AS bmi,
      txrsd.name AS tx_status,
      convert_to_float(((pa."values" -> 'HGB'::text) ->> 'result'::text), NULL::double precision) AS hgb,
      (((pa."values" -> 'HGB'::text) ->> 'observed_at'::text))::date AS hgb_date,
      convert_to_float(((pa."values" -> 'URE'::text) ->> 'result'::text), NULL::double precision) AS ure,
      (((pa."values" -> 'URE'::text) ->> 'observed_at'::text))::date AS ure_date,
      convert_to_float(((pa."values" -> 'CRE'::text) ->> 'result'::text), NULL::double precision) AS cre,
      (((pa."values" -> 'CRE'::text) ->> 'observed_at'::text))::date AS cre_date,
      convert_to_float(((pa."values" -> 'EGFR'::text) ->> 'result'::text), NULL::double precision) AS egfr,
      (((named_nurses.family_name)::text || ', '::text) || (named_nurses.given_name)::text) AS named_nurse,
      (((named_consultants.family_name)::text || ', '::text) || (named_consultants.given_name)::text) AS named_consultant,
      h.name AS hospital_centre
     FROM ((((((((((patients p
       LEFT JOIN patient_worries pw ON ((pw.patient_id = p.id)))
       LEFT JOIN pathology_current_observation_sets pa ON ((pa.patient_id = p.id)))
       LEFT JOIN renal_profiles rprof ON ((rprof.patient_id = p.id)))
       LEFT JOIN transplant_registrations txr ON ((txr.patient_id = p.id)))
       LEFT JOIN transplant_registration_statuses txrs ON (((txrs.registration_id = txr.id) AND (txrs.terminated_on IS NULL))))
       LEFT JOIN transplant_registration_status_descriptions txrsd ON ((txrsd.id = txrs.description_id)))
       LEFT JOIN users named_nurses ON ((named_nurses.id = p.named_nurse_id)))
       LEFT JOIN users named_consultants ON ((named_consultants.id = p.named_consultant_id)))
       LEFT JOIN hospital_centres h ON ((h.id = p.hospital_centre_id)))
       JOIN patient_current_modalities mx ON (((mx.patient_id = p.id) AND ((mx.modality_code)::text = 'supportive_care'::text))));
  SQL
  create_view "renalware.transplant_mdm_patients", sql_definition: <<-SQL
      SELECT p.id,
      p.secure_id,
      ((upper((p.family_name)::text) || ', '::text) || (p.given_name)::text) AS patient_name,
      p.nhs_number,
      p.local_patient_id AS hospital_numbers,
      p.sex,
      p.born_on,
      rprof.esrf_on,
      latest_op.performed_on AS last_operation_date,
      (date_part('year'::text, age((p.born_on)::timestamp with time zone)))::integer AS age,
      mx.modality_name,
          CASE
              WHEN (pw.id > 0) THEN 'Y'::text
              ELSE 'N'::text
          END AS on_worryboard,
      ( SELECT cv2.bmi
             FROM clinic_visits cv2
            WHERE ((cv2.patient_id = p.id) AND (cv2.bmi > (0)::numeric))
            ORDER BY cv2.date DESC
           LIMIT 1) AS bmi,
          CASE
              WHEN (latest_op.performed_on >= (now() - 'P3M'::interval)) THEN true
              ELSE false
          END AS tx_in_past_3m,
          CASE
              WHEN (latest_op.performed_on >= (now() - 'P1Y'::interval)) THEN true
              ELSE false
          END AS tx_in_past_12m,
      txrsd.name AS tx_status,
      convert_to_float(((pa."values" -> 'HGB'::text) ->> 'result'::text), NULL::double precision) AS hgb,
      (((pa."values" -> 'HGB'::text) ->> 'observed_at'::text))::date AS hgb_date,
      convert_to_float(((pa."values" -> 'URE'::text) ->> 'result'::text), NULL::double precision) AS ure,
      (((pa."values" -> 'URE'::text) ->> 'observed_at'::text))::date AS ure_date,
      convert_to_float(((pa."values" -> 'CRE'::text) ->> 'result'::text), NULL::double precision) AS cre,
      (((pa."values" -> 'CRE'::text) ->> 'observed_at'::text))::date AS cre_date,
      convert_to_float(((pa."values" -> 'EGFR'::text) ->> 'result'::text), NULL::double precision) AS egfr_on,
      (((named_nurses.family_name)::text || ', '::text) || (named_nurses.given_name)::text) AS named_nurse,
      (((named_consultants.family_name)::text || ', '::text) || (named_consultants.given_name)::text) AS named_consultant,
      h.name AS hospital_centre
     FROM (((((((((((patients p
       JOIN patient_current_modalities mx ON (((mx.patient_id = p.id) AND ((mx.modality_code)::text = 'transplant'::text))))
       LEFT JOIN pathology_current_observation_sets pa ON ((pa.patient_id = p.id)))
       LEFT JOIN patient_worries pw ON ((pw.patient_id = p.id)))
       LEFT JOIN transplant_registrations txr ON ((txr.patient_id = p.id)))
       LEFT JOIN transplant_registration_statuses txrs ON (((txrs.registration_id = txr.id) AND (txrs.terminated_on IS NULL))))
       LEFT JOIN transplant_registration_status_descriptions txrsd ON ((txrsd.id = txrs.description_id)))
       LEFT JOIN renal_profiles rprof ON ((rprof.patient_id = p.id)))
       LEFT JOIN users named_nurses ON ((named_nurses.id = p.named_nurse_id)))
       LEFT JOIN users named_consultants ON ((named_consultants.id = p.named_consultant_id)))
       LEFT JOIN hospital_centres h ON ((h.id = p.hospital_centre_id)))
       LEFT JOIN ( SELECT DISTINCT ON (transplant_recipient_operations.patient_id) transplant_recipient_operations.id,
              transplant_recipient_operations.patient_id,
              transplant_recipient_operations.performed_on,
              transplant_recipient_operations.theatre_case_start_time,
              transplant_recipient_operations.donor_kidney_removed_from_ice_at,
              transplant_recipient_operations.operation_type,
              transplant_recipient_operations.hospital_centre_id,
              transplant_recipient_operations.kidney_perfused_with_blood_at,
              transplant_recipient_operations.cold_ischaemic_time,
              transplant_recipient_operations.warm_ischaemic_time,
              transplant_recipient_operations.notes,
              transplant_recipient_operations.document,
              transplant_recipient_operations.created_at,
              transplant_recipient_operations.updated_at
             FROM transplant_recipient_operations
            ORDER BY transplant_recipient_operations.patient_id, transplant_recipient_operations.performed_on DESC) latest_op ON ((latest_op.patient_id = p.id)));
  SQL
  create_view "renalware.dietetic_mdm_patients", materialized: true, sql_definition: <<-SQL
      WITH latest_dietetic_clinic_visits AS (
           SELECT DISTINCT ON (clinic_visits.patient_id) clinic_visits.date,
              clinic_visits.patient_id,
              clinic_visits.created_by_id,
              clinic_visits.document,
              clinic_visits.weight,
              clinic_visits.bmi
             FROM clinic_visits
            WHERE ((clinic_visits.type)::text = 'Renalware::Dietetics::ClinicVisit'::text)
            ORDER BY clinic_visits.patient_id, clinic_visits.date DESC, clinic_visits.created_at DESC
          ), latest_dry_weights AS (
           SELECT DISTINCT ON (cdw.patient_id) cdw.id,
              cdw.patient_id,
              cdw.weight
             FROM clinical_dry_weights cdw
            ORDER BY cdw.patient_id, cdw.created_at DESC
          )
   SELECT p.id,
      p.secure_id,
      ((upper((p.family_name)::text) || ', '::text) || (p.given_name)::text) AS patient_name,
      (((named_consultant_user.family_name)::text || ', '::text) || (named_consultant_user.given_name)::text) AS consultant_name,
      p.local_patient_id AS hospital_numbers,
      p.sex,
      p.born_on,
      md.name AS modality_name,
      latest_dietetic_clinic_visits.bmi,
      (((clinic_visit_users.family_name)::text || ', '::text) || (clinic_visit_users.given_name)::text) AS dietician_name,
      convert_to_float(((pathology."values" -> 'POT'::text) ->> 'result'::text), NULL::double precision) AS pot,
      convert_to_float(((pathology."values" -> 'PHOS'::text) ->> 'result'::text), NULL::double precision) AS phos,
      convert_to_float(((pathology."values" -> 'PTH'::text) ->> 'result'::text), NULL::double precision) AS pth,
      convert_to_float(((pathology."values" -> 'ALB'::text) ->> 'result'::text), NULL::double precision) AS alb,
      convert_to_float(((pathology."values" -> 'URR'::text) ->> 'result'::text), NULL::double precision) AS urr,
      latest_dietetic_clinic_visits.date AS clinic_visit_date,
      ((latest_dietetic_clinic_visits.document ->> 'next_review_on'::text))::date AS next_review_on,
      translate(initcap((latest_dietetic_clinic_visits.document ->> 'assessment_type'::text)), '_'::text, ' '::text) AS assessment_type,
      translate(initcap((latest_dietetic_clinic_visits.document ->> 'visit_type'::text)), '_'::text, ' '::text) AS visit_type,
      ((latest_dietetic_clinic_visits.document ->> 'weight_change'::text) || '%'::text) AS weight_change,
      latest_dietetic_clinic_visits.weight AS current_weight,
      latest_dry_weights.weight AS dry_weight,
          CASE
              WHEN (((latest_dietetic_clinic_visits.document ->> 'next_review_on'::text))::date < now()) THEN 'overdue'::text
              WHEN (((latest_dietetic_clinic_visits.document ->> 'next_review_on'::text))::date < (now() + 'P1M'::interval)) THEN 'in 1 months'::text
              WHEN (((latest_dietetic_clinic_visits.document ->> 'next_review_on'::text))::date < (now() + 'P3M'::interval)) THEN 'in 3 months'::text
              WHEN (((latest_dietetic_clinic_visits.document ->> 'next_review_on'::text))::date < (now() + 'P6M'::interval)) THEN 'in 6 months'::text
              ELSE NULL::text
          END AS outstanding_dietetic_visit,
      hospital_centre.name AS hospital_centre,
          CASE
              WHEN (pw.id > 0) THEN true
              ELSE false
          END AS on_worryboard
     FROM (((((((((latest_dietetic_clinic_visits
       JOIN patients p ON ((p.id = latest_dietetic_clinic_visits.patient_id)))
       LEFT JOIN latest_dry_weights ON ((latest_dry_weights.patient_id = p.id)))
       JOIN users clinic_visit_users ON ((clinic_visit_users.id = latest_dietetic_clinic_visits.created_by_id)))
       LEFT JOIN users named_consultant_user ON ((named_consultant_user.id = p.named_consultant_id)))
       LEFT JOIN patient_worries pw ON ((pw.patient_id = p.id)))
       LEFT JOIN pathology_current_observation_sets pathology ON ((pathology.patient_id = p.id)))
       LEFT JOIN modality_modalities mm ON (((mm.patient_id = p.id) AND (mm.ended_on IS NULL))))
       LEFT JOIN modality_descriptions md ON ((md.id = mm.description_id)))
       LEFT JOIN hospital_centres hospital_centre ON ((hospital_centre.id = p.hospital_centre_id)))
    WHERE ((md.name)::text <> 'death'::text)
    ORDER BY latest_dietetic_clinic_visits.date DESC;
  SQL
  create_view "renalware.drug_prescribable_drugs", materialized: true, sql_definition: <<-SQL
      SELECT drug_id,
      trade_family_id,
      compound_id,
      drug_name,
      trade_family_name,
      compound_name
     FROM ( SELECT drugs.id AS drug_id,
              NULL::bigint AS trade_family_id,
              (drugs.id)::text AS compound_id,
              drugs.name AS drug_name,
              NULL::character varying AS trade_family_name,
              drugs.name AS compound_name
             FROM drugs
            WHERE ((drugs.deleted_at IS NULL) AND (drugs.inactive = false))
          UNION
           SELECT drugs.id,
              drug_trade_families.id,
              ((((drugs.id)::character varying)::text || ':'::text) || ((drug_trade_families.id)::character varying)::text),
              drugs.name,
              drug_trade_families.name,
              ((((drugs.name)::text || ' ('::text) || (drug_trade_families.name)::text) || ')'::text)
             FROM ((drugs
               JOIN drug_trade_family_classifications ON ((drug_trade_family_classifications.drug_id = drugs.id)))
               JOIN drug_trade_families ON (((drug_trade_families.id = drug_trade_family_classifications.trade_family_id) AND (drug_trade_family_classifications.enabled = true))))
            WHERE ((drugs.deleted_at IS NULL) AND (drugs.inactive = false))) t
    ORDER BY compound_name;
  SQL
  add_index "renalware.drug_prescribable_drugs", ["compound_id"], name: "index_drug_prescribable_drugs_on_compound_id", unique: true, comment: "Unique idx on this materialized view enables us to refresh concurrently"
  add_index "renalware.drug_prescribable_drugs", ["compound_name"], name: "index_drug_prescribable_drugs_on_compound_name", opclass: :gist_trgm_ops, using: :gist
  add_index "renalware.drug_prescribable_drugs", ["drug_id"], name: "index_drug_prescribable_drugs_on_drug_id"

  create_view "renalware.duplicate_nhs_numbers", sql_definition: <<-SQL
      SELECT p.secure_id,
      p.nhs_number,
      ((upper((p.family_name)::text) || ', '::text) || (p.given_name)::text) AS patient_name,
      p.created_at,
      p.updated_at
     FROM (patients p
       JOIN ( SELECT patients.nhs_number,
              count(*) AS count
             FROM patients
            WHERE ((patients.nhs_number)::text <> ''::text)
            GROUP BY patients.nhs_number
           HAVING (count(*) > 1)) t USING (nhs_number));
  SQL
  create_view "renalware.hd_diary_matrix", sql_definition: <<-SQL
      WITH hd_empty_diary_matrix AS (
           SELECT EXTRACT(year FROM the_date.the_date) AS year,
              EXTRACT(week FROM the_date.the_date) AS week_number,
              h.id AS hospital_unit_id,
              s.id AS station_id,
              a.day_of_week,
              period.id AS diurnal_period_code_id
             FROM ((((generate_series((now() - 'P1Y'::interval), (now() - 'P7D'::interval), 'P7D'::interval) the_date(the_date)
               CROSS JOIN hospital_units h)
               CROSS JOIN hd_stations s)
               CROSS JOIN ( SELECT generate_series(1, 7) AS day_of_week) a)
               CROSS JOIN hd_diurnal_period_codes period)
            WHERE (h.is_hd_site = true)
            ORDER BY (EXTRACT(year FROM the_date.the_date)), (EXTRACT(week FROM the_date.the_date)), h.id, s.id, a.day_of_week, period.id
          )
   SELECT m.year,
      m.week_number,
      m.hospital_unit_id,
      m.station_id,
      m.day_of_week,
      m.diurnal_period_code_id,
      wd.id AS weekly_diary_id,
      md.id AS master_diary_id,
      ws.id AS weekly_slot_id,
      ms.id AS master_slot_id,
      COALESCE(ws.patient_id, ms.patient_id) AS patient_id,
      ms.deleted_at,
      ms.created_by_id AS master_slot_created_by_id,
      ms.updated_by_id AS master_slot_updated_by_id,
      (ms.created_at)::date AS master_slot_created_at,
      (ms.updated_at)::date AS master_slot_updated_at,
      to_date((((((wd.year)::text || '-'::text) || (wd.week_number)::text) || '-'::text) || (ms.day_of_week)::text), 'iyyy-iw-ID'::text) AS slot_date
     FROM ((((hd_empty_diary_matrix m
       LEFT JOIN hd_diaries wd ON (((wd.hospital_unit_id = m.hospital_unit_id) AND ((wd.year)::numeric = m.year) AND ((wd.week_number)::numeric = m.week_number) AND (wd.master = false))))
       LEFT JOIN hd_diaries md ON (((md.hospital_unit_id = m.hospital_unit_id) AND (md.master = true))))
       LEFT JOIN hd_diary_slots ws ON (((ws.diary_id = wd.id) AND (ws.station_id = m.station_id) AND (ws.day_of_week = m.day_of_week) AND (ws.diurnal_period_code_id = m.diurnal_period_code_id))))
       LEFT JOIN hd_diary_slots ms ON (((ms.diary_id = md.id) AND (ms.station_id = m.station_id) AND (ms.day_of_week = m.day_of_week) AND (ms.diurnal_period_code_id = m.diurnal_period_code_id))));
  SQL
  create_view "renalware.hd_grouped_transmission_logs", sql_definition: <<-SQL
      WITH RECURSIVE parent_child_logs(parent_id, id, uuid, level) AS (
           SELECT t.parent_id,
              t.id,
              t.uuid,
              1 AS level
             FROM hd_transmission_logs t
            WHERE (t.parent_id IS NULL)
          UNION ALL
           SELECT parent_child_logs.id,
              t.id,
              t.uuid,
              (parent_child_logs.level + 1)
             FROM (hd_transmission_logs t
               JOIN parent_child_logs ON ((t.parent_id = parent_child_logs.id)))
          ), ordered_parent_child_logs AS (
           SELECT parent_child_logs.id,
              parent_child_logs.parent_id,
              parent_child_logs.level,
              max(parent_child_logs.level) OVER (PARTITION BY parent_child_logs.id) AS maxlevel
             FROM parent_child_logs
          )
   SELECT h.id,
      h.parent_id,
      h.direction,
      h.format,
      h.status,
      h.hd_provider_unit_id,
      h.patient_id,
      h.filepath,
      h.payload,
      h.result,
      h.error_messages,
      h.transmitted_at,
      h.created_at,
      h.updated_at,
      h.external_session_id,
      h.session_id,
      h.uuid,
      h.warnings
     FROM (ordered_parent_child_logs
       JOIN hd_transmission_logs h ON ((h.id = ordered_parent_child_logs.id)))
    WHERE (ordered_parent_child_logs.level = ordered_parent_child_logs.maxlevel)
    ORDER BY h.id, h.updated_at;
  SQL
  create_view "renalware.hd_profile_for_modalities", sql_definition: <<-SQL
      WITH hd_modalities AS (
           SELECT m_1.patient_id,
              m_1.id AS modality_id,
              m_1.started_on,
              m_1.ended_on
             FROM (modality_modalities m_1
               JOIN modality_descriptions md ON ((md.id = m_1.description_id)))
            WHERE ((md.name)::text = 'HD'::text)
          ), distinct_hd_profiles AS (
           SELECT DISTINCT ON (hd_profiles.patient_id, ((hd_profiles.created_at)::date)) hd_profiles.id AS hd_profile_id,
              hd_profiles.patient_id,
              (COALESCE((hd_profiles.prescribed_on)::timestamp without time zone, hd_profiles.created_at))::date AS effective_prescribed_on,
              hd_profiles.prescribed_on,
              (hd_profiles.created_at)::date AS created_on,
              hd_profiles.created_at,
              hd_profiles.deactivated_at,
              hd_profiles.active
             FROM hd_profiles
            ORDER BY hd_profiles.patient_id, ((hd_profiles.created_at)::date), hd_profiles.created_at DESC
          )
   SELECT patient_id,
      modality_id,
      started_on,
      ended_on,
      ( SELECT hp.hd_profile_id
             FROM distinct_hd_profiles hp
            WHERE ((hp.patient_id = m.patient_id) AND ((hp.deactivated_at IS NULL) OR (hp.deactivated_at > m.started_on)))
            ORDER BY hp.created_at
           LIMIT 1) AS hd_profile_id
     FROM hd_modalities m;
  SQL
  create_view "renalware.hd_schedule_definition_filters", sql_definition: <<-SQL
      SELECT ids,
      ((days_text || ' '::text) || upper((dirunal_code)::text)) AS days
     FROM ( SELECT array_agg(s1.id) AS ids,
              0 AS dirunal_order,
              s1.days_text,
              ''::character varying AS dirunal_code
             FROM hd_schedule_definitions s1
            GROUP BY s1.days_text
          UNION ALL
           SELECT intset((s2.id)::integer) AS intset,
              hdpc.sort_order,
              s2.days_text,
              hdpc.code
             FROM (hd_schedule_definitions s2
               JOIN hd_diurnal_period_codes hdpc ON ((s2.diurnal_period_id = hdpc.id)))) filter
    ORDER BY days_text, dirunal_order;
  SQL
  create_view "renalware.letter_mesh_letters", sql_definition: <<-SQL
      SELECT ll.id,
      ll.approved_at,
      ll.completed_at,
      ll.gp_send_status,
      ll.type AS letter_type,
      (((p.family_name)::text || ', '::text) || (p.given_name)::text) AS patient_name,
      p.secure_id AS patient_secure_id,
      p.nhs_number AS patient_nhs_number,
      practice.code AS patient_practice_ods_code,
      lmt.sent_to_practice_ods_code,
      ((COALESCE(practice.code, ''::character varying))::text <> (COALESCE(lmt.sent_to_practice_ods_code, ''::character varying))::text) AS ods_code_mismatch,
      author.id AS author_id,
      (((author.family_name)::text || ', '::text) || (author.given_name)::text) AS author_name,
      typist.id AS typist_id,
      (((typist.family_name)::text || ', '::text) || (typist.given_name)::text) AS typist_name,
      lmt.id AS transmission_id,
      send_operation.mesh_response_error_code AS send_operation_mesh_response_error_code,
      send_operation.mesh_response_error_description AS send_operation_mesh_response_error_description,
      bus_download_operation.itk3_operation_outcome_code AS bus_download_operation_itk3_operation_outcome_code,
      bus_download_operation.itk3_operation_outcome_description AS bus_download_operation_itk3_operation_outcome_description,
      inf_download_operation.itk3_operation_outcome_code AS inf_download_operation_itk3_operation_outcome_code,
      inf_download_operation.itk3_operation_outcome_description AS inf_download_operation_itk3_operation_outcome_description
     FROM ((((((((letter_mesh_transmissions lmt
       JOIN letter_letters ll ON ((ll.id = lmt.letter_id)))
       JOIN patients p ON ((p.id = ll.patient_id)))
       JOIN users author ON ((author.id = ll.author_id)))
       JOIN users typist ON ((typist.id = ll.created_by_id)))
       LEFT JOIN patient_practices practice ON ((practice.id = p.practice_id)))
       LEFT JOIN LATERAL ( SELECT lmo.id,
              lmo.uuid,
              lmo.direction,
              lmo.action,
              lmo.transmission_id,
              lmo.parent_id,
              lmo.mesh_message_id,
              lmo.request_headers,
              lmo.response_headers,
              lmo.payload,
              lmo.response_body,
              lmo.unhandled_error,
              lmo.http_response_code,
              lmo.http_response_description,
              lmo.http_error,
              lmo.mesh_response_error_code,
              lmo.mesh_response_error_description,
              lmo.mesh_response_error_event,
              lmo.mesh_error,
              lmo.itk3_response_type,
              lmo.itk3_response_code,
              lmo.itk3_operation_outcome_type,
              lmo.itk3_operation_outcome_severity,
              lmo.itk3_operation_outcome_code,
              lmo.itk3_operation_outcome_description,
              lmo.itk3_error,
              lmo.created_at,
              lmo.updated_at
             FROM letter_mesh_operations lmo
            WHERE (lmo.action = 'send_message'::enum_mesh_api_action)) send_operation ON ((send_operation.transmission_id = lmt.id)))
       LEFT JOIN LATERAL ( SELECT lmo.id,
              lmo.uuid,
              lmo.direction,
              lmo.action,
              lmo.transmission_id,
              lmo.parent_id,
              lmo.mesh_message_id,
              lmo.request_headers,
              lmo.response_headers,
              lmo.payload,
              lmo.response_body,
              lmo.unhandled_error,
              lmo.http_response_code,
              lmo.http_response_description,
              lmo.http_error,
              lmo.mesh_response_error_code,
              lmo.mesh_response_error_description,
              lmo.mesh_response_error_event,
              lmo.mesh_error,
              lmo.itk3_response_type,
              lmo.itk3_response_code,
              lmo.itk3_operation_outcome_type,
              lmo.itk3_operation_outcome_severity,
              lmo.itk3_operation_outcome_code,
              lmo.itk3_operation_outcome_description,
              lmo.itk3_error,
              lmo.created_at,
              lmo.updated_at
             FROM letter_mesh_operations lmo
            WHERE (lmo.itk3_response_type = 'inf'::enum_mesh_itk3_response_type)) inf_download_operation ON ((inf_download_operation.transmission_id = lmt.id)))
       LEFT JOIN LATERAL ( SELECT lmo.id,
              lmo.uuid,
              lmo.direction,
              lmo.action,
              lmo.transmission_id,
              lmo.parent_id,
              lmo.mesh_message_id,
              lmo.request_headers,
              lmo.response_headers,
              lmo.payload,
              lmo.response_body,
              lmo.unhandled_error,
              lmo.http_response_code,
              lmo.http_response_description,
              lmo.http_error,
              lmo.mesh_response_error_code,
              lmo.mesh_response_error_description,
              lmo.mesh_response_error_event,
              lmo.mesh_error,
              lmo.itk3_response_type,
              lmo.itk3_response_code,
              lmo.itk3_operation_outcome_type,
              lmo.itk3_operation_outcome_severity,
              lmo.itk3_operation_outcome_code,
              lmo.itk3_operation_outcome_description,
              lmo.itk3_error,
              lmo.created_at,
              lmo.updated_at
             FROM letter_mesh_operations lmo
            WHERE (lmo.itk3_response_type = 'bus'::enum_mesh_itk3_response_type)) bus_download_operation ON ((bus_download_operation.transmission_id = lmt.id)));
  SQL
  create_view "renalware.pathology_observation_digests", sql_definition: <<-SQL
      SELECT obs_req.patient_id,
      (obs.observed_at)::date AS observed_on,
      jsonb_object_agg(obs_desc.code, obs.result) AS results
     FROM ((pathology_observations obs
       JOIN pathology_observation_requests obs_req ON ((obs.request_id = obs_req.id)))
       JOIN pathology_observation_descriptions obs_desc ON ((obs.description_id = obs_desc.id)))
    GROUP BY obs_req.patient_id, ((obs.observed_at)::date)
    ORDER BY obs_req.patient_id, ((obs.observed_at)::date) DESC;
  SQL
  create_view "renalware.pathology_observations_grouped_by_date", sql_definition: <<-SQL
      SELECT obr.patient_id,
      (((obs.observed_at AT TIME ZONE 'UTC'::text) AT TIME ZONE 'Europe/London'::text))::date AS observed_at,
      jsonb_object_agg(pod.code, ARRAY[obs.result, (obs.comment)::character varying] ORDER BY obs.observed_at) AS results,
      pcg2.name AS "group"
     FROM ((((pathology_observations obs
       JOIN pathology_observation_requests obr ON ((obs.request_id = obr.id)))
       JOIN pathology_observation_descriptions pod ON ((obs.description_id = pod.id)))
       JOIN pathology_code_group_memberships pcgm2 ON ((pcgm2.observation_description_id = pod.id)))
       JOIN pathology_code_groups pcg2 ON ((pcg2.id = pcgm2.code_group_id)))
    GROUP BY pcg2.name, obr.patient_id, ((((obs.observed_at AT TIME ZONE 'UTC'::text) AT TIME ZONE 'Europe/London'::text))::date)
    ORDER BY obr.patient_id, pcg2.name, ((((obs.observed_at AT TIME ZONE 'UTC'::text) AT TIME ZONE 'Europe/London'::text))::date) DESC;
  SQL
  create_view "renalware.patient_summaries", sql_definition: <<-SQL
      SELECT id AS patient_id,
      ( SELECT count(*) AS count
             FROM events
            WHERE ((events.patient_id = patients.id) AND (events.deleted_at IS NULL))) AS events_count,
      ( SELECT count(*) AS count
             FROM clinic_visits
            WHERE (clinic_visits.patient_id = patients.id)) AS clinic_visits_count,
      ( SELECT count(*) AS count
             FROM letter_letters
            WHERE (letter_letters.patient_id = patients.id)) AS letters_count,
      ( SELECT count(*) AS count
             FROM modality_modalities
            WHERE (modality_modalities.patient_id = patients.id)) AS modalities_count,
      ( SELECT count(*) AS count
             FROM problem_problems
            WHERE ((problem_problems.deleted_at IS NULL) AND (problem_problems.patient_id = patients.id))) AS problems_count,
      ( SELECT count(*) AS count
             FROM pathology_observation_requests
            WHERE (pathology_observation_requests.patient_id = patients.id)) AS observation_requests_count,
      ( SELECT count(*) AS count
             FROM (medication_prescriptions p
               FULL JOIN medication_prescription_terminations pt ON ((pt.prescription_id = p.id)))
            WHERE ((p.patient_id = patients.id) AND ((pt.terminated_on IS NULL) OR (pt.terminated_on > CURRENT_TIMESTAMP)))) AS prescriptions_count,
      ( SELECT count(*) AS count
             FROM letter_contacts
            WHERE (letter_contacts.patient_id = patients.id)) AS contacts_count,
      ( SELECT count(*) AS count
             FROM transplant_recipient_operations
            WHERE (transplant_recipient_operations.patient_id = patients.id)) AS recipient_operations_count,
      ( SELECT count(*) AS count
             FROM admission_admissions
            WHERE (admission_admissions.patient_id = patients.id)) AS admissions_count,
      ( SELECT count(*) AS count
             FROM patient_attachments
            WHERE ((patient_attachments.patient_id = patients.id) AND (patient_attachments.deleted_at IS NULL))) AS attachments_count
     FROM patients;
  SQL
  create_view "renalware.pd_regime_for_modalities", sql_definition: <<-SQL
      WITH pd_modalities AS (
           SELECT m_1.patient_id,
              m_1.id AS modality_id,
              m_1.started_on,
              m_1.ended_on
             FROM (modality_modalities m_1
               JOIN modality_descriptions md ON ((md.id = m_1.description_id)))
            WHERE ((md.name)::text = 'PD'::text)
          ), distinct_pd_regimes AS (
           SELECT DISTINCT ON (pd_regimes.patient_id, pd_regimes.start_date) pd_regimes.id AS pd_regime_id,
              pd_regimes.patient_id,
              pd_regimes.start_date,
              pd_regimes.end_date,
              pd_regimes.created_at
             FROM pd_regimes
            ORDER BY pd_regimes.patient_id, pd_regimes.start_date, pd_regimes.created_at DESC
          )
   SELECT patient_id,
      modality_id,
      started_on,
      ended_on,
      ( SELECT pdr.pd_regime_id
             FROM distinct_pd_regimes pdr
            WHERE ((pdr.patient_id = m.patient_id) AND ((pdr.end_date IS NULL) OR (pdr.end_date > m.started_on)))
            ORDER BY pdr.created_at
           LIMIT 1) AS pd_regime_id
     FROM pd_modalities m
    ORDER BY patient_id;
  SQL
  create_view "renalware.reporting_daily_letters", sql_definition: <<-SQL
      SELECT ( SELECT count(*) AS count
             FROM letter_letters
            WHERE ((letter_letters.created_at)::date = (now())::date)) AS letters_created_today,
      ( SELECT count(*) AS count
             FROM letter_letters
            WHERE ((letter_letters.completed_at)::date = (now())::date)) AS letters_printed_today,
      ( SELECT count(*) AS count
             FROM letter_letters
            WHERE (((letter_letters.type)::text = 'Renalware::Letters::Letter::Draft'::text) AND (letter_letters.created_at < (CURRENT_DATE - 'P14D'::interval)))) AS draft_letters_older_than_14_days;
  SQL
  create_view "renalware.reporting_daily_ukrdc", sql_definition: <<-SQL
      SELECT ( SELECT count(*) AS count
             FROM patients
            WHERE ((patients.sent_to_ukrdc_at)::date = CURRENT_DATE)) AS patients_sent_to_ukrdc_today;
  SQL
  create_view "renalware.reporting_hd_blood_pressures_audit", materialized: true, sql_definition: <<-SQL
      WITH blood_pressures AS (
           SELECT hd_sessions.id AS session_id,
              patients.id AS patient_id,
              hd_sessions.hospital_unit_id,
              (((hd_sessions.document -> 'observations_before'::text) -> 'blood_pressure'::text) ->> 'systolic'::text) AS systolic_pre,
              (((hd_sessions.document -> 'observations_before'::text) -> 'blood_pressure'::text) ->> 'diastolic'::text) AS diastolic_pre,
              (((hd_sessions.document -> 'observations_after'::text) -> 'blood_pressure'::text) ->> 'systolic'::text) AS systolic_post,
              (((hd_sessions.document -> 'observations_after'::text) -> 'blood_pressure'::text) ->> 'diastolic'::text) AS diastolic_post
             FROM (hd_sessions
               JOIN patients ON ((patients.id = hd_sessions.patient_id)))
            WHERE ((hd_sessions.signed_off_at IS NOT NULL) AND (hd_sessions.deleted_at IS NULL))
          ), some_other_derived_table_variable AS (
           SELECT 1 AS "?column?"
             FROM blood_pressures blood_pressures_1
          )
   SELECT hu.name AS hospital_unit_name,
      round(avg((blood_pressures.systolic_pre)::integer)) AS systolic_pre_avg,
      round(avg((blood_pressures.diastolic_pre)::integer)) AS diastolic_pre_avg,
      round(avg((blood_pressures.systolic_post)::integer)) AS systolic_post_avg,
      round(avg((blood_pressures.diastolic_post)::integer)) AS distolic_post_avg
     FROM (blood_pressures
       JOIN hospital_units hu ON ((hu.id = blood_pressures.hospital_unit_id)))
    GROUP BY hu.name;
  SQL
  add_index "renalware.reporting_hd_blood_pressures_audit", ["hospital_unit_name"], name: "index_reporting_hd_blood_pressures_audit_on_hospital_unit_name", unique: true

  create_view "renalware.reporting_hd_overall_audit", materialized: true, sql_definition: <<-SQL
      WITH fistula_or_graft_access_types AS (
           SELECT access_types.id
             FROM access_types
            WHERE (((access_types.name)::text ~~* '%fistula%'::text) OR ((access_types.name)::text ~~* '%graft%'::text))
          ), patients_w_fistula_or_graft AS (
           SELECT access_profiles.patient_id
             FROM access_profiles
            WHERE (access_profiles.type_id IN ( SELECT fistula_or_graft_access_types.id
                     FROM fistula_or_graft_access_types))
          ), stats AS (
           SELECT s.patient_id,
              s.hospital_unit_id,
              s.month,
              s.year,
              s.session_count,
              s.number_of_missed_sessions,
              s.number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct,
              (EXISTS ( SELECT x.patient_id
                     FROM patients_w_fistula_or_graft x
                    WHERE (x.patient_id = s.patient_id))) AS has_fistula_or_graft,
              ((((s.number_of_missed_sessions)::double precision / NULLIF((s.session_count)::double precision, (0)::double precision)) * (100.0)::double precision) > (10.0)::double precision) AS missed_sessions_gt_10_pct,
              (s.dialysis_minutes_shortfall)::double precision AS dialysis_minutes_shortfall,
              (convert_to_float(((s.pathology_snapshot -> 'HGB'::text) ->> 'result'::text)) > (100)::double precision) AS hgb_gt_100,
              (convert_to_float(((s.pathology_snapshot -> 'HGB'::text) ->> 'result'::text)) > (130)::double precision) AS hgb_gt_130,
              (convert_to_float(((s.pathology_snapshot -> 'PTHI'::text) ->> 'result'::text)) < (300)::double precision) AS pth_lt_300,
              (convert_to_float(((s.pathology_snapshot -> 'URR'::text) ->> 'result'::text)) > (64)::double precision) AS urr_gt_64,
              (convert_to_float(((s.pathology_snapshot -> 'URR'::text) ->> 'result'::text)) > (69)::double precision) AS urr_gt_69,
              (convert_to_float(((s.pathology_snapshot -> 'PHOS'::text) ->> 'result'::text)) < (1.8)::double precision) AS phos_lt_1_8
             FROM hd_patient_statistics s
            WHERE (s.rolling IS NULL)
          )
   SELECT hu.name,
      stats.year,
      stats.month,
      count(*) AS patient_count,
      round((avg(stats.dialysis_minutes_shortfall))::numeric, 2) AS avg_missed_hd_time,
      round(avg(stats.number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct), 2) AS pct_shortfall_gt_5_pct,
      round(((((count(*) FILTER (WHERE (stats.missed_sessions_gt_10_pct = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS pct_missed_sessions_gt_10_pct,
      round(((((count(*) FILTER (WHERE (stats.hgb_gt_100 = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_hgb_gt_100,
      round(((((count(*) FILTER (WHERE (stats.hgb_gt_130 = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_hgb_gt_130,
      round(((((count(*) FILTER (WHERE (stats.pth_lt_300 = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_pth_lt_300,
      round(((((count(*) FILTER (WHERE (stats.urr_gt_64 = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_urr_gt_64,
      round(((((count(*) FILTER (WHERE (stats.urr_gt_69 = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_urr_gt_69,
      round(((((count(*) FILTER (WHERE (stats.phos_lt_1_8 = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_phosphate_lt_1_8,
      round(((((count(*) FILTER (WHERE (stats.has_fistula_or_graft = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_access_fistula_or_graft
     FROM (stats
       JOIN hospital_units hu ON ((hu.id = stats.hospital_unit_id)))
    GROUP BY hu.name, stats.year, stats.month
    ORDER BY hu.name, stats.year, stats.month;
  SQL
  create_view "renalware.reporting_main_authors_audit", materialized: true, sql_definition: <<-SQL
      WITH archived_clinic_letters AS (
           SELECT date_part('year'::text, archive.created_at) AS year,
              to_char(archive.created_at, 'Month'::text) AS month,
              letters.author_id,
              date_part('day'::text, (archive.created_at - (visits.date)::timestamp without time zone)) AS days_to_archive
             FROM ((letter_letters letters
               JOIN letter_archives archive ON ((letters.id = archive.letter_id)))
               JOIN clinic_visits visits ON ((visits.id = letters.event_id)))
            WHERE (archive.created_at > (CURRENT_DATE - 'P3M'::interval))
          ), archived_clinic_letters_stats AS (
           SELECT archived_clinic_letters.author_id,
              count(*) AS total_letters,
              round(avg(archived_clinic_letters.days_to_archive)) AS avg_days_to_archive,
              (( SELECT count(*) AS count
                     FROM archived_clinic_letters acl
                    WHERE ((acl.days_to_archive <= (7)::double precision) AND (acl.author_id = archived_clinic_letters.author_id))))::numeric AS archived_within_7_days
             FROM archived_clinic_letters
            GROUP BY archived_clinic_letters.author_id
          )
   SELECT (((users.family_name)::text || ', '::text) || (users.given_name)::text) AS name,
      stats.total_letters,
      round(((stats.archived_within_7_days / (stats.total_letters)::numeric) * (100)::numeric)) AS percent_archived_within_7_days,
      stats.avg_days_to_archive,
      users.id AS user_id
     FROM (archived_clinic_letters_stats stats
       JOIN users ON ((stats.author_id = users.id)))
    ORDER BY stats.total_letters DESC;
  SQL
  create_view "renalware.reporting_unit_patients", sql_definition: <<-SQL
      WITH date_range AS (
           SELECT date_trunc('year'::text, (CURRENT_TIMESTAMP - 'P10Y'::interval)) AS start,
              CURRENT_TIMESTAMP AS stop
          ), month_range AS (
           SELECT 0 AS current_month,
              ((EXTRACT(year FROM age(date_range.start)) * (12)::numeric) + EXTRACT(month FROM age(date_range.start))) AS months_to_go_back
             FROM date_range
          ), months AS (
           SELECT generate_series(month_range.current_month, (month_range.months_to_go_back)::integer) AS month
             FROM month_range
          ), profile_history AS (
           SELECT hp.patient_id,
              hp.hospital_unit_id,
              ((EXTRACT(year FROM age(hp.created_at)) * (12)::numeric) + EXTRACT(month FROM age(hp.created_at))) AS start_month,
              COALESCE(((EXTRACT(year FROM age(hp.deactivated_at)) * (12)::numeric) + EXTRACT(month FROM age(hp.deactivated_at))), (0)::numeric) AS end_month
             FROM hd_profiles hp
            ORDER BY hp.patient_id
          ), deduplicated_profile_history AS (
           SELECT DISTINCT ON (profile_history.patient_id, profile_history.hospital_unit_id, profile_history.start_month, profile_history.end_month) profile_history.patient_id,
              profile_history.hospital_unit_id,
              profile_history.start_month,
              profile_history.end_month
             FROM profile_history
            ORDER BY profile_history.patient_id, profile_history.hospital_unit_id, profile_history.start_month, profile_history.end_month
          ), patient_counts AS (
           SELECT ph.hospital_unit_id,
              m_1.month,
              count(*) AS patients
             FROM (deduplicated_profile_history ph
               JOIN months m_1 ON ((((m_1.month)::numeric <= ph.start_month) AND ((m_1.month)::numeric >= ph.end_month))))
            GROUP BY ph.hospital_unit_id, m_1.month
            ORDER BY ph.hospital_unit_id, m_1.month
          )
   SELECT hc.name AS hospital,
      hu.name AS unit,
      (EXTRACT(year FROM (CURRENT_DATE - (((m.month)::text || ' month'::text))::interval)))::text AS year,
      to_char((CURRENT_DATE - (((m.month)::text || ' month'::text))::interval), 'Mon'::text) AS month,
      pc.patients
     FROM (((hospital_units hu
       JOIN hospital_centres hc ON ((hc.id = hu.hospital_centre_id)))
       JOIN months m ON ((1 = 1)))
       LEFT JOIN patient_counts pc ON (((pc.month = m.month) AND (pc.hospital_unit_id = hu.id))))
    ORDER BY hu.name, m.month;
  SQL
  create_view "renalware.survey_eq5d_pivoted_responses", sql_definition: <<-SQL
      SELECT r.answered_on,
      r.patient_id,
      max((
          CASE
              WHEN ((q.code)::text = 'YOHQ1'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YOHQ1",
      max((
          CASE
              WHEN ((q.code)::text = 'YOHQ2'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YOHQ2",
      max((
          CASE
              WHEN ((q.code)::text = 'YOHQ3'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YOHQ3",
      max((
          CASE
              WHEN ((q.code)::text = 'YOHQ4'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YOHQ4",
      max((
          CASE
              WHEN ((q.code)::text = 'YOHQ5'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YOHQ5",
      max((
          CASE
              WHEN ((q.code)::text = 'YOHQ6'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YOHQ6"
     FROM ((survey_responses r
       JOIN survey_questions q ON ((q.id = r.question_id)))
       JOIN survey_surveys s ON ((s.id = q.survey_id)))
    WHERE ((s.code)::text = 'eq5d'::text)
    GROUP BY r.answered_on, r.patient_id
    ORDER BY r.answered_on DESC;
  SQL
  create_view "renalware.survey_pos_s_pivoted_responses", sql_definition: <<-SQL
      SELECT r.answered_on,
      r.patient_id,
      (sum(convert_to_float((r.value)::text)))::integer AS total_score,
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ1'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ1",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ2'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ2",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ3'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ3",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ4'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ4",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ5'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ5",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ6'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ6",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ7'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ7",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ8'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ8",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ9'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ9",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ10'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ10",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ11'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ11",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ12'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ12",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ13'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ13",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ14'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ14",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ15'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ15",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ16'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ16",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ17'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ17",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ18'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ18",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ19'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ19",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ20'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ20",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ21'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ21",
      max((
          CASE
              WHEN ((q.code)::text = 'YSQ22'::text) THEN r.value
              ELSE NULL::character varying
          END)::text) AS "YSQ22",
      max(
          CASE
              WHEN ((q.code)::text = 'YSQ18'::text) THEN r.patient_question_text
              ELSE NULL::text
          END) AS "YSQ18_patient_question_text",
      max(
          CASE
              WHEN ((q.code)::text = 'YSQ19'::text) THEN r.patient_question_text
              ELSE NULL::text
          END) AS "YSQ19_patient_question_text",
      max(
          CASE
              WHEN ((q.code)::text = 'YSQ20'::text) THEN r.patient_question_text
              ELSE NULL::text
          END) AS "YSQ20_patient_question_text"
     FROM ((survey_responses r
       JOIN survey_questions q ON ((q.id = r.question_id)))
       JOIN survey_surveys s ON ((s.id = q.survey_id)))
    WHERE ((s.code)::text = 'prom'::text)
    GROUP BY r.answered_on, r.patient_id
    ORDER BY r.answered_on DESC;
  SQL
  create_view "renalware.system_sql_functions", sql_definition: <<-SQL
      SELECT n.nspname AS schema,
      p.proname AS sql_function_name
     FROM (pg_proc p
       LEFT JOIN pg_namespace n ON ((p.pronamespace = n.oid)))
    WHERE ((n.nspname <> ALL (ARRAY['pg_catalog'::name, 'information_schema'::name])) AND (n.nspname ~~ 'renalware%'::text))
    ORDER BY n.nspname, p.proname;
  SQL
  create_view "renalware.ukrdc_daily_summaries", sql_definition: <<-SQL
      SELECT (created_at)::date AS date,
      count(*) AS total,
      count(
          CASE
              WHEN (status = 3) THEN 1
              ELSE NULL::integer
          END) AS queued,
      count(
          CASE
              WHEN (status = 99) THEN 1
              ELSE NULL::integer
          END) AS sent,
      count(
          CASE
              WHEN (status = 2) THEN 1
              ELSE NULL::integer
          END) AS unsent_no_change,
      count(
          CASE
              WHEN (status = 1) THEN 1
              ELSE NULL::integer
          END) AS error
     FROM ukrdc_transmission_logs utl
    GROUP BY ((created_at)::date)
    ORDER BY ((created_at)::date);
  SQL
  create_view "renalware_demo.reporting_example_data", sql_definition: <<-SQL
      WITH dates AS (
           SELECT (date_trunc('day'::text, dd.dd))::date AS dt
             FROM generate_series('2023-01-01 00:00:00'::timestamp without time zone, '2023-12-31 00:00:00'::timestamp without time zone, 'P7D'::interval) dd(dd)
          )
   SELECT dt AS date,
      (((10)::double precision + ((9)::double precision * random())) * (row_number() OVER ())::double precision) AS series1,
      (((2)::double precision + ((7)::double precision * random())) * (row_number() OVER ())::double precision) AS series2
     FROM dates;
  SQL
  create_view "reporting_pd_audit", sql_definition: <<-SQL
      WITH pd_patients AS (
           SELECT patients.id
             FROM ((patients
               JOIN modality_modalities current_modality ON ((current_modality.patient_id = patients.id)))
               JOIN modality_descriptions current_modality_description ON ((current_modality_description.id = current_modality.description_id)))
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
             FROM pd_regimes
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
