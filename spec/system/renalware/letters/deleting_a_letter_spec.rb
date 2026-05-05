# Until it is archived, a letter can be deleted.

RSpec.describe "Deleting a letter", :js do
  let(:doctor) { create(:user, :clinical) }
  let(:other_doctor) { create(:user, :clinical) }
  let(:super_admin) { create(:user, :super_admin) }
  let(:patient) { letter.patient }

  context "when letter is pending review" do
    let(:letter) { create(:pending_review_letter, by: doctor) }

    it "is deleted by the author" do
      login_as doctor
      visit patient_letters_letters_path(patient)

      expect(page).to have_text "Pending Review"
      accept_alert { click_on t("btn.delete") }
      expect(page).to have_text "Letters"
      expect(page).to have_no_text "Pending Review"
      expect(Renalware::Letters::Letter.with_deleted.count).to eq(0)
    end

    context "when logged in as someone else" do
      it "cannot be deleted" do
        login_as other_doctor
        visit patient_letters_letters_path(patient)

        expect(page).to have_text "Pending Review"
        expect(page).to have_no_button t("btn.delete")
      end
    end
  end

  context "when letter is approved" do
    let(:letter) { create(:approved_letter, by: doctor) }

    context "when logged in as regular user" do
      it "cannot be deleted" do
        login_as doctor
        visit patient_letters_letters_path(patient)

        expect(page).to have_text "Approved"
        expect(page).to have_no_button t("btn.delete")
      end
    end

    context "when logged in as super admin" do
      it "can be deleted and updates letters count in navigation" do
        login_as super_admin
        visit patient_letters_letters_path(patient)

        within(".patient-side-nav") do
          expect(page).to have_text("Letters (1)")
        end

        expect(page).to have_text "Approved"
        expect(page).to have_link t("btn.delete")

        accept_alert { first(:link, t("btn.delete")).click }
        expect(page).to have_text "Letters"

        within(".patient-side-nav") do
          expect(page).to have_text("Letters (0)")
        end

        expect(Renalware::Letters::Letter.with_deleted.count).to eq(1)
        expect(Renalware::Letters::Letter.count).to eq(0)
      end
    end
  end
end
