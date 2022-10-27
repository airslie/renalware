# frozen_string_literal: true

module World
  module Medications::Prescriptions
    module Domain
      include Renalware::PrescriptionsHelper

      # @section helpers
      #
      def default_medication_drug_selector; end

      def parse_date_string(time_string)
        return nil if time_string.blank?

        Date.parse(time_string)
      end

      def seed_prescription_for(options)
        options.reverse_merge!(default_prescriptions_options)

        drug = Renalware::Drugs::Drug.find_or_create_by!(name: options.delete(:drug_name))
        route = Renalware::Medications::MedicationRoute.find_by!(code: options.delete(:route_code))
        user = options.delete(:user) { Renalware::SystemUser.find }
        patient = options.delete(:patient)

        prescription = patient.prescriptions.build(
          treatable: options[:treatable] || patient,
          drug: drug,
          dose_amount: options.delete(:dose_amount),
          dose_unit: options.delete(:dose_unit),
          medication_route: route,
          frequency: options.delete(:frequency),
          administer_on_hd: options.delete(:administer_on_hd) || false,
          prescribed_on: options.delete(:prescribed_on),
          last_delivery_date: options.delete(:last_delivery_date),
          provider: options.delete(:provider).downcase,
          by: user
        )

        if (terminated_on = parse_date_string(options.delete(:terminated_on)))
          prescription.build_termination(by: user, terminated_on: terminated_on)
        end

        prescription.save!
        prescription
      end

      # @ section commands
      #
      def view_prescriptions_for(_clinician, patient)
        current_prescriptions =
          ::Renalware::Medications::PrescriptionsQuery
          .new(relation: patient.prescriptions.current)
          .call
          .includes(:drug)

        historical_prescriptions =
          ::Renalware::Medications::PrescriptionsQuery
          .new(relation: patient.prescriptions)
          .call
          .includes(:drug)

        [current_prescriptions, historical_prescriptions]
      end

      def record_prescription_for(args)
        seed_prescription_for(args.reverse_merge(terminated_on: nil))
      end

      def record_prescription_for_patient(args)
        record_prescription_for(args)
      end

      def revise_prescription_for(prescription:,
                                  patient:,
                                  user:,
                                  drug_selector: default_medication_drug_selector,
                                  prescription_params: {},
                                  expect_success: true)
        update_params = { by: Renalware::SystemUser.find }
        prescription_params.each do |key, value|
          case key.to_sym
          when :drug_name
            drug = Renalware::Drugs::Drug.find_by!(name: value)
            update_params.merge!(drug: drug)
          when :dose
            dose_amount, dose_unit = value.split(" ")
            update_params.merge!(dose_amount: dose_amount, dose_unit: dose_unit)
          when :route_code
            route = Renalware::Medications::MedicationRoute.find_by!(code: value)
            update_params.merge!(medication_route: route)
          when :dose_amount
            update_params.merge!(dose_amount: dose_amount.presence)
          else
            update_params.merge!(key.to_sym => value)
          end
        end

        Renalware::Medications::RevisePrescription.new(prescription).call(update_params)
      end

      def terminate_prescription_for(
        patient:,
        user:,
        terminated_on: Date.current,
        expect_success: true
      )
        prescription = patient.prescriptions.last!

        prescription.terminate(by: user, terminated_on: terminated_on).save
      end

      # @ section expectations
      #
      def expect_prescription_to_be_recorded(patient:, administer_on_hd: false)
        prescription = patient.prescriptions.last!
        expect(prescription).to be_present
        expect(prescription.administer_on_hd).to eq(administer_on_hd)
      end

      def expect_prescription_to_be_revised(patient:)
        expect(patient.prescriptions.count).to eq(2)
      end

      def expect_current_prescriptions_to_match(actual_prescriptions, expected_prescriptions)
        expect(actual_prescriptions.size).to eq(expected_prescriptions.size)
        actual_prescriptions.zip(expected_prescriptions).each do |actual, expected|
          prescription = Renalware::Medications::PrescriptionPresenter.new(actual)
          expect(actual.drug.name).to eq(expected["drug_name"])
          expect(prescription.dose).to eq(expected["dose"])
          expect(actual.frequency).to eq(expected["frequency"])
          expect(actual.medication_route.code).to eq(expected["route_code"])
          expect(actual.provider.downcase).to eq(expected["provider"].downcase)
          expect(actual.terminated_on).to eq(parse_date_string(expected["terminated_on"]))
        end
      end

      def expect_patient_to_have_prescriptions(patient, prescriptions)
        expect(patient.prescriptions.count).to eq(prescriptions.count)

        prescriptions.each do |prescription_attributes|
          drug = Renalware::Drugs::Drug.find_by(
            name: prescription_attributes[:drug_name]
          )
          medication_route = Renalware::Medications::MedicationRoute.find_by(
            code: prescription_attributes[:route_code]
          )

          dose_amount, dose_unit = prescription_attributes[:dose].split(" ")

          prescription_exists = Renalware::Medications::Prescription.exists?(
            patient: patient,
            drug: drug,
            dose_amount: dose_amount,
            dose_unit: dose_unit,
            medication_route: medication_route,
            frequency: prescription_attributes[:frequency],
            administer_on_hd: false
          )

          expect(prescription_exists).to be_truthy
        end
      end

      def expect_prescription_to_be_terminated_by(user, patient:)
        prescription = patient.prescriptions.last!

        expect(prescription).to be_terminated_or_marked_for_termination
        expect(prescription.terminated_by).to eq(user)
      end

      def expect_termination_to_be_rejected(patient)
        prescription = patient.prescriptions.last!

        expect(prescription).not_to be_terminated_or_marked_for_termination
      end

      def expect_prescription_revision_to_be_rejected(patient, revision_params)
        prescription = patient.prescriptions.first
        prescription.reload
        revision_params.each do |key, value|
          expect(prescription.send(key.to_sym)).not_to eq(value)
        end
      end

      private

      def default_prescriptions_options
        {
          treatable: nil,
          drug_name: "Ciprofloxacin Infusion",
          dose_amount: "100",
          dose_unit: "millilitre",
          route_code: "PO",
          frequency: "once a day",
          prescribed_on: "10-10-2015",
          administer_on_hd: false,
          provider: "GP",
          terminated_on: nil
        }
      end
    end

    module Web
      include Domain

      # @section helpers
      #
      def default_medication_drug_selector
        lambda do |drug_name, drug_type = "Antibiotic"|
          select(drug_type, from: "Medication Type")
          select(drug_name, from: "Drug")
        end
      end

      def fill_in_dose(dose_amount, dose_unit)
        fill_in "Dose amount", with: dose_amount

        if dose_unit.present?
          dose_unit = t(
            dose_unit, scope: "enumerize.renalware.medications.prescription.dose_unit"
          )
          select dose_unit, from: "Dose unit"
        end
      end

      # @ section commands
      #
      def record_prescription_for(options)
        drug_name = options.fetch(:drug_name)
        dose_amount = options.fetch(:dose_amount)
        dose_unit = options.fetch(:dose_unit)
        route_code = options.fetch(:route_code)
        frequency = options.fetch(:frequency)
        prescribed_on = options.fetch(:prescribed_on)
        terminated_on = options.fetch(:terminated_on, "")
        administer_on_hd = options.fetch(:administer_on_hd, false)
        drug_selector = options.fetch(:drug_selector, default_medication_drug_selector)

        click_link "Add Prescription"
        expect(page).to have_selector("#new_medications_prescription", count: 1, wait: 10)

        within "#new_medications_prescription" do
          drug_selector.call(drug_name)
          fill_in_dose(dose_amount, dose_unit)
          select route_code, from: "Route"
          fill_in "Frequency", with: frequency
          check "Give on HD" if administer_on_hd
          fill_in "Prescribed on", with: prescribed_on
          fill_in "Terminated on", with: terminated_on
          click_on t("btn.save")
        end
        expect(page).to have_css("#new_medications_prescription", count: 0)
      end

      def record_prescription_for_patient(user:, patient:, **args)
        login_as user

        visit patient_prescriptions_path(patient)

        record_prescription_for(patient: patient, **args)
      end

      def revise_prescription_for(prescription:,
                                  patient:,
                                  user:,
                                  drug_selector: default_medication_drug_selector,
                                  prescription_params: {},
                                  expect_success: true)
        login_as user

        visit patient_prescriptions_path(patient)

        within "#current-prescriptions" do
          click_on t("btn.edit")
        end

        within ".prescription-form" do
          prescription_params.each do |key, value|
            case key.to_sym
            when :drug_name
              drug_selector.call(value)
            when :dose
              dose_amount, dose_unit = value.split(" ")
              fill_in_dose(dose_amount, dose_unit)
            when :dose_amount
              fill_in "Dose amount", with: dose_amount.to_s
            when :frequency
              fill_in "Frequency", with: value
            when :route_code
              select value, from: "Medication route"
            end
          end
          click_on t("btn.save")
        end
        expect(page).to have_css(".prescription-form", count: expect_success ? 0 : 1)
      end

      def terminate_prescription_for(
        patient:,
        user:,
        terminated_on: Date.current,
        expect_success: true
      )
        login_as user

        visit patient_prescriptions_path(patient)

        within "#current-prescriptions" do
          click_on t("btn.terminate")
        end

        fill_in "Terminated on", with: l(terminated_on)
        fill_in "Notes", with: "This is completed."
        click_on t("btn.save")

        expect(page)
          .to have_css("#new_medications_prescription_termination", count: expect_success ? 0 : 1)
      end

      def view_prescriptions_for(clinician, patient)
        login_as clinician

        visit patient_prescriptions_path(patient)

        # Be sure to omit the toggled Notes row
        current_prescriptions = html_table_to_array("current-prescriptions")
          .drop(1)
          .select.each_with_index { |_, idx| idx.even? }
        historical_prescriptions = html_table_to_array("historical-prescriptions")
          .drop(1)
          .select.each_with_index { |_, idx| idx.even? }

        [current_prescriptions, historical_prescriptions]
      end

      # @ section expectations
      #
      def expect_current_prescriptions_to_match(actual_prescriptions, expected_prescriptions)
        actual_prescriptions.zip(expected_prescriptions).each do |actual, expected|
          expected_route =
            Renalware::Medications::MedicationRoute.find_by!(code: expected[:route_code])

          expect(actual).to include(expected[:drug_name])
          expect(actual).to include(expected[:dose])
          expect(actual).to include(expected[:frequency])
          expect(actual).to include(expected_route.code)
          expect(actual).to include(expected[:provider])
        end
      end
    end
  end
end
