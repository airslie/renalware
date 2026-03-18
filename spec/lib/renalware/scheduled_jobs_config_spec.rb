module Renalware
  describe "Renalware::ScheduledJobs.config", type: :model do
    around do |example|
      original_value = ENV.fetch("CUSTOM_SCHEDULED_JOBS", nil)
      ENV.delete("CUSTOM_SCHEDULED_JOBS")

      example.run
    ensure
      if original_value.nil?
        ENV.delete("CUSTOM_SCHEDULED_JOBS")
      else
        ENV["CUSTOM_SCHEDULED_JOBS"] = original_value
      end
    end

    before do
      allow(Renalware.config).to receive_messages(
        monitoring_mirth_enabled: true,
        users_expire_after: 1,
        send_gp_letters_over_mesh: true,
        process_hl7_via_raw_messages_table: true,
        housekeeping_jobs_enabled: true,
        ukrdc_enabled: true
      )
    end

    let(:jobs_config) do
      Renalware::ScheduledJobs.config
    end

    it "has the right jobs" do
      expect(jobs_config.keys.sort).to eq(
        [
          :audit_patient_hd_statistics,
          :database_housekeeping,
          :dmd_sync,
          :expire_inactive_users,
          :hd_scheduling_diary_housekeeping,
          :mesh_check_inbox_for_outstanding_responses,
          :mesh_handshake,
          :mirth_monitoring,
          :mirth_raw_message_processor,
          :ods_sync,
          :reconcile_mesh_transmissions_job,
          :reporting_send_daily_summary_email,
          :schedule_refresh_of_materialized_views,
          :terminate_given_but_unwitnessed_hd_stat_prescriptions,
          :ukrdc_export,
          :ukrdc_sftp_transfer
        ]
      )
    end

    it "merges in custom jobs from JSON in ENV" do
      ENV["CUSTOM_SCHEDULED_JOBS"] = {
        generate_missing_urr: {
          cron: "1 5-23/1 * * *",
          args: ["bundle exec rake pathology:generate_missing_urr"],
          class: "Renalware::InvokeCommandJob",
          description: "Generate a URR value if we find a P_URE result"
        }
      }.to_json

      expect(jobs_config.fetch(:generate_missing_urr)).to eq(
        cron: "1 5-23/1 * * *",
        args: ["bundle exec rake pathology:generate_missing_urr"],
        class: "Renalware::InvokeCommandJob",
        description: "Generate a URR value if we find a P_URE result"
      )
    end

    it "handles double-encoded JSON in ENV" do
      ENV["CUSTOM_SCHEDULED_JOBS"] = {
        ukrdc_cohort_housekeeping: {
          cron: "every day at 4am",
          class: "Renalware::System::SqlFunctionJob",
          args: ["renalware_mse.ukrdc_update_send_to_renalreg()"],
          description: "Mark patients as send to the Renal Registry. See function for logic"
        }
      }.to_json.to_json

      expect(jobs_config.fetch(:ukrdc_cohort_housekeeping)).to eq(
        cron: "every day at 4am",
        class: "Renalware::System::SqlFunctionJob",
        args: ["renalware_mse.ukrdc_update_send_to_renalreg()"],
        description: "Mark patients as send to the Renal Registry. See function for logic"
      )
    end
  end
end
