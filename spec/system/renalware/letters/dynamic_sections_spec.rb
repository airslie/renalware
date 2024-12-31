module Renalware
  describe "Manage dynamic sections - HDSection,..", :js do
    include LettersSpecHelper

    let(:user) { create(:user, :clinical) }
    let(:patient) { create(:patient) }
    let(:topic_with_section) {
      create(:letter_topic, text: "Main Topic", section_identifiers: [:hd_section])
    }
    let(:topic_without_section) {
      create(:letter_topic, text: "Topic without section")
    }
    let(:letterhead) { create(:letter_letterhead, name: "Letterhead") }
    let(:hospital_unit) { create(:hospital_unit, name: "UNIT A", unit_code: "U_CODE") }
    let(:hd_profile) {
      create(:hd_profile, hospital_unit: hospital_unit,
                          patient: Renalware::HD.cast_patient(patient),
                          prescribed_time: 300)
    }

    context "when user creates a letter with topic that has sections associated with it" do
      before do
        topic_with_section && topic_without_section && letterhead && hd_profile
      end

      it "embeds the topic content in the letter" do
        login_as user

        visit patient_letters_letters_path(patient)

        click_button t("btn.create_")
        click_link "Simple Letter"

        select "Letterhead", from: "Letterhead"
        slim_select "Main Topic", from: "Topic"

        within "article", text: "HD" do
          expect(page).to have_content "HD Unit\nU_CODE\nTime\n5:00"
        end

        submit_form

        preview_letter_page = current_path.dup
        visit "#{current_path}/formatted"
        within "section", text: "HD" do
          expect(page).to have_content "HD Unit\nU_CODE\nTime\n5:00"
        end

        visit preview_letter_page
        click_link "Edit"

        within "article", text: "HD" do
          expect(page).to have_content "HD Unit\nU_CODE\nTime\n5:00"
        end

        # Let's change some of the data to check the diff
        hospital_unit.update(unit_code: "Another Code")
        hd_profile.update(prescribed_time: 99, by: user)

        page.refresh

        within "article", text: "HD" do
          expect(page).to have_content "HD Unit\nU_CODE\nTime\n5:00"
          expect(page).to have_content "HD Unit\nAnother Code\nTime\n1:39"
        end

        # Save, and check that the data hasn't changed
        submit_form

        click_link "Edit"

        within "article", text: "HD" do
          expect(page).to have_content "HD Unit\nU_CODE\nTime\n5:00"
          expect(page).to have_content "HD Unit\nAnother Code\nTime\n1:39"
        end

        # Now use the toggle to apply updates
        within "article", text: "HD" do
          find("label", text: "Use updates below").click
        end

        submit_form

        click_link "Edit"

        within "article", text: "HD" do
          expect(page).to have_no_content "HD Unit\nU_CODE\nTime\n5:00"
          expect(page).to have_content "HD Unit\nAnother Code\nTime\n1:39"
        end

        # Change to a topic which doesn't have a section
        slim_select "Topic without section", from: "Topic"
        expect(page).to have_no_content "HD Unit\nU_CODE\nTime\n1:39"
      end
    end
  end
end
