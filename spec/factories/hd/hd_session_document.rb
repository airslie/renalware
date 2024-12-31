# A word about using FactoryBot to build document (jsonb) objects:
#
# The best solution I can find is to use OpenStructs to build each
# nested part, compose these in the top level document (e.g. SessionDocument)
# using `strategy: :marshal_dump`.
# When consuming in an AR-based factory, uses an after_build callback for example
#
#   Factory :hd_closed_session, class: "Renalware::HD::Session::Closed" do
#     after(:build) do |session|
#        session.document = build(:hd_session_document).marshal_dump
#     end
#   end
#
# The support/factory_bot.rb for the definition of MarshalDumpStrategy
#
FactoryBot.define do
  factory :blood_pressure, class: "OpenStruct" do
    systolic { 100 }
    diastolic { 80 }
  end

  factory :hd_session_document_info, class: "OpenStruct" do
    hd_type { "hd" }
    machine_no { 222 }
    access_side { "right" }
    access_type { "Arteriovenous graft (AVG)" }
    access_type_abbreviation { "AVG" }
    access_confirmed { true }
    single_needle { "no" }
    lines_reversed { "no" }
    fistula_plus_line { "no" }
    is_access_first_use { "no" }
    needle_size { "17" }
    cannulation_type { "Buttonhole" }
  end

  factory :hd_session_document_avf_avg_assessment, class: "OpenStruct" do
    score { 1 }
  end

  factory :hd_session_document_dialysis, class: "OpenStruct" do
    flow_rate { 200 }
    blood_flow { 150 }
    machine_ktv { 1.0 }
    machine_urr { 1 }
    fluid_removed { 1.0 }
    venous_pressure { 1 }
    litres_processed { 1.0 }
    arterial_pressure { 1 }
  end

  factory :hd_session_document_observations_before, class: "OpenStruct" do
    pulse { 37 }
    weight { 100.0 }
    bm_stix { 1.0 }
    temperature { 36.0 }
    respiratory_rate { 20.0 }
    blood_pressure factory: :blood_pressure, strategy: :marshal_dump
  end

  factory :hd_session_document_observations_after, class: "OpenStruct" do
    pulse { 36 }
    weight { 99.0 }
    bm_stix { 0.9 }
    temperature { 35.0 }
    respiratory_rate { 25.0 }
    blood_pressure factory: :blood_pressure, strategy: :marshal_dump
  end

  factory :hd_session_document_complications, class: "OpenStruct" do
    line_exit_site_status { "0" }
  end

  factory :hd_session_document, class: "OpenStruct" do
    info factory: :hd_session_document_info, strategy: :marshal_dump
    dialysis factory: :hd_session_document_dialysis, strategy: :marshal_dump
    avf_avg_assessment factory: :hd_session_document_avf_avg_assessment, strategy: :marshal_dump
    observations_before factory: :hd_session_document_observations_before, strategy: :marshal_dump
    observations_after factory: :hd_session_document_observations_after, strategy: :marshal_dump
    complications factory: :hd_session_document_complications, strategy: :marshal_dump
  end
end
