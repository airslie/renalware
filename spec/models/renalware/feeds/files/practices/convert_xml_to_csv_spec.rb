# rubocop:disable Metrics/LineLength
require "rails_helper"
require "fileutils"

module Renalware
  module Feeds
    module Files
      module Practices
        describe ConvertXmlToCsv do
          it "converts HSCOrgRefData_Full*.xml into a CSV file" do
            uk = create(:united_kingdom)
            Dir.mktmpdir do |tempdir|
              fixture_xml_path = file_fixture("practices/HSCOrgRefData_Full_example.xml")

              tmp_xml_path = ::File.join(tempdir, "HSCOrgRefData_Full_example.xml")
              FileUtils.cp(fixture_xml_path, tmp_xml_path)
              tmp_xml_pathname = Pathname.new(tmp_xml_path)
              csv_path = described_class.call(tmp_xml_pathname)

              csv_content = ::File.read(csv_path)
              expect(csv_content).to eq(
                "code,name,telephone,street_1,street_2,street_3,city,county,postcode,region,country_id,active\n" \
                "J82022,VICTOR STREET SURGERY,023 80706919,VICTOR STREET,UPPER SHIRLEY,,SOUTHAMPTON,HAMPSHIRE,SO15 5SY,England,#{uk.id},true\n" \
                "Y04927,CULCHETH PRIMARY CARE CENTRE,01925 765349,JACKSON AVENUE,CULCHETH,,WARRINGTON,CHESHIRE,WA3 4DZ,England,#{uk.id},false\n"
              )
            end
          end
        end
      end
    end
  end
end
