module Renalware
  module Messaging
    describe Internal::MessagePresenter do
      describe ".age_in_days" do
        it "returns the number of days between now and message#sent_at" do
          msg = Internal::Message.new(sent_at: Time.zone.today - 1.week)
          expect(described_class.new(msg).age_in_days).to eq(7)
        end
      end

      describe "html_identifier" do
        it "appends the message id to a string" do
          msg = Internal::Message.new(sent_at: Time.zone.today - 1.week, id: 1)
          expect(described_class.new(msg).html_identifier).to eq("message-1")
        end
      end

      describe "html_preview_identifier" do
        it "appends the message id to a string" do
          msg = Internal::Message.new(id: 1)
          expect(
            described_class.new(msg).html_preview_identifier
          ).to eq("message-preview-1")
        end
      end
    end
  end
end
