module Renalware
  module HD
    # rubocop:disable RSpec/DescribedClass
    describe PrescriptionAdministration do
      let(:witnessed_by) { User.new }
      let(:administered_by) { User.new }

      before do
        allow(Renalware.config)
          .to receive(:hd_session_prescriptions_require_signoff)
          .and_return(true)
        allow(Renalware.config).to receive_messages(
          database_authentication_enabled?: true,
          ldap_authentication_enabled?: false
        )
      end

      it_behaves_like "an Accountable model"

      it :aggregate_failures do
        is_expected.to belong_to(:prescription)
        is_expected.to belong_to(:hd_session).touch(true)
        is_expected.to belong_to(:reason)
        is_expected.to validate_presence_of(:prescription)
        is_expected.to validate_presence_of(:recorded_on)
      end

      shared_examples_for "no validation on administrator or witness" do
        it "does not validate the presence of administered_by" do
          expect(errors[:administered_by]).to be_empty
        end

        it "does not validate the presence of witnessed_by" do
          expect(errors[:witnessed_by]).to be_empty
        end
      end

      context "when administered is false" do
        describe "validation errors" do
          subject(:errors) do
            described_class.new(
              administered: false
            ).tap(&:valid?).errors
          end

          it_behaves_like "no validation on administrator or witness"
        end
      end

      describe "validation errors" do
        subject(:errors) do
          PrescriptionAdministration.new(
            administered: true,
            administered_by:,
            witnessed_by:,
            administered_by_password:,
            witnessed_by_password:
          ).tap(&:valid?).errors
        end

        let(:administered_by) { User.new(password: administered_by_password) }
        let(:witnessed_by) { User.new(password: witnessed_by_password) }
        let(:administered_by_password) { "123" }
        let(:witnessed_by_password) { "456" }

        %i(administered_by witnessed_by).each do |user|
          password_attr_name = :"#{user}_password"

          describe password_attr_name do
            context "when #{user} is missing" do
              let(:"#{user}") { nil }

              it "does not validate the password" do
                expect(errors[password_attr_name]).to be_empty
              end
            end

            context "when no password is present" do
              let(:"#{password_attr_name}") { nil }

              it "is not valid" do
                expect(errors[password_attr_name]).to eq(["Invalid password"])
              end
            end

            context "when the #{user} passwords match" do
              it "is valid" do
                expect(errors[password_attr_name]).to be_empty
              end
            end

            context "when the actual and submitted #{user} passwords don't match" do
              let(:"#{user}") { User.new(password: "MontyDon") }

              it "is not valid" do
                expect(errors[password_attr_name]).to eq(["Invalid password"])
              end
            end
          end
        end

        context "when administrator and witness is are the same" do
          it "does not allow this" do
            pwd = "password"
            user = create(:user, password: "password")
            errors = described_class.new(
              administered: true,
              administered_by: user,
              witnessed_by: user,
              administered_by_password: pwd,
              witnessed_by_password: pwd
            ).tap(&:valid?).errors

            expect(errors[:witnessed_by_id]).to eq(["Must be a different user"])
          end
        end

        context "when LDAP authentication is enabled" do
          let(:admin_user) { create(:user, username: "admin_user") }
          let(:witness_user) { create(:user, username: "witness_user") }
          let(:admin_ldap_connection) { instance_double(Ldap::Connection) }
          let(:witness_ldap_connection) { instance_double(Ldap::Connection) }

          before do
            allow(Renalware.config).to receive_messages(
              database_authentication_enabled?: false,
              ldap_authentication_enabled?: true
            )
            allow(Ldap::Connection).to receive(:new)
              .with(username: "admin_user", password: anything)
              .and_return(admin_ldap_connection)
            allow(Ldap::Connection).to receive(:new)
              .with(username: "witness_user", password: anything)
              .and_return(witness_ldap_connection)
          end

          it "validates administrator password against LDAP" do
            allow(admin_ldap_connection).to receive(:valid_credentials?)
              .and_return(true)
            allow(witness_ldap_connection).to receive(:valid_credentials?)
              .and_return(true)

            administration = described_class.new(
              administered: true,
              administered_by: admin_user,
              witnessed_by: witness_user,
              administered_by_password: "ldap_admin_password",
              witnessed_by_password: "ldap_witness_password"
            )
            administration.valid?

            expect(administration.errors[:administered_by_password]).to be_empty
            expect(administration.errors[:witnessed_by_password]).to be_empty
            expect(administration.administrator_authorised).to be true
            expect(administration.witness_authorised).to be true
          end

          it "rejects invalid LDAP password for administrator" do
            allow(admin_ldap_connection).to receive(:valid_credentials?)
              .and_return(false)
            allow(witness_ldap_connection).to receive(:valid_credentials?)
              .and_return(true)

            administration = described_class.new(
              administered: true,
              administered_by: admin_user,
              witnessed_by: witness_user,
              administered_by_password: "wrong_admin_password",
              witnessed_by_password: "ldap_witness_password"
            )
            administration.valid?

            expect(administration.errors[:administered_by_password]).to eq(["Invalid password"])
            expect(administration.administrator_authorised).to be false
          end

          it "rejects invalid LDAP password for witness" do
            allow(admin_ldap_connection).to receive(:valid_credentials?)
              .and_return(true)
            allow(witness_ldap_connection).to receive(:valid_credentials?)
              .and_return(false)

            administration = described_class.new(
              administered: true,
              administered_by: admin_user,
              witnessed_by: witness_user,
              administered_by_password: "ldap_admin_password",
              witnessed_by_password: "wrong_witness_password"
            )
            administration.valid?

            expect(administration.errors[:witnessed_by_password]).to eq(["Invalid password"])
            expect(administration.witness_authorised).to be false
          end

          it "handles LDAP server errors gracefully" do
            allow(admin_ldap_connection).to receive(:valid_credentials?)
              .and_raise(Renalware::Ldap::Error.new("LDAP server unreachable"))
            allow(witness_ldap_connection).to receive(:valid_credentials?)
              .and_raise(Renalware::Ldap::Error.new("LDAP server unreachable"))
            allow(Rails.logger).to receive(:error)

            administration = described_class.new(
              administered: true,
              administered_by: admin_user,
              witnessed_by: witness_user,
              administered_by_password: "any_password",
              witnessed_by_password: "any_password"
            )
            administration.valid?

            expect(administration.errors[:administered_by_password]).to eq(
              [I18n.t("renalware.system.errors.ldap.service_unavailable")]
            )
            expect(administration.errors[:witnessed_by_password]).to eq(
              [I18n.t("renalware.system.errors.ldap.service_unavailable")]
            )
            expect(administration.administrator_authorised).to be false
            expect(administration.witness_authorised).to be false
          end
        end
      end

      context "when witnesses are not required" do
        before do
          allow(Renalware.config)
            .to receive(:hd_session_prescriptions_require_signoff)
            .and_return(false)
        end

        it "is valid without a witness" do
          admin_user = create(:user, password: "password")
          administration = described_class.new(
            administered: true,
            administered_by: admin_user,
            administered_by_password: "password",
            prescription: create(:prescription),
            recorded_on: Time.zone.today
          )

          expect(administration).to be_valid
        end

        it "sets signed_off_at when administrator validates" do
          admin_user = create(:user, password: "password")
          administration = described_class.new(
            administered: true,
            administered_by: admin_user,
            administered_by_password: "password",
            prescription: create(:prescription),
            recorded_on: Time.zone.today
          )
          administration.valid?

          expect(administration.signed_off_at).to be_present
          expect(administration).to be_authorised
        end
      end

      context "when witnesses are required" do
        before do
          allow(Renalware.config)
            .to receive(:hd_session_prescriptions_require_signoff)
            .and_return(true)
        end

        it "sets signed_off_at when both administrator and witness validate" do
          admin_user = create(:user, password: "admin_password")
          witness_user = create(:user, password: "witness_password")
          administration = described_class.new(
            administered: true,
            administered_by: admin_user,
            administered_by_password: "admin_password",
            witnessed_by: witness_user,
            witnessed_by_password: "witness_password",
            prescription: create(:prescription),
            recorded_on: Time.zone.today
          )
          administration.valid?

          expect(administration.signed_off_at).to be_present
          expect(administration).to be_authorised
        end

        it "does not set signed_off_at when saved with skip_witness_validation" do
          admin_user = create(:user, password: "password")
          administration = described_class.new(
            administered: true,
            administered_by: admin_user,
            administered_by_password: "password",
            skip_witness_validation: true,
            prescription: create(:prescription),
            recorded_on: Time.zone.today
          )
          administration.valid?

          expect(administration.signed_off_at).to be_nil
          expect(administration).not_to be_authorised
        end
      end

      context "when the HD prescription is stat (give once)" do
        let(:pwd) { "password" }
        let(:user1) { create(:user, password: pwd) }
        let(:user2) { create(:user, password: pwd) }
        let(:prescription) { create(:prescription, administer_on_hd: true, stat: true) }

        before { create(:user, :system) }

        it "terminates if not already terminated" do
          expect {
            PrescriptionAdministration.create!(
              prescription:,
              administered: true,
              administered_by: user1,
              witnessed_by: user2,
              administered_by_password: pwd,
              witnessed_by_password: pwd,
              recorded_on: Time.zone.now,
              by: user1
            )
          }.to change(Medications::PrescriptionTermination, :count).by(1)
            .and change(prescription, :updated_at)

          expect(prescription.reload.termination).to have_attributes(
            terminated_on: Time.zone.today,
            notes: "Stat prescription automatically terminated once given"
          )
        end

        it "does not try to terminate if already terminated in the past" do
          terminated_on = 1.day.ago.to_date
          prescription.build_termination(terminated_on:, by: user1).save!

          expect {
            PrescriptionAdministration.create!(
              prescription:,
              administered: true,
              administered_by: user1,
              witnessed_by: user2,
              administered_by_password: pwd,
              witnessed_by_password: pwd,
              recorded_on: Time.zone.now,
              by: user1
            )
          }.not_to change(Medications::PrescriptionTermination, :count)
          expect(prescription.reload.termination.terminated_on).to eq(terminated_on)
        end

        it "does not try to terminate if already terminated today" do
          terminated_on = Time.zone.today
          prescription.build_termination(terminated_on:, by: user1).save!

          expect {
            PrescriptionAdministration.create!(
              prescription:,
              administered: true,
              administered_by: user1,
              witnessed_by: user2,
              administered_by_password: pwd,
              witnessed_by_password: pwd,
              recorded_on: Time.zone.today,
              by: user1
            )
          }.not_to change(Medications::PrescriptionTermination, :count)

          expect(prescription.reload.termination).to have_attributes(
            terminated_on:,
            updated_by: user1 # ie not system user
          )
        end

        it "sets the termination.terminated_on to Now if the termination has a future date " \
           "(likely, as we give a 14 day future termination date to stat drugs automatically)" \
           "so that that the prescription is stopped and can not be given again" do
          future_termination_date = 14.days.since
          recorded_on = Time.zone.today

          # Give the prescription a future term date
          prescription.build_termination(
            terminated_on: future_termination_date,
            by: user1
          ).save!

          expect {
            PrescriptionAdministration.create!(
              prescription:,
              administered: true,
              administered_by: user1,
              witnessed_by: user2,
              administered_by_password: pwd,
              witnessed_by_password: pwd,
              recorded_on:,
              by: user1
            )
          }.not_to change(Medications::PrescriptionTermination, :count)

          # Administering the stat+hd prescription will cause an existing termination to be adjusted
          # so it terminates immediately.
          expect(prescription.reload.termination).to have_attributes(
            terminated_on: recorded_on,
            updated_by: SystemUser.find,
            created_by: SystemUser.find
          )
        end
      end
    end
    # rubocop:enable RSpec/DescribedClass
  end
end
