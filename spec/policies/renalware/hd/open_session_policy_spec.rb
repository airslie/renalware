require "rails_helper"

module Renalware
  module HD
    describe OpenSessionPolicy, type: :policy do
      subject { described_class }
      let(:user) { FactoryGirl.build(:user, :super_admin) }
      let(:session) { HD::Session::Closed.new }

      [:edit?, :destroy?].each do |permission|
        permissions permission do
          it "no permitted if session unsaved" do
            expect(subject).to_not permit(user, session)
          end
          it "permitted if session saved" do
            allow(session).to receive(:persisted?).and_return(true)
            expect(subject).to permit(user, session)
          end
        end
      end
    end
  end
end
