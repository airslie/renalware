module Renalware::Events
  describe Event do
    subject(:event) { described_class.new }

    it_behaves_like "an Accountable model"
    it_behaves_like "a Paranoid model"

    it :aggregate_failures do
      is_expected.to validate_presence_of(:patient)
      is_expected.to validate_presence_of(:date_time)
      is_expected.to validate_presence_of(:event_type_id)
      is_expected.to respond_to(:type)
      is_expected.to belong_to(:patient).touch(true)
      is_expected.to validate_timeliness_of(:date_time)
      is_expected.to be_versioned
    end

    describe "#document jsonb" do
      subject { event.document }

      it { is_expected.to be_nil }

      # ArgumentError:
      # The be_a_kind_of matcher requires that the actual object responds to either #kind_of?
      # or #is_a? methods but it responds to neigher of two methods.
      # it { is_expected.to be_a(Renalware::NullObject) }
    end

    describe "class method .subtypes?" do
      it "defaults to false" do
        expect(described_class.subtypes?).to be(false)
      end
    end
  end
end
