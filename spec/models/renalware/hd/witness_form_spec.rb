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

          context "when LDAP authentication is enabled" do
            let(:ldap_adapter) { instance_double(Ldap::Adapter) }

            before do
              allow(Renalware.config).to receive(:ldap_authentication).and_return(true)
              allow(Ldap::Adapter).to receive(:new).and_return(ldap_adapter)
            end

            it "validates witness password against LDAP" do
              allow(ldap_adapter).to receive(:valid_credentials?)
                .with(witness.username, "ldap_password")
                .and_return(true)
              allow(witness).to receive(:valid_password?).with("ldap_password").and_call_original

              form.password = "ldap_password"

              expect(form).to be_valid
            end

            it "rejects invalid LDAP password for witness" do
              allow(ldap_adapter).to receive(:valid_credentials?)
                .with(witness.username, "wrong_password")
                .and_return(false)
              allow(witness).to receive(:valid_password?).with("wrong_password").and_call_original

              form.password = "wrong_password"

              expect(form).not_to be_valid
              expect(form.errors[:password]).to include("Invalid password")
            end

            it "handles LDAP server errors gracefully during witnessing" do
              allow(ldap_adapter).to receive(:valid_credentials?)
                .with(witness.username, "any_password")
                .and_raise(Renalware::Ldap::Error.new("LDAP server unreachable"))
              allow(witness).to receive(:valid_password?).with("any_password").and_call_original
              allow(Rails.logger).to receive(:error)

              form.password = "any_password"

              expect(form).not_to be_valid
              expect(form.errors[:password]).to include(
                I18n.t("renalware.system.errors.ldap.service_unavailable")
              )
            end
          end
        end
      end
    end
  end
end
