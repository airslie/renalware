# frozen_string_literal: true

require "rails_helper"

describe "Creating a investigation event", js: true do
  context "when adding a investigation event through the Events screen" do
    it "captures extra data" do
      user = login_as_clinical
      patient = create(:patient, by: user)
      event_type = create(:investigation_event_type)

      visit new_patient_event_path(patient)

      slim_select "Investigation", from: "Event type"
      choose "Transplant recipient"
      select "Dental Check", from: "Type"
      fill_in "Result", with: "result"
      fill_trix_editor with: "some notes"
      click_on t("btn.save")

      events = Renalware::Events::Event.for_patient(patient)
      expect(events.length).to eq(1)
      event = events.first
      expect(event.event_type_id).to eq(event_type.id)
      expect(event.notes).to match("some notes")
      expect(event.document.type).to eq("dental_check")
      expect(event.document.result).to eq("result")
      expect(event.document.modality).to eq("transplant_recipient")
    end
  end

  context "when adding a investigation event through the Investigations screen" do
    it "works" do
      user = login_as_clinical
      patient = create(:patient, by: user)
      event_type = create(:investigation_event_type)

      visit new_patient_investigation_path(patient)

      choose "Transplant recipient"
      select "Dental Check", from: "Type"
      fill_in "Result", with: "result"
      fill_trix_editor with: "some notes"
      click_on t("btn.save")

      events = Renalware::Events::Event.for_patient(patient)
      expect(events.length).to eq(1)
      event = events.first
      expect(event.event_type_id).to eq(event_type.id)
      expect(event.notes).to match("some notes")
      expect(event.document.type).to eq("dental_check")
      expect(event.document.result).to eq("result")
      expect(event.document.modality).to eq("transplant_recipient")
    end
  end
end
