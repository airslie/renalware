# frozen_string_literal: true

module Renalware
  describe SystemUser do
    describe ".find" do
      let!(:system_user) { create(:user, username: described_class.username) }

      it "finds the system user" do
        expect(described_class.find).to eq(system_user)
      end
    end
  end
end
