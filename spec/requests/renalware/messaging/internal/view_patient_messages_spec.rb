# frozen_string_literal: true

describe "List internal messages for a patient" do
  describe "GET index" do
    it "responds successfully" do
      message = create(
        :internal_message,
        patient: create(:messaging_patient),
        author: create(:internal_author),
        subject: "XYZ"
      )
      get patient_messaging_internal_messages_path(message.patient)

      expect(response).to be_successful
      expect(response).to render_template(:index)
      expect(response.body).to match(message.subject)
    end
  end
end
