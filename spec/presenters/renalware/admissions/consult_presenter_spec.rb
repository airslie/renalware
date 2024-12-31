module Renalware
  module Admissions
    describe ConsultPresenter do
      describe ".location" do
        it "joins site ward and other location when all present" do
          site = ConsultSite.new(name: "Site")
          ward = Hospitals::Ward.new(name: "Ward")
          consult = Consult.new(
            consult_site: site,
            hospital_ward: ward,
            other_site_or_ward: "Other"
          )
          expect(described_class.new(consult).location).to eq("Site, Ward, Other")
        end

        it "returns just #other_site_or_ward when consult site and ward missing" do
          consult = Consult.new(
            consult_site: nil,
            hospital_ward: nil,
            other_site_or_ward: "Other"
          )
          expect(described_class.new(consult).location).to eq("Other")
        end
      end
    end
  end
end
