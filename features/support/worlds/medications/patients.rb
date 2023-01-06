# frozen_string_literal: true

module World
  module Medications::Patients
    module Domain
      def seed_prescriptions(table)
        table.rows.each do |patient_name, terminated, drug_type_name|
          patient = seed_patient(patient_name)
          seed_prescription_by_drug_type(patient, terminated, drug_type_name)
        end
      end

      def view_esa_prescriptions(user: @nancy)
        @prescriptions = query.call
      end

      def expect_prescriptions_to_be(table)
        expect(@prescriptions.size).to eq(table.hashes.size)
        actual_names = @prescriptions.map { |prescription| prescription.patient.to_s }.sort
        expected_names = table.hashes.map { |h| h["patient"] }.sort
        expect(actual_names).to eq(expected_names)
      end

      private

      def query
        @query ||= Renalware::Medications::PrescriptionsByDrugTypeQuery.new(drug_type_name: "ESA")
      end

      def seed_patient(name)
        family_name, given_name = name.split(", ")
        Renalware::Patient.create_with(
          local_patient_id: SecureRandom.uuid,
          sex: "M",
          born_on: Date.new(1989, 1, 1),
          created_by: Renalware::User.first,
          hospital_centre: FactoryBot.create(:hospital_centre)
        ).find_or_create_by!(
          family_name: family_name,
          given_name: given_name
        )
      end

      def seed_prescription_by_drug_type(patient, terminated, drug_type_name)
        terminated = ActiveRecord::Type::Boolean.new.cast(terminated)
        prescribed_on = Time.zone.now - 1.week
        terminated_on = terminated ? l(Time.zone.now - 1.day) : nil

        drug_type = Renalware::Drugs::Type.find_by(name: drug_type_name)
        drug_name = drug_type.drugs.first.name

        seed_prescription_for(
          patient: patient,
          treatable: patient,
          drug_name: drug_name,
          dose_amount: "100",
          dose_unit: "millilitre",
          route_code: "PO",
          frequency: "once a day",
          prescribed_on: prescribed_on,
          provider: "GP",
          terminated_on: terminated_on
        )
      end
    end

    module Web
      include Domain

      def view_esa_prescriptions(user: @nancy)
        login_as user
        visit medications_esa_prescriptions_path
      end

      def expect_prescriptions_to_be(table)
        table.hashes.each do |row|
          expect(page.body).to have_content(row[:patient].strip)
        end
      end
    end
  end
end
