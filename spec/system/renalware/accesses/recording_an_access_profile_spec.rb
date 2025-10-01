describe "Recording an access profile for a patient" do
  let(:clinician) { create(:user, :clinical) }
  let(:patient) { create(:patient) }
  let(:accesses_patient) { Renalware::Accesses.cast_patient(patient) }

  before do
    login_as(clinician)
  end

  describe "creating an access profile" do
    it "allows a clinician to record an access profile" do
      access_type = create(:access_type)
      profile_page = Pages::Accesses::ProfilePage.new(accesses_patient)

      profile_page.visit_add
      profile_page.access_type = access_type.to_s
      profile_page.side = "Left"
      profile_page.formed_on = I18n.l(Time.zone.today)
      profile_page.save

      # Verify profile was created
      expect(accesses_patient.profiles.reload.count).to be > 0
      profile = accesses_patient.profiles.first
      expect(profile.type).to eq(access_type)
      expect(profile.side).to eq("left")
      expect(profile.formed_on).to eq(Time.zone.today)
    end
  end

  describe "updating an access profile" do
    let!(:access_type) { create(:access_type) }
    let!(:profile) do
      accesses_patient.profiles.create!(
        type: access_type,
        side: :left,
        formed_on: Time.zone.today,
        started_on: Time.zone.today,
        by: clinician
      )
    end

    it "allows a clinician to update an existing access profile" do
      profile_page = Pages::Accesses::ProfilePage.new(accesses_patient)

      profile_page.visit_edit
      profile_page.side = "Right"
      profile_page.save

      # Verify profile was updated
      expect(profile.reload.side).to eq("right")
    end
  end

  describe "validation handling" do
    it "does not accept erroneous access profile submissions" do
      profile_page = Pages::Accesses::ProfilePage.new(accesses_patient)

      profile_page.visit_add
      # Leave required fields empty and try to save
      profile_page.save

      # Verify no profile was created due to validation errors
      expect(Renalware::Accesses::Profile.count).to eq(0)
    end
  end
end
