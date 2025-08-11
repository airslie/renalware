module Renalware
  module HD
    describe WitnessForm do
      subject(:form) do
        described_class.new(
          user_id: witness.id,
          password: "password",
          prescription_administration_id: administration.id,
          update_user_only: false
        )
      end

      let(:administrating_user) {
        build_stubbed(:user, password: "password", password_confirmation: "password")
      }
      let(:administration) {
        build_stubbed(
          :hd_prescription_administration,
          witnessed_by_id: nil,
          administered_by_id: administrating_user.id
        )
      }
      let(:witness) {
        build_stubbed(:user, password: "password", password_confirmation: "password")
      }

      before do
        allow(User).to receive(:find).with(witness.id).and_return(witness)
        allow(User).to receive(:find).with(administrating_user.id).and_return(administrating_user)
        allow(PrescriptionAdministration)
          .to receive(:find).with(administration.id).and_return(administration)
      end

      describe "validations" do
        context "when update_user_only is true" do
          before { form.update_user_only = true }

          it { is_expected.to be_valid }
          it { is_expected.not_to validate_presence_of(:password) }

          it "validates that the witness is not the administering user" do
            form.user_id = administration.administered_by_id

            expect(form).not_to be_valid
            expect(form.errors[:user_id])
              .to include("Cannot be the user who administered the prescription")
          end
        end

        context "when update_user_only is false" do
          before { form.update_user_only = false }

          it { is_expected.to be_valid }
          it { is_expected.to validate_presence_of(:password) }

          it "validates that the witness is not the administering user" do
            form.user_id = administration.administered_by_id

            expect(form).not_to be_valid
            expect(form.errors[:user_id])
              .to include("Cannot be the user who administered the prescription")
          end

          it "validates that the password is correct for the witness" do
            allow(witness).to receive(:valid_password?).with("password").and_return(false)

            expect(form).not_to be_valid
            expect(form.errors[:password]).to include("Invalid password")
          end
        end
      end
    end
  end
end
