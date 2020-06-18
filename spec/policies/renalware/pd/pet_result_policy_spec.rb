# frozen_string_literal: true

require "rails_helper"

module Renalware::PD
  describe PETResultPolicy, type: :policy do
    subject(:policy) { described_class }

    [:edit?, :destroy?].each do |permission|
      permissions permission do
        it "grants access if user super_admin" do
          expect(policy).to permit(create(:user, :super_admin))
        end

        it "grants access if user admin" do
          expect(policy).to permit(create(:user, :admin))
        end

        it "denies access if user clinician" do
          expect(policy).not_to permit(create(:user, :clinical))
        end

        it "denies access if user read_only" do
          expect(policy).not_to permit(create(:user, :read_only))
        end
      end
    end
  end
end
