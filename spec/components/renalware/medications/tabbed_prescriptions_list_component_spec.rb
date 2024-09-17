# frozen_string_literal: true

describe Renalware::Medications::TabbedPrescriptionsListComponent, type: :component do
  it "generates a tab for each title in prescription group" do
    groups = [
      { title: "Current", prescriptions: [] },
      { title: "Other", prescriptions: [] }
    ]

    render_inline(described_class.new(groups))

    expect(page).to have_content("Current")
    expect(page).to have_content("Other")
  end

  it "generates a table for prescription array in the group" do
    user = build_stubbed(:user)
    patient = build_stubbed(:patient, by: user)
    drug1 = build_stubbed(:drug, name: "Oxo")
    drug2 = build_stubbed(:drug, name: "Bovril")

    groups = [
      {
        title: "Current",
        prescriptions: [build_stubbed(:prescription, by: user, drug: drug1, patient: patient)]
      },
      {
        title: "Other",
        prescriptions: [build_stubbed(:prescription, by: user, drug: drug2, patient: patient)]
      }
    ]

    render_inline(described_class.new(groups))

    expect(page).to have_content("Oxo")
    expect(page).to have_content("Bovril")
  end
end
