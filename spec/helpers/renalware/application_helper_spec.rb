describe Renalware::ApplicationHelper do
  describe ".default_patient_link" do
    it "creates a link going to the patient's clinical summary" do
      patient = build_stubbed(:patient)

      expect(helper.default_patient_link(patient))
        .to match(/#{patient_clinical_summary_path(patient)}/)
    end
  end

  describe ".flash_messages" do
    it "returns alert, notice and success flash message" do
      allow(helper).to receive(:flash).and_return(
        alert: [:alert_message],
        notice: [:notice_message],
        success: [:success_message],
        timedout: [true]
      )
      expect(helper.flash_messages).to eq(
        alert: [:alert_message],
        notice: [:notice_message],
        success: [:success_message]
      )
    end
  end
end
