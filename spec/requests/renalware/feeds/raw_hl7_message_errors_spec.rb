describe "Viewing HL7 raw message errors" do
  let!(:error_one) do
    Renalware::Feeds::RawHL7MessageError.create!(
      body: "BODY one\nline two",
      error_message: "First error\nmore detail",
      error_message_backtrace: "app/models/foo.rb:1\napp/models/bar.rb:2",
      sent_at: 2.days.ago,
      created_at: 2.days.ago,
      updated_at: 2.days.ago
    )
  end
  let!(:error_two) do
    Renalware::Feeds::RawHL7MessageError.create!(
      body: "BODY two\nline two",
      error_message: "Second error\nmore detail",
      error_message_backtrace: "app/services/foo.rb:3\napp/services/bar.rb:4",
      sent_at: 1.day.ago,
      created_at: 1.day.ago,
      updated_at: 1.day.ago
    )
  end

  describe "GET index" do
    context "when the user is a super admin" do
      before { login_as_super_admin }

      it "renders the errors newest first with previews only" do
        get feeds_raw_hl7_message_errors_path

        expect(response).to be_successful
        expect(response.body.index(error_two.id.to_s))
          .to be < response.body.index(error_one.id.to_s)
        expect(response.body).to include("Second error")
        expect(response.body).to include("First error")
        expect(response.body).not_to include("more detail")
        expect(response.body).to include("app/models/foo.rb:1")
        expect(response.body).not_to include("app/models/bar.rb:2")
        expect(response.body).to include("BODY one")
        expect(response.body).not_to include("line two")
      end
    end

    context "when the user is not a super admin" do
      before { login_as_admin }

      it "redirects to the dashboard" do
        get feeds_raw_hl7_message_errors_path

        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe "GET show" do
    context "when the user is a super admin" do
      before { login_as_super_admin }

      it "renders the full error details" do
        get feeds_raw_hl7_message_error_path(error_one)

        expect(response).to be_successful
        expect(response.body).to include("First error")
        expect(response.body).to include("more detail")
        expect(response.body).to include("app/models/foo.rb:1")
        expect(response.body).to include("app/models/bar.rb:2")
        expect(response.body).to include("BODY one")
        expect(response.body).to include("line two")
      end
    end
  end
end
