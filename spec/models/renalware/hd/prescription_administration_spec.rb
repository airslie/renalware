# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe PrescriptionAdministration do
      let(:witnessed_by) { User.new }
      let(:administered_by) { User.new }

      before do
        allow(Renalware.config)
          .to receive(:hd_session_prescriptions_require_signoff)
          .and_return(true)
      end

      it_behaves_like "a Paranoid model"
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
            PrescriptionAdministration.new(
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
            administered_by: administered_by,
            witnessed_by: witnessed_by,
            administered_by_password: administered_by_password,
            witnessed_by_password: witnessed_by_password
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
          it "does not allo this" do
            pwd = "password"
            user = create(:user, password: "password")
            errors = PrescriptionAdministration.new(
              administered: true,
              administered_by: user,
              witnessed_by: user,
              administered_by_password: pwd,
              witnessed_by_password: pwd
            ).tap(&:valid?).errors

            expect(errors[:witnessed_by_id]).to eq(["Must be a different user"])
          end
        end
      end
    end
  end
end
