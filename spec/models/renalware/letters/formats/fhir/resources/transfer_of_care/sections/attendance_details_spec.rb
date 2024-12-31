module Renalware
  module Letters
    module Formats::FHIR
      module Resources::TransferOfCare
        describe Sections::AttendanceDetails do
          subject(:section) { described_class.new(nil) }

          it { expect(section.snomed_code).to eq("1077881000000105") }
          it { expect(section.title).to eq("Attendance details") }
          it { expect(section.render?).to be(true) }
        end
      end
    end
  end
end
