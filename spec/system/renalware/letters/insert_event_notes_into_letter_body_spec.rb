describe "Insert letter.event notes (e.g. from a clinic visit) into the letter body", :js do
  before do
    login_as_clinical
  end

  let(:patient) { create(:letter_patient) }

  class MyClinicVisit
    include ActiveModel::Model

    def notes
      "some notes"
    end

    def id
      0 # no op
    end

    def to_partial_path
      "black_hole"
    end
  end

  describe "clicking the button to insert event notes" do
    context "when the letter has an event with some notes" do
      it "inserts the notes into the letter body" do
        # Simulate something similar to a ClinicVisit being associated with the Letter
        # We don't use a 'real' Clinics::Visit as its in a different module.
        my_clinic_visit = MyClinicVisit.new
        decorator = Renalware::Letters::Event::ClinicVisit.new(
          my_clinic_visit,
          clinical: true
        )
        expect_any_instance_of(Renalware::Letters::Letter)
          .to receive(:event)
          .exactly(:twice)
          .and_return(decorator)

        visit new_patient_letters_letter_path(patient)

        link_text = "Insert my clinic visit notes"
        expect(page).to have_content(link_text)

        trix_editor = page.find("trix-editor")
        expect(trix_editor.text).to eq ""

        click_on(link_text)

        expect(trix_editor.text).to eq(my_clinic_visit.notes)
      end
    end
  end
end
