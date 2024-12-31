describe "An author viewing their letters" do
  include LettersSpecHelper

  let(:patient) { create(:letter_patient, family_name: "RABBIT") }
  let(:another_patient) { create(:letter_patient, family_name: "JONES") }
  let(:another_user) { create(:user) }

  describe "GET index" do
    it "responds with an HTML list of letters for the curreent user" do
      create_letter(to: :patient, patient: patient, author: @current_user)
      create_letter(to: :patient, patient: another_patient, author: another_user)

      get author_letters_path(@current_user.id)

      expect(response).to be_successful
      expect(response.body).to include(patient.full_name)
      expect(response.body).not_to include(another_patient.full_name)
    end
  end
end
