module World
  module Patients
    module Domain
      include FactoryBot::Syntax::Methods

      def find_patient_by_given_name(given_name)
        Renalware::Patient.find_by!(given_name: given_name)
      end

      def find_or_create_patient_by_name(patient_full_name)
        given_name, family_name = patient_full_name.split

        Renalware::Clinics::Patient.find_or_create_by!(
          given_name: given_name,
          family_name: family_name || "ThePatient",
          hospital_centre: FactoryBot.create(:hospital_centre)
        ) do |patient|
          patient.local_patient_id = SecureRandom.uuid
          patient.sex = "M"
          patient.born_on = Date.new(1989, 1, 1)
          patient.by = Renalware::SystemUser.find
          patient.hospital_centre = FactoryBot.create(:hospital_centre)
        end
      end

      def update_patient_address(patient:, current_address_attributes:)
        current_address_attributes[:id] = patient.current_address.id

        patient.update!(
          current_address_attributes: current_address_attributes,
          by: Renalware::SystemUser.find
        )
      end

      def expect_patient_to_be_created(expected_attributes)
        patient = fetch_patient_by_local_id(expected_attributes.fetch("local_patient_id"))

        expected_attributes.each do |attribute_name, expected_value|
          actual_value = patient.send(attribute_name).to_s
          expect(actual_value).to eq(expected_value)
        end
      end

      def fetch_patient_by_local_id(local_id)
        Renalware::Patient.find_by(local_patient_id: local_id)
      end

      def get_patient(patient_name)
        instance_variable_get(:"@#{patient_name.downcase}")
      end

      def seed_modality_for(patient:, modality_description:, user:)
        Renalware::Modalities::ChangePatientModality
          .new(patient: patient, user: user)
          .call(
            description: modality_description,
            started_on: 1.week.ago
          )
      end
    end

    module Web
      include Domain
    end
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/patients/*.rb")].each { |f| require f }
