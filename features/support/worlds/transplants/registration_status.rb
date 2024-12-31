module World
  module Transplants::RegistrationStatus
    module Domain
      # @section helpers
      #
      def registration_status_description_named(name)
        Renalware::Transplants::RegistrationStatusDescription.find_by(
          name: name
        ) || raise("Cannot find status [#{name}] in seeding data")
      end

      def status_for_registration_and_name(registration, name)
        description = registration_status_description_named(name)
        registration.statuses.find_by description: description
      end

      # @section seeding
      #
      def seed_patient_wait_list_statuses(patient, table)
        patient = transplant_patient(patient)

        registration = Renalware::Transplants::Registration.create!(
          patient: patient
        )
        table.hashes.each do |row|
          description = registration_status_description_named(row[:status])
          registration.statuses.create!(
            description: description,
            started_on: row[:start_date],
            terminated_on: row[:termination_date],
            by: Renalware::User.find_by(given_name: row[:by])
          )
        end
        @initial_statuses_count = registration.statuses.count
      end

      # @section commands
      #
      def set_transplant_registration_status(patient:, user:, status:, started_on:)
        registration = transplant_registration_for(patient)
        description = registration_status_description_named(status)
        registration.add_status!(
          description: description, started_on: started_on, by: user
        )
      end

      def update_transplant_registration_status(patient:, user:, status:, started_on:)
        registration = transplant_registration_for(patient)
        s = status_for_registration_and_name(registration, status)
        registration.update_status!(s, started_on: started_on, by: user)
      end

      def delete_transplant_registration_status(patient:, user:, status:)
        registration = transplant_registration_for(patient)
        s = status_for_registration_and_name(registration, status)
        registration.delete_status!(s)
      end

      # @section expectations
      #
      def expect_transplant_registration_status_to_be_refused(patient)
        registration = transplant_registration_for(patient)
        expect(registration.statuses.count).to eq(@initial_statuses_count)
      end

      def expect_transplant_registration_status_history_to_match(patient:, hashes:)
        statuses = transplant_registration_for(patient).reload.statuses.map do |s|
          { status: s.description.name,
            start_date: l(s.started_on),
            by: s.updated_by.given_name,
            termination_date: (s.terminated_on ? l(s.terminated_on) : "") }.with_indifferent_access
        end
        expect(statuses.size).to eq(hashes.size)
        hashes.each do |row|
          expect(statuses).to include(row)
        end
      end

      def expect_transplant_registration_current_status_to_be(patient:, name:, started_on:)
        status = transplant_registration_for(patient).current_status
        expect(status.to_s).to eq(name)
        expect(l(status.started_on)).to eq(started_on)
      end

      def expect_transplant_registration_status_history_to_include(patient:, hashes:)
        statuses = transplant_registration_for(patient).reload.statuses.map do |s|
          hash = {
            status: s.description.name,
            start_date: l(s.started_on),
            termination_date: (s.terminated_on ? l(s.terminated_on) : "")
          }
          if hashes.first[:by].present?
            hash[:by] = s.updated_by.given_name
          end
          hash.with_indifferent_access
        end
        hashes.each do |row|
          expect(statuses).to include(row)
        end
      end

      def expect_transplant_registration_current_status_by_to_be(patient:, user:)
        registration = transplant_registration_for(patient)
        expect(registration.current_status.updated_by.id).to eq(user.id)
      end
    end

    module Web
      include Domain

      def set_transplant_registration_status(user:, patient:, status:, started_on:)
        login_as user
        visit patient_transplants_recipient_dashboard_path(patient)
        within_article "Status History" do
          click_on "Update Status"
        end

        fill_in "Started on", with: started_on
        select status, from: "Description"
        within ".document" do
          click_on t("btn.create")
        end
      end

      def update_transplant_registration_status(user:, patient:, status:, started_on:)
        login_as user
        visit patient_transplants_recipient_dashboard_path(patient)
        within_article "Status History" do
          find_link_in_row_with(text: status, link_label: "Edit").click
        end

        fill_in "transplants_registration_status[started_on]", with: started_on
        within ".document" do
          click_on t("btn.create")
        end
      end

      def delete_transplant_registration_status(patient:, user:, status:)
        login_as user
        visit patient_transplants_recipient_dashboard_path(patient)
        within_article "Status History" do
          find_link_in_row_with(text: status, link_label: "Delete").click
        end
      end
    end
  end
end
