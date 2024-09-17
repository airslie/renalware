# frozen_string_literal: true

# rubocop:disable Style/WordArray
module Renalware
  module UKRDC
    describe Incoming::XmlDocument do
      include UKRDCSpecHelper

      subject(:doc) { described_class.new(file) }

      let(:file) { file_fixture("ukrdc/incoming/example.xml") }

      describe "#nhs_number" do
        subject { doc.nhs_number }

        it { is_expected.to eq("9999999999") }
      end

      describe "#dob" do
        subject { doc.dob }

        it { is_expected.to eq("2000-01-01T00:00:00") }
      end

      describe "#family_name" do
        subject { doc.family_name }

        it { is_expected.to eq("SURNAME") }
      end

      describe "#surveys" do
        subject { doc.surveys }

        it do
          is_expected.to eq(
            [
              {
                code: "PROM",
                time: "2018-03-20T00:00:00",
                responses: {
                  "YSQ1" => "0", "YSQ2" => "0", "YSQ3" => "0", "YSQ4" => "0", "YSQ5" => "0",
                  "YSQ6" => "0", "YSQ7" => "0", "YSQ8" => "0", "YSQ9" => "0", "YSQ10" => "0",
                  "YSQ11" => "0", "YSQ12" => "1", "YSQ13" => "0", "YSQ14" => "0", "YSQ15" => "0",
                  "YSQ16" => "2", "YSQ17" => "0",
                  "YSQ18" => ["1", "Headaches"],
                  "YSQ19" => ["2", "Paranoia"],
                  "YSQ20" => ["3", "Loss of Appetite"],
                  "YSQ21" => "Constipation", "YSQ22" => "Itching"
                }
              },
              {
                code: "EQ5D",
                time: "2018-03-20T00:00:00",
                responses: {
                  "YOHQ1" => "1", "YOHQ2" => "1", "YOHQ3" => "2",
                  "YOHQ4" => "3", "YOHQ5" => "1", "YOHQ6" => "77"
                }
              }
            ]
          )
        end
      end
    end
  end
end
# rubocop:enable Style/WordArray
