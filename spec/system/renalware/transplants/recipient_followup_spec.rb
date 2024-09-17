# frozen_string_literal: true

describe "RecipientFollowup", js: true do
  include AjaxHelpers
  let(:patient) { create(:transplant_patient, family_name: "Rabbit", local_patient_id: "KCH12345") }
  let(:operation) { create(:transplant_recipient_operation, patient: patient) }

  describe "creating a new followup for an operation" do
    it "a new one will be be created" do
      user = login_as_clinical
      operation
      treatment = create(:transplant_rejection_treatment, name: "Treatment A")

      visit patient_transplants_recipient_dashboard_path(patient)

      within "article.recipient-operations" do
        click_on "Enter details"
      end
      fill_in "Stent Removal Date", with: "2019-01-01"
      fill_in "Date of Transplant Failure", with: "2019-01-02"
      fill_in "Date of Graft Nephrectomy", with: "2019-01-03"

      within ".rejection-episodes" do
        # Add an episode, remove it, then add again, to test the Remove button
        expect(page).to have_css(".rejection-episode", count: 0)
        click_on t("btn.add")
        wait_for_ajax
        expect(page).to have_css(".rejection-episode", count: 1)
        click_on "Remove"
        wait_for_ajax
        expect(page).to have_css(".rejection_episode", count: 0)
        click_on t("btn.add")
        wait_for_ajax
        expect(page).to have_css(".rejection-episode", count: 1)

        fill_in "Recorded on", with: "01-03-2018"
        fill_in "Notes", with: "xyz"
        select "Treatment A", from: "Treatment given"
      end

      within ".form-actions", match: :first do
        click_on t("btn.create")
      end

      expect(page).to have_current_path(patient_transplants_recipient_dashboard_path(patient))
      followup = operation.reload.followup
      expect(followup).to have_attributes(
        stent_removed_on: Time.zone.parse("2019-01-01").to_date,
        transplant_failed_on: Time.zone.parse("2019-01-02").to_date,
        graft_nephrectomy_on: Time.zone.parse("2019-01-03").to_date
      )
      expect(followup.rejection_episodes.count).to eq(1)
      expect(followup.rejection_episodes.first).to have_attributes(
        recorded_on: Time.zone.parse("01-03-2018").to_date,
        notes: "xyz",
        treatment_id: treatment.id,
        updated_by: user,
        created_by: user
      )
    end
  end

  describe "editing an existing followup" do
    it "updates the followup and any changed/removed rejection episodes; preserves others" do
      other_user = create(:user)
      me = login_as_clinical
      followup = create(
        :transplant_recipient_followup,
        operation: operation,
        stent_removed_on: "2019-01-01"
      )
      rejection_episodes = [
        create(
          :transplant_rejection_episode,
          followup: followup,
          by: other_user,
          notes: "1xx",
          recorded_on: "2019-02-01"
        ),
        create(
          :transplant_rejection_episode,
          followup: followup,
          by: other_user,
          notes: "3xx",
          recorded_on: "2019-02-03"
        )
      ]

      visit patient_transplants_recipient_dashboard_path(patient)

      within "article.recipient-operations" do
        click_on t("btn.update")
      end

      # Update one followup field only as a sanity check
      fill_in "Stent Removal Date", with: "2019-03-03"

      within ".rejection-episodes" do
        # There shold be 3 previously-creaated rejection episodes
        expect(page).to have_css(".rejection-episode", count: 2)

        # Leave the first one untouched. This means its content and updated_by should remain
        # unchanged after we save.

        # Update something in the third one. Changes and the updated-by will change
        within "[data-rejection_episode_id='#{rejection_episodes[1].id}']" do
          fill_in "Recorded on", with: "01-06-2019"
          fill_in "Notes", with: "3changed"
        end
      end

      within ".form-actions", match: :first do
        click_on t("btn.save")
      end

      expect(page).to have_current_path(patient_transplants_recipient_dashboard_path(patient))

      followup.reload
      expect(followup).to have_attributes(
        stent_removed_on: Time.zone.parse("2019-03-03").to_date
      )
      # 1st was unchanged
      # 2nd was deleted
      # 3rd was updated
      expect(followup.rejection_episodes.count).to eq(2)
      expect(followup.rejection_episodes.last.updated_by).to eq(me)
    end
  end
end
