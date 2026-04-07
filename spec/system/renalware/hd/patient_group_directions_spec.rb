RSpec.describe "HD patient group directions", :js do
  let(:nurse) { create(:user, role: "clinical") }
  let(:patient) { create(:hd_patient, :with_hd_modality) }
  let(:other_patient) { create(:hd_patient, :with_hd_modality) }

  before do
    login_as nurse
  end

  it "lists all PGDs for the patient with pagination" do
    created_pgds = Array.new(26) do |index|
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

    excluded_pgd = create(:patient_group_direction, name: "Other patient PGD", code: "OTHER")
    create(
      :hd_closed_session,
      patient: other_patient,
      by: nurse,
      started_at: Time.zone.now.change(hour: 9),
      stopped_at: Time.zone.now.change(hour: 13),
      patient_group_directions: [excluded_pgd]
    )

    newest_pgd = created_pgds.first
    page_two_pgd = created_pgds.last

    visit patient_hd_patient_group_directions_path(patient)

    expect(page).to have_content("Patient Group Directions")
    expect(page).to have_content("Showing 25 of 26")
    within "table.auto-layout" do
      expect(first("tbody tr")).to have_content(newest_pgd.name)
      expect(page).to have_no_content(excluded_pgd.name)
      expect(page).to have_no_content(page_two_pgd.name)
    end

    expect(page).to have_css("nav.pagy")

    visit patient_hd_patient_group_directions_path(patient, page: 2)

    expect(page).to have_content("Showing 1 of 26")
    within "table.auto-layout" do
      expect(page).to have_content(page_two_pgd.name)
      expect(page).to have_no_content(newest_pgd.name)
    end
  end
end
