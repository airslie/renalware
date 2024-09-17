# frozen_string_literal: true

module Renalware
  module Medications
    module Delivery
      describe HomecareFormsAdapter do
        include PatientsSpecHelper
        let(:user) { create(:user) }

        let(:patient) {
          create(
            :patient,
            telephone1: "tel1",
            local_patient_id: "P1",
            title: "Mrs",
            named_consultant: user
          ).tap do |pat|
            pat.current_address.street_1 = "line1"
            pat.current_address.street_2 = "line2"
            pat.current_address.street_3 = "line3"
            pat.current_address.town = "town"
            pat.current_address.town = "PC1"
          end
        }
        let(:homecare_form) {
          create(
            :homecare_form,
            form_name: "generic",
            form_version: 1,
            prescription_durations: [1, 3, 6]
          )
        }
        let(:delivery_event) {
          create(
            :medication_delivery_event,
            homecare_form: homecare_form,
            patient: patient,
            prescription_duration: "3"
          )
        }

        describe "#call" do
          it "delegates to Forms::Homecare::Pdf" do
            allow(Forms::Homecare::Pdf).to receive(:generate)
            adapter = described_class.new(delivery_event: delivery_event)
            adapter.call
            expect(Forms::Homecare::Pdf).to have_received(:generate)
          end
        end

        describe "#build_args" do
          it "delegates to Forms::Homecare::Pdf" do
            allow(Renalware.config)
              .to receive_messages(
                hospital_name: "HospitalX",
                hospital_address: "address1, address2, address3"
              )

            set_modality(
              patient: patient,
              modality_description: FactoryBot.create(:hd_modality_description),
              by: patient.created_by
            )

            adapter = described_class.new(delivery_event: delivery_event)

            args = adapter.build_args

            expect(args).to have_attributes(
              provider: homecare_form.form_name,
              version: homecare_form.form_version.to_i,
              family_name: patient.family_name,
              given_name: patient.given_name,
              title: patient.title,
              born_on: patient.born_on,
              nhs_number: patient.nhs_number,
              telephone: patient.telephone1,
              hospital_number: patient.local_patient_id,
              address: [
                patient.current_address.street_1,
                patient.current_address.street_2,
                patient.current_address.street_3,
                patient.current_address.town
              ],
              postcode: patient.current_address.postcode,
              consultant: user.to_s,
              modality: "HD",
              po_number: delivery_event.reference_number,
              drug_type: delivery_event.drug_type.name,
              hospital_name: "HospitalX",
              hospital_address: %w(address1 address2 address3)
            )

            expect(args).to have_attributes(
              prescription_durations: ["1 months", "3 months", "6 months"],
              selected_prescription_duration: "3 months"
            )
          end

          context "when there are prescriptions" do
            let(:esa_drug_type) { create(:drug_type, :esa) }
            let(:immuno_drug_type) { create(:drug_type, :immunosuppressant) }
            let(:esa_drug) do
              create(:drug, name: "esa drug").tap { |drug| drug.drug_types << esa_drug_type }
            end
            let(:immuno_drug) do
              create(:drug, name: "drug2").tap { |drug| drug.drug_types << immuno_drug_type }
            end

            it "adds them to the Arg object" do
              # First is target
              create(
                :prescription,
                drug: esa_drug,
                by: user,
                dose_amount: "100",
                dose_unit: "milligram",
                patient: patient,
                medication_route: create(:medication_route, :po),
                prescribed_on: "2020-01-01",
                provider: :home_delivery
              )
              create(
                :prescription,
                drug: immuno_drug,
                by: user,
                patient: patient,
                provider: :gp
              )
              create(
                :prescription,
                drug: immuno_drug,
                by: user,
                patient: patient,
                provider: :home_delivery
              )

              expect(patient.prescriptions.current.count).to eq(3)

              delivery_event = create(
                :medication_delivery_event,
                homecare_form: homecare_form,
                patient: patient,
                drug_type: esa_drug_type,
                prescription_duration: "3"
              )

              adapter = described_class.new(delivery_event: delivery_event)
              args = adapter.build_args

              expect(patient.prescriptions.current.count).to eq(3)

              expect(args.medications.length).to eq(1)

              med = args.medications.first
              expect(med).to have_attributes(
                drug: "esa drug",
                date: Date.parse("2020-01-01"),
                dose: "100 mg",
                route: "Oral"
              )
            end
          end

          context "when there are allergies" do
            let(:esa_drug_type) { create(:drug_type, :esa) }
            let(:immuno_drug_type) { create(:drug_type, :immunosuppressant) }
            let(:esa_drug) do
              create(:drug, name: "esa drug").tap { |drug| drug.drug_types << esa_drug_type }
            end
            let(:immuno_drug) do
              create(:drug, name: "drug2").tap { |drug| drug.drug_types << immuno_drug_type }
            end

            it "supplies them in args" do
              clinical_patient = Renalware::Clinical.cast_patient(patient)
              create(:allergy, description: "nuts", patient: clinical_patient, by: user)

              delivery_event = create(
                :medication_delivery_event,
                homecare_form: homecare_form,
                patient: patient,
                drug_type: esa_drug_type,
                prescription_duration: "3"
              )

              adapter = described_class.new(delivery_event: delivery_event)

              args = adapter.build_args

              expect(args.allergies).to eq(["nuts"])
            end

            it "supplies allergy status" do
              clinical_patient = Renalware::Clinical.cast_patient(patient)
              clinical_patient.allergy_status = :no_known_allergies
              clinical_patient.save_by!(create(:user))

              delivery_event = create(
                :medication_delivery_event,
                homecare_form: homecare_form,
                patient: Renalware::Patient.find(patient.id),
                drug_type: esa_drug_type,
                prescription_duration: "3"
              )

              adapter = described_class.new(delivery_event: delivery_event)

              args = adapter.build_args

              expect(args.no_known_allergies).to be(true)
            end
          end
        end
      end
    end
  end
end
