# frozen_string_literal: true

module Renalware
  describe UsersHelper do
    describe "current_user_is_super_admin?" do
      context "with a super admin user" do
        let(:current_user) { create(:user, :super_admin) }

        it "is true" do
          expect(current_user_is_super_admin?).to be true
        end
      end

      context "with an admin user" do
        let(:current_user) { create(:user, :admin) }

        it "is false" do
          expect(current_user_is_super_admin?).to be false
        end
      end
    end

    describe "current_user_is_admin?" do
      context "with a super admin user" do
        let(:current_user) { create(:user, :super_admin) }

        it "is true" do
          expect(current_user_is_admin?).to be true
        end
      end

      context "with an admin user" do
        let(:current_user) { create(:user, :admin) }

        it "is true" do
          expect(current_user_is_admin?).to be true
        end
      end

      context "with a clinician" do
        let(:current_user) { create(:user, :clinical) }

        it "is false" do
          expect(current_user_is_admin?).to be false
        end
      end
    end
  end
end
