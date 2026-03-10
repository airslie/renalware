module Renalware
  module Feeds
    describe RawHL7MessageErrorPolicy, type: :policy do
      include PolicySpecHelper

      subject(:policy) { described_class }

      let(:record) { RawHL7MessageError.new(body: "MSH", sent_at: Time.zone.now) }

      permissions :index?, :show? do
        it { is_expected.to permit(user_double_with_role(:super_admin), record) }
        it { is_expected.not_to permit(user_double_with_role(:admin), record) }
        it { is_expected.not_to permit(user_double_with_role(:clinical), record) }
        it { is_expected.not_to permit(user_double_with_role(:read_only), record) }
      end
    end
  end
end
