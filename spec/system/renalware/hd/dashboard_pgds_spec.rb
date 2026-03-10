RSpec.describe "HD dashboard PGDs", :js do
  let(:nurse) { create(:user, role: "clinical") }
  let(:patient) { create(:hd_patient, :with_hd_modality) }

  before do
    login_as nurse
  end

  it "lists recent PGDs in reverse chronological order and links to the full list" do
    created_pgds = Array.new(11) do |index|
      pgd = create(
        :patient_group_direction,
        name: "PGD #{index}",
        code: "PGD-CODE-#{index}"
      )

      create(
        :hd_closed_session,
        patient:,
        by: nurse,
        started_at: index.days.ago.change(hour: 9),
        stopped_at: index.days.ago.change(hour: 13),
        patient_group_directions: [pgd]
      )

      pgd
    end

    newest_pgd = created_pgds.first
    oldest_pgd = created_pgds.last

    visit patient_hd_dashboard_path(patient)

    within_article "Recent Activity" do
      click_on "PGDs"

      expect(page).to have_css("#hd-session-pgds", visible: :visible)
      within "#hd-session-pgds" do
        expect(page).to have_link(
          "View All PGDs",
          href: patient_hd_patient_group_directions_path(patient)
        )
        expect(page).to have_content("Showing 10 of 11")
        expect(first("tbody tr")).to have_content(newest_pgd.name)
        expect(page).to have_content(created_pgds.second.name)
        expect(page).to have_no_content(oldest_pgd.name)
      end
    end
  end
end
