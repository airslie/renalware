module Renalware
  describe UniformResourceNaming do # rubocop:disable RSpec/SpecFilePathFormat
    let(:test_class) { Class.new { include Renalware::UniformResourceNaming } }

    describe "#uid_urn" do
      [
        ["b19fb432-6750-40f8-aad2-987375e88c2d", "urn:uuid:b19fb432-6750-40f8-aad2-987375e88c2d"],
        ["bla", "urn:uuid:bla"],
        ["", nil],
        [nil, nil]
      ].each do |uuid, expected|
        it { expect(test_class.new.uuid_urn(uuid)).to eq(expected) }
      end
    end

    describe "ods_urn" do
      [
        ["P123", nil, "urn:nhs-uk:addressing:ods:P123"],
        ["P123", "", "urn:nhs-uk:addressing:ods:P123"],
        ["P123", "G456", "urn:nhs-uk:addressing:ods:P123:G456"]
      ].each do |practice_code, gmc_number, expected|
        it {
          expect(
            test_class
              .new
              .ods_urn(
                practice_code: practice_code,
                gmc_number: gmc_number
              )
          ).to eq(expected)
        }
      end
    end

    describe "renalware_urn" do
      it do
        [
          ["RAJ", build_stubbed(:user, id: 123), "urn:renalware:raj:user:123"],
          [nil, build_stubbed(:user, id: 123), "urn:renalware:unk:user:123"],
          ["", build_stubbed(:user, id: 123), "urn:renalware:unk:user:123"],
          [
            "raj",
            build_stubbed(:prescription, id: 123),
            "urn:renalware:raj:medication_prescription:123"
          ]
        ].each do |hosp_ods_code, model, expected|
          allow(Renalware.config).to receive(:ukrdc_site_code).and_return(hosp_ods_code)
          expect(test_class.new.renalware_urn(model: model)).to eq(expected)
        end
      end
    end
  end
end
