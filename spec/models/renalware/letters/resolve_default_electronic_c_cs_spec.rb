module Renalware
  module Letters
    describe ResolveDefaultElectronicCCs do
      subject(:resolver) { described_class.for(patient) }

      let(:patient) { build_stubbed(:letter_patient) }

      class Listener
        def request_default_electronic_cc_recipients_for_use_in_letters(args)
          args[:array_of_user_ids].push "6"
        end
      end

      describe "#call" do
        it "returns an empty array when there are no subscribers" do
          expect(resolver.call).to eq([])
        end

        it "returns values added by subscribers" do
          listener = Listener.new

          resolver.subscribe(listener)

          expect(resolver.call).to eq(["6"])
        end
      end
    end
  end
end
