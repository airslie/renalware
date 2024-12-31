describe "Donor stage management" do
  let(:user) { @current_user }
  let(:patient) { create(:patient, by: user) }

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new donor stage" do
        position = create(:donor_stage_position)
        status = create(:donor_stage_status)

        params = {
          donor_stage: {
            started_on: Time.zone.now,
            stage_position_id: position.id,
            stage_status_id: status.id,
            notes: "Some notes"
          }
        }
        post patient_transplants_donor_stage_path(patient, params)

        expect(response).to redirect_to(patient_transplants_donor_dashboard_path(patient))
        follow_redirect!
        expect(response).to be_successful
      end
    end

    context "with invalid attributes (missing status)" do
      it "does not submit successfully" do
        position = create(:donor_stage_position)

        params = {
          donor_stage: {
            started_on: Time.zone.now,
            stage_position_id: position.id,
            stage_status_id: nil,
            notes: "Some notes"
          }
        }
        post patient_transplants_donor_stage_path(patient, params)
        # No redirect, re-displays the form
        expect(response).to be_successful
      end
    end
  end
end
