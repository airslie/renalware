# frozen_string_literal: true

describe "Managing event subtypes" do
  def create_subtype
    event_type = create(:research_study_event_type, name: "EventType1")
    create(
      :event_subtype,
      name: "Subtype1",
      event_type: event_type
    )
  end

  it "listing existing layoutables" do
    create_subtype
    login_as_super_admin
    visit events_types_path

    expect(page).to have_content("EventType1")
    click_on "Subtypes"

    # TODO: Extend test
  end
end
