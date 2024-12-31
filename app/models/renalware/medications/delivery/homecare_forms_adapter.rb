module Renalware
  module Medications
    module Delivery
      # Takes
      # - a patient
      # - a homecare delivery_event
      # and build Args used to pass to Renalware::Forms::Homecare::Pdf.generate
      class HomecareFormsAdapter
        pattr_initialize [:delivery_event!]
        delegate :homecare_form, :patient, to: :delivery_event

        def call
          Forms::Homecare::Pdf.generate(build_args)
        end

        def valid?(args)
          Forms::Homecare::Pdf.valid?(args)
        end

        def build_args # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          args = Forms::Homecare::Args.new(
            provider: homecare_form.form_name,
            version: homecare_form.form_version,
            family_name: patient.family_name,
            given_name: patient.given_name,
            title: patient.title,
            born_on: patient.born_on,
            nhs_number: patient.nhs_number,
            telephone: patient.telephone1,
            hospital_number: patient.local_patient_id,
            address: [],
            modality: patient.current_modality&.description&.to_s,
            po_number: delivery_event.reference_number,
            drug_type: delivery_event.drug_type.name,
            selected_prescription_duration: selected_prescription_duration,
            prescription_durations: prescription_durations,
            consultant: patient.named_consultant&.to_s,
            generated_at: Time.zone.now,
            hospital_name: Renalware.config.hospital_name,
            hospital_address: hospital_address,
            hospital_department: Renalware.config.hospital_department,
            hospital_telephone: Renalware.config.telephone_on_homecare_delivery_forms
          )

          if patient.current_address
            add = patient.current_address
            args.address = [
              add.street_1,
              add.street_2,
              add.street_3,
              add.town
            ]
            args.postcode = add.postcode
          end

          prescriptions.each do |presc|
            prescription = PrescriptionPresenter.new(presc)
            args.medications << Forms::Homecare::Args::Medication.new(
              date: prescription.prescribed_on,
              drug: prescription.drug_name,
              dose: prescription.dose,
              route: prescription.route_code,
              frequency: prescription.frequency
            )
          end

          clinical_patient = Clinical.cast_patient(patient)
          args.no_known_allergies = (clinical_patient.allergy_status == :no_known_allergies)
          args.allergies = Array(clinical_patient.allergies).map(&:description)
          args
        end

        private

        def hospital_address
          Renalware.config.hospital_address&.split(",")&.map(&:strip)
        end

        # Return e.g. "3 months"
        def selected_prescription_duration
          duration = delivery_event.prescription_duration.to_i
          unit = delivery_event.homecare_form.prescription_duration_unit

          "#{duration} #{unit.pluralize(duration)}"
        end

        def prescription_durations
          homecare_form.prescription_durations.map do |dur|
            "#{dur} #{homecare_form.prescription_duration_unit.pluralize(dur)}"
          end
        end

        def prescriptions
          PrescriptionsByDrugTypeIdQuery.new(
            patient: delivery_event.patient,
            drug_type_id: delivery_event.drug_type_id,
            provider: :home_delivery
          ).call
        end
      end
    end
  end
end
