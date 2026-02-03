module Renalware
  describe "Renalware::Engine.scheduled_jobs_config", type: :model do
    before do
      allow(Renalware.config).to receive_messages(
        monitoring_mirth_enabled: true,
        users_expire_after: 1,
        send_gp_letters_over_mesh: true,
        process_hl7_via_raw_messages_table: true
      )
    end

    let(:jobs_config) do
      Renalware::Engine.scheduled_jobs_config
    end

    it "has the right jobs" do
      expect(jobs_config.keys.sort).to eq(
        [
          :audit_patient_hd_statistics,
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
          :terminate_given_but_unwitnessed_hd_stat_prescriptions,
          :ukrdc_export
        ]
      )
    end
  end
end
