# frozen_string_literal: true

module World
  module Transplants::Registration
    module Domain
      # @section helpers
      #
      def transplant_registration_for(patient)
        patient = transplant_patient(patient)

        Renalware::Transplants::Registration.for_patient(patient).first_or_initialize
      end

      # @section seeding
      #
      def seed_patient_on_wait_list(patient, status = "Active", ukt_status = "Active")
        patient = transplant_patient(patient)

        Renalware::Transplants::Registration.create!(
          patient: patient,
          document: {
            uk_transplant_centre: {
              status: ukt_status,
              status_updated_on: Time.zone.today
            }
          },
          statuses_attributes: {
            "0": {
              started_on: "03-11-2015",
              description_id: registration_status_description_named(status).id,
              by: Renalware::User.first
            }
          }
        )
      end

      def seed_wait_list_registrations(table)
        table.hashes.each do |row|
          patient_name = row[:patient]
          status = row[:status]
          ukt_status = row[:ukt_status]
          patient = Renalware::Transplants::Patient.create!(
            family_name: patient_name.split(",").first.strip,
            given_name: patient_name.split(",").last.strip,
            nhs_number: FactoryBot.generate(:nhs_number),
            local_patient_id: FactoryBot.generate(:local_patient_id),
            sex: "M",
            born_on: Time.zone.today,
            hospital_centre: FactoryBot.create(:hospital_centre),
            by: Renalware::SystemUser.find
          )
          seed_patient_on_wait_list(patient, status, ukt_status)
        end
      end

      # @section commands
      #
      def create_transplant_registration(user:, patient:, status:, started_on:)
        patient = transplant_patient(patient)

        description = registration_status_description_named(status)
        Renalware::Transplants::Registration.create(
          patient: patient,
          statuses_attributes: {
            "0": {
              started_on: started_on,
              description_id: description.id,
              by: user
            }
          }
        )
      end

      def view_wait_list_registrations(filter:, user: nil)
        @query = Renalware::Transplants::Registrations::WaitListQuery.new(
          named_filter: filter
        )
      end

      # @section expectations
      #
      def expect_transplant_registration_to_exist(patient:, status_name:, started_on:)
        registration = Renalware::Transplants::Registration.for_patient(patient).first
        expect(registration).to_not be_nil
        status = registration.current_status
        expect(status).to_not be_nil
        expect(status.description.name).to eq(status_name)
        expect(status.started_on).to eq(Date.parse(started_on))
      end

      def expect_transplant_registration_to_be_modified(patient:)
        travel_to 1.hour.from_now

        registration = transplant_registration_for(patient)
        registration.update!(
          document: {},
          updated_at: Time.zone.now
        )
        expect(registration).to be_modified
      end

      def expect_transplant_registration_to_be_refused
        expect(Renalware::Transplants::Registration.count).to eq(0)
      end

      def expect_wait_list_registrations_to_be(hashes)
        registrations = @query.call
        # TODO: expect(registrations.size).to eq(hashes.size)

        entries = registrations.map do |r|
          hash = {
            patient: r.patient.to_s,
            status: r.current_status.description.name,
            ukt_status: r.document&.uk_transplant_centre&.status
          }
          hash.with_indifferent_access
        end

        hashes.each do |row|
          expect(entries).to include(row)
        end
      end
    end

    module Web
      include Domain

      def create_transplant_registration(user:, patient:, status:, started_on:)
        login_as user
        visit patient_transplants_recipient_dashboard_path(patient)

        within ".page-actions" do
          click_on t("btn.add_")
          click_on "Wait List Registration"
        end

        select "Kidney only", from: "Transplant Type"

        within_fieldset "Waiting List Status" do
          fill_in "Started on", with: started_on
          select "Active", from: "Description"
        end

        within ".form-actions", match: :first do
          click_on t("btn.create")
        end
      end

      def update_transplant_registration(patient:, user:)
        login_as user
        visit patient_transplants_recipient_dashboard_path(patient)
        within_fieldset "Transplant Wait List Registration" do
          click_on t("btn.edit")
        end

        select "Pancreas only", from: "Transplant Type"

        within ".form-actions", match: :first do
          click_on t("btn.save")
        end

        have_content("Pancreas only")
      end

      def view_wait_list_registrations(filter:, user:)
        login_as user
        visit transplants_wait_list_path(named_filter: filter)
      end

      def expect_wait_list_registrations_to_be(hashes)
        hashes.each do |row|
          expect(page.body).to have_content(row[:patient])
        end
      end
    end
  end
end
