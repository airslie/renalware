# frozen_string_literal: true

module Renalware
  describe "Renalware::Engine.scheduled_jobs_config", type: :model do
    let(:jobs_config) do
      Renalware::Engine.scheduled_jobs_config
    end

    it "has the right jobs" do
      expect(jobs_config.keys).to include(
        :ods_sync,
        :audit_patient_hd_statistics,
        :hd_scheduling_diary_housekeeping,
        :reporting_send_daily_summary_email,
        :terminate_given_but_unwitnessed_hd_stat_prescriptions,
        :ukrdc_export,
        :dmd_sync,
        :mirth_raw_message_processor
      )
    end
  end
end
