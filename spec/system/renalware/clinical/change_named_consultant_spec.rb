module Renalware
  module Clinical
    describe "Change a patient's named consultant", :js do
      context "when the patient has not named consultant" do
        it "adds a named consultant" do
          clinical_patient = create(:clinical_patient)
          login_as_clinical
          consultant = create(:user, :consultant)
          po = Pages::Clinical::ProfilePage.new(clinical_patient)

          po.edit
          po.named_consultant = consultant
          po.save

          expect(clinical_patient.reload.named_consultant).to eq(consultant)
        end
      end
    end
  end
end
