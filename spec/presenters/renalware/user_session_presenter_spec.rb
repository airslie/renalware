describe Renalware::UserSessionPresenter do
  describe ".session_controller_data_attributes" do
    it "includes expires-at-epoch-ms when last_request_at exists at top level" do
      freeze_time do
        allow(Devise).to receive(:timeout_in).and_return(5.minutes)
        last_request_at = 2.minutes.ago.to_i
        attrs = described_class.session_controller_data_attributes(
          user_session: { "last_request_at" => last_request_at }
        )

        expires_at_epoch_ms = attrs.dig(:data, :session, :"expires-at-epoch-ms")
        expected = ((Time.zone.at(last_request_at) + 5.minutes).to_f * 1000).to_i

        expect(expires_at_epoch_ms).to eq(expected)
      end
    end

    it "includes expires-at-epoch-ms when last_request_at exists in warden session" do
      freeze_time do
        allow(Devise).to receive(:timeout_in).and_return(5.minutes)
        last_request_at = 2.minutes.ago.to_i
        attrs = described_class.session_controller_data_attributes(
          user_session: { "warden.user.user.session" => { "last_request_at" => last_request_at } }
        )

        expires_at_epoch_ms = attrs.dig(:data, :session, :"expires-at-epoch-ms")
        expected = ((Time.zone.at(last_request_at) + 5.minutes).to_f * 1000).to_i

        expect(expires_at_epoch_ms).to eq(expected)
      end
    end

    it "omits expires-at-epoch-ms when last_request_at is missing" do
      allow(Devise).to receive(:timeout_in).and_return(5.minutes)
      attrs = described_class.session_controller_data_attributes(user_session: {})

      expect(attrs.dig(:data, :session, :"expires-at-epoch-ms")).to be_nil
    end

    it "does not raise when user_session does not support #dig" do
      klass = Class.new do
        def [](_key)
          nil
        end
      end

      attrs = described_class.session_controller_data_attributes(user_session: klass.new)

      expect(attrs.dig(:data, :session, :"expires-at-epoch-ms")).to be_nil
    end
  end
end
