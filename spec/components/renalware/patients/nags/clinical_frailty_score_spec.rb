# frozen_string_literal: true

# This is testing that the Clinical Frailty Score nag - a combination of a sql function and an entry
# in the nag_definitions table - works as expected. We are testing both the functionality specific
# to this nag as well as general conformance to the nag 'protocol'.
describe "Clinical Frailty Score nag", caching: true, type: :component do
  include PatientsSpecHelper
  include NagHelpers

  subject(:component) { described_class.new(definition: definition, patient: patient) }

  let(:described_class) { Renalware::Patients::NagComponent }
  let(:patient) { create(:patient) }
  let(:definition) do
    create(:patient_nag_definition, :clinical_frailty_score)
  end

  it_behaves_like "a nag"

  context "when the patient has a Clinical Frailty Score event" do
    {
      high: [
        { modality: [:pd, :hd, :transplant], age: [281] }
      ],
      medium: [
        { modality: [:pd, :hd, :transplant], age: [91, 180] }
      ],
      none: [
        { modality: [:pd, :hd, :transplant], age: [89] },
        { modality: [:low_clearance], age: [8, 81, 91, 181] }
      ]
    }.each do |severity, groups|
      groups.each do |opts|
        ages = opts[:age]
        opts[:modality].each do |modality|
          ages.each do |age|
            context "when modality is #{modality} and age is #{age}" do
              it "severity is #{severity}" do
                set_modality(
                  patient: patient,
                  modality_description: create(:"#{modality}_modality_description"),
                  by: patient.created_by
                )
                create(
                  :clinical_frailty_score,
                  patient: patient,
                  date_time: age.days.ago
                )

                nag = definition.execute_sql_function_for(patient)
                expect(nag.severity).to eq(severity)
              end
            end
          end
        end
      end
    end
  end

  context "when the patient does not have a Clinical Frailty Score event" do
    {
      high: %w(hd pd transplant),
      none: %w(low_clearance)
    }.each do |severity, modalities|
      modalities.each do |modality|
        it "returns a severity of '#{severity}' if modality is #{modality} and a 'Missing' value" do
          set_modality(
            patient: patient,
            modality_description: create(:"#{modality}_modality_description"),
            by: patient.created_by
          )
          expect(Renalware::Events::Event.for_patient(patient).count).to eq(0)

          nag = definition.execute_sql_function_for(patient)

          expect(nag).to have_attributes(
            severity: severity,
            value: "Missing",
            date: nil
          )
        end
      end
    end
  end

  context "when the patient does not have a modality" do
    it "returns a severity of none" do
      nag = definition.execute_sql_function_for(patient)

      expect(nag).to have_attributes(
        severity: :none,
        value: "Missing",
        date: nil
      )
    end
  end

  describe "#formatted_relative_link" do
    {
      "patients/:id/events" => "/patients/123/events",
      "/patients/:id/events" => "/patients/123/events",
      "patients/:id/events/" => "/patients/123/events"
    }.each do |relative_link, expected_interpolated_path|
      it "replaces placeholders in relative_link" do
        allow(patient).to receive(:to_param).and_return("123")
        definition = create(
          :patient_nag_definition,
          :clinical_frailty_score,
          relative_link: relative_link
        )

        component = described_class.new(definition: definition, patient: patient)

        expect(component.formatted_relative_link).to eq(expected_interpolated_path)
      end
    end
  end
end
