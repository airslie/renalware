module Renalware
  describe "Listing on-going HD Sessions" do
    let(:named_nurse1)  { create(:user, given_name: "Named", family_name: "Nurse1") }
    let(:named_nurse2)  { create(:user, given_name: "Named", family_name: "Nurse2") }
    let(:patient1)      { create(:hd_patient, named_nurse: named_nurse1) }
    let(:patient2)      { create(:hd_patient, named_nurse: named_nurse2) }
    let(:patient3)      { create(:hd_patient) }
    let(:hd_unit_1)     { create(:hd_hospital_unit, name: "UnitA") }
    let(:hd_unit_2)     { create(:hd_hospital_unit, name: "UnitB") }
    let(:open_session1) {
      create(
        :hd_session,
        patient: patient1,
        started_at: 1.hour.ago,
        hospital_unit: hd_unit_1
      )
    }
    let(:open_session2) {
      create(
        :hd_session,
        patient: patient2,
        started_at: 2.hours.ago,
        hospital_unit: hd_unit_2
      )
    }
    let(:closed_session) {
      create(
        :hd_closed_session,
        patient: patient3,
        started_at: 3.hours.ago,
        signed_off_at: 1.minute.ago
      )
    }

    it "displays only 'open' (not signed-off sessions) in reverse chronological order" do
      login_as_clinical

      open_session2
      open_session1
      closed_session

      visit hd_ongoing_sessions_path

      expect(page).to have_text("Ongoing HD Sessions")

      expect(page).to have_css("#hd_ongoing_sessions tbody tr", count: 2)
      rows = page.all("#hd_ongoing_sessions tbody tr")
      expect(rows[0]).to have_text(open_session1.patient.family_name.upcase)
      expect(rows[0]).to have_text(I18n.l(open_session1.started_at.to_date))
      expect(rows[0]).to have_text(open_session1.hospital_unit.name)
      expect(rows[1]).to have_text(open_session2.patient.family_name.upcase)
      expect(rows[1]).to have_text(I18n.l(open_session2.started_at.to_date))
      expect(rows[1]).to have_text(open_session2.hospital_unit.name)
    end

    context "when filtering using turbo-framed filters", :js do
      it "filtering by Unit" do
        login_as_clinical

        open_session2
        open_session1
        closed_session

        visit hd_ongoing_sessions_path

        select "UnitB", from: "Unit"

        expect(page).to have_css("#hd_ongoing_sessions tbody tr", count: 1)
        rows = page.all("#hd_ongoing_sessions tbody tr")
        expect(rows[0]).to have_text(open_session2.hospital_unit.name)
      end

      it "filtering by Named Nurse" do
        login_as_clinical

        open_session2
        open_session1
        closed_session

        visit hd_ongoing_sessions_path

        select "Nurse2, Named", from: "Named nurse"

        expect(page).to have_css("#hd_ongoing_sessions tbody tr", count: 1)
        rows = page.all("#hd_ongoing_sessions tbody tr")
        expect(rows.size).to eq(1)
        expect(rows[0]).to have_text(open_session2.patient.to_s)
      end
    end

    context "when sorting", :js do
      it "sorts by unit desc" do
        login_as_clinical

        open_session2
        open_session1
        closed_session

        visit hd_ongoing_sessions_path(q: { s: "hospital_unit_name desc" })

        expect(page).to have_css("#hd_ongoing_sessions tbody tr", count: 2)
        rows = page.all("#hd_ongoing_sessions tbody tr")
        expect(rows[0]).to have_text(open_session2.patient.family_name.upcase)
        expect(rows[1]).to have_text(open_session1.patient.family_name.upcase)
      end

      it "sorts by unit asc" do
        login_as_clinical

        open_session2
        open_session1
        closed_session

        visit hd_ongoing_sessions_path(q: { s: "hospital_unit_name asc" })

        expect(page).to have_css("#hd_ongoing_sessions tbody tr", count: 2)
        rows = page.all("#hd_ongoing_sessions tbody tr")
        expect(rows[0]).to have_text(open_session1.patient.family_name.upcase)
        expect(rows[1]).to have_text(open_session2.patient.family_name.upcase)
      end

      it "sorts by date asc (reverse of the default which is date desc)" do
        login_as_clinical

        open_session2
        open_session1
        closed_session

        visit hd_ongoing_sessions_path(q: { s: "started_at asc" })

        expect(page).to have_css("#hd_ongoing_sessions tbody tr", count: 2)
        rows = page.all("#hd_ongoing_sessions tbody tr")
        expect(rows[0]).to have_text(open_session2.patient.family_name.upcase)
        expect(rows[1]).to have_text(open_session1.patient.family_name.upcase)
      end
    end
  end
end
