module Renalware
  describe "Renalware::ScheduledJobs.config", type: :model do
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
  end
end
