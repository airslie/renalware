

# rubocop:disable all
describe(
  "Administering drugs from HD Dashboard, independent of HD Session",
  type: :system,
  js: true
) do
  include AjaxHelpers
  let(:patient) { create(:hd_patient) }

  def create_prescription_for(patient, drug_name: "Drug1")
    create(
      :prescription,
      patient: patient,
      administer_on_hd: true,
      drug: create(:drug, name: drug_name)
    )
  end

  context "when the patient has a drug to be given on HD", js: true do
    context "when I click on the HD Drugs button and choose the drug" do
      let(:patient) { create(:hd_patient) }
      let(:prescription) { create_prescription_for patient }
      NO_WITNESS = false
      WITNESS = true
      ADMINISTERED = true
      UNADMINISTERED = false
      NOTES = "notes"
      SUCCESS = true
      FAILURE = false
      NO_WITNESS_PWD = ""
      NO_ADMIN_PWD = ""
      ERR_MISSING_ADMINISTERED = ".hd_prescription_administration_administered .error"
      ERR_MISSING_ADMIN_PWD = ".hd_prescription_administration_administered_by_password .error"
      ERR_MISSING_WITNESS = ".hd_prescription_administration_witnessed_by .error"
      ERR_MISSING_WITNESS_PWD = ".hd_prescription_administration_witnessed_by_password .error"
      PWD = "supersecret"

      # Trying a radical approach to feeding in different inputs and expectations here!
      {
        missing_administered: [
          nil,
          NO_ADMIN_PWD,
          NO_WITNESS,
          NO_WITNESS_PWD,
          NOTES, FAILURE,
          [ERR_MISSING_ADMINISTERED]
        ],
        not_administered: [
          UNADMINISTERED,
          NO_ADMIN_PWD,
          NO_WITNESS,
          NO_WITNESS_PWD,
          NOTES,
          SUCCESS,
          []
        ],
        administered_missing_admin_pwd: [
          ADMINISTERED,
          NO_ADMIN_PWD,
          NO_WITNESS,
          NO_WITNESS_PWD,
          NOTES,
          FAILURE,
          [ERR_MISSING_ADMIN_PWD, ERR_MISSING_WITNESS]
        ],
        administered_missing_witness_user: [
          ADMINISTERED,
          NO_ADMIN_PWD,
          NO_WITNESS,
          NO_WITNESS_PWD,
          NOTES,
          FAILURE,
          [ERR_MISSING_WITNESS]
        ],
        administered_missing_witness_pwd: [
          ADMINISTERED,
          "supersecret",
          WITNESS,
          NO_WITNESS_PWD,
          NOTES,
          FAILURE,
          [ERR_MISSING_WITNESS_PWD]
        ]
      }.each do |name, (administered, nurse_pwd, witness, witness_pwd, notes, success, errors)|
        it name do
          dialog = Pages::HD::PrescriptionAdministrationDialog.new(prescription: prescription)
          witnessed_by = create(:user) if witness
          current_user = login_as_clinical

          dialog.open_by_clicking_on_drug_name
          dialog.administered = administered
          dialog.witnessed_by = witnessed_by
          dialog.notes = notes
          dialog.save

          if success
            expect(page).not_to have_css(dialog.container_css)
            expect(Renalware::HD::PrescriptionAdministration.last).to have_attributes(
              administered: administered,
              notes: notes,
              witnessed_by: witnessed_by,
              witness_authorised: witnessed_by.present?
            )
          else
            expect(page).to have_css(dialog.container_css) # still visible
            Array(errors).each do |error_css|
              expect(page).to have_css(error_css)
            end
          end
        end
      end
    end
  end

  context "when the patient has a drug to be given on HD", js: true do
    context "when I click on the HD Drugs button and choose the drug" do
      it "displays a modal dialog asking for input, which I can cancel" do
        prescription = create_prescription_for patient
        dialog = Pages::HD::PrescriptionAdministrationDialog.new(prescription: prescription)
        login_as_clinical

        dialog.open_by_clicking_on_drug_name
        expect(dialog).to be_visible
        expect(dialog).to be_displaying_prescription
        dialog.cancel
        expect(dialog).not_to be_visible
      end

      context "when I indicate the drug was not given, and supply a reason", js: true do
        it "saves the prescription administration and updates the drugs table" do
          prescription = create_prescription_for patient
          reason = Renalware::HD::PrescriptionAdministrationReason.find_or_create_by!(name: "Cos")
          dialog = Pages::HD::PrescriptionAdministrationDialog.new(prescription: prescription)
          user = login_as_clinical
          visit renalware.patient_hd_dashboard_path(patient)

          dialog.open_by_clicking_on_drug_name
          expect(dialog).to be_visible
          dialog.administered = false
          dialog.recorded_on = "12-Apr-2020"
          dialog.not_administered_reason = reason.name
          dialog.notes = "abc"

          # Choosing Administered = No should have changed the save button text to Save
          # and hidden the 'Save and witness later' button
          expect(dialog.save_button_captions).to eq ["Save"]
          dialog.save

          expect(page).not_to have_css(dialog.container_css)

          # A not-administered drug has been recorded
          expect(patient.prescription_administrations.reload.last).to have_attributes(
            administered: false,
            reason: reason,
            prescription: prescription,
            notes: "abc",
            created_by_id: user.id,
            updated_by_id: user.id,
            recorded_on: Date.parse("12-Apr-2020"),
            administered_by: nil,
            witnessed_by: nil,
            administrator_authorised: false,
            witness_authorised: false
          )
        end
      end

      context "when drug WAS given, but user elects to witness later", js: true do
        it "saves the prescription administration and updates the drugs table" do
          password = "renalware"
          nurse = create(:user, password: password)
          prescription = create_prescription_for patient
          dialog = Pages::HD::PrescriptionAdministrationDialog.new(prescription: prescription)
          user = login_as_clinical

          dialog.open_by_clicking_on_drug_name
          expect(dialog).to be_visible
          dialog.administered = true
          dialog.notes = "abc"
          dialog.administered_by = nurse
          dialog.administered_by_password = password

          expect(dialog.save_button_captions).to eq(["Save", "Save and Witness Later"])

          dialog.save_and_witness_later

          # dialog gone - need to test this way
          expect(page).not_to have_css(dialog.container_css)

          # An administered drug is recorded
          expect(patient.prescription_administrations.reload.first).to have_attributes(
            administered: true,
            reason: nil,
            prescription: prescription,
            notes: "abc",
            created_by_id: user.id,
            updated_by_id: user.id,
            administered_by: nurse,
            recorded_on: Date.current, # the default dorm value defaults to today
            witnessed_by: nil,
            administrator_authorised: true,
            witness_authorised: false
          )
        end
      end

      context "when drug WAS given, AND witness is present to enter their credentials", js: true do
        it "saves the prescription administration and updates the drugs table" do
          password = "renalware"
          nurse = create(:user, password: password)
          witness = create(:user, password: password)
          prescription = create_prescription_for patient
          dialog = Pages::HD::PrescriptionAdministrationDialog.new(prescription: prescription)
          user = login_as_clinical

          dialog.open_by_clicking_on_drug_name

          expect(dialog).to be_visible
          dialog.administered = true
          dialog.notes = "abc"
          dialog.administered_by = nurse
          dialog.administered_by_password = password
          dialog.witnessed_by = witness
          dialog.witnessed_by_password = password

          expect(dialog.save_button_captions).to eq(["Save", "Save and Witness Later"])

          dialog.save

          # dialog gone - need to test this way
          expect(page).not_to have_css(dialog.container_css)

          # An administered drug is recorded
          expect(patient.prescription_administrations.reload.first).to have_attributes(
            administered: true,
            reason: nil,
            prescription: prescription,
            notes: "abc",
            created_by_id: user.id,
            updated_by_id: user.id,
            administered_by: nurse,
            witnessed_by: witness,
            administrator_authorised: true,
            witness_authorised: true
          )
        end
      end
    end
  end

  describe "default nurse" do
    context "when displaying the dialog for recoding an HD prescription was given" do
      it "defaults the Nurse to the currently logged-in user" do
        prescription = create_prescription_for patient
        dialog = Pages::HD::PrescriptionAdministrationDialog.new(prescription: prescription)
        user = login_as_clinical

        dialog.open_by_clicking_on_drug_name

        expect(dialog.administered_by_id).to eq(user.id)
      end
    end
  end
end
# rubocop:enable all
