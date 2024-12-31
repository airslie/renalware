module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::ClinicVisitObservation do
        include XmlSpecHelper

        describe "e.g. height" do
          context "when nil" do
            it "renders nothing" do
              visit = instance_double(Clinics::ClinicVisit, height: nil)

              xml = described_class.new(visit: visit, method: :height).xml

              expect(xml).to be_nil
            end
          end

          context "when 0.0" do
            it "renders nothing" do
              visit = instance_double(Clinics::ClinicVisit, height: 0.0)

              xml = described_class.new(visit: visit, method: :height).xml

              expect(xml).to be_nil
            end
          end

          context "when a string" do
            it "renders nothing" do
              visit = instance_double(Clinics::ClinicVisit, height: "aaaaaaaaaaaaa")

              xml = described_class.new(visit: visit, method: :height).xml

              expect(xml).to be_nil
            end
          end

          context "when the value evaluates as a number but is actually longer than 20 chars" do
            it "renders nothing" do
              visit = instance_double(
                Clinics::ClinicVisit,
                height: "123                 123",
                datetime: Time.zone.parse("2019-01-01 00:00:01"),
                updated_by: nil
              )

              xml = format_xml(described_class.new(visit: visit, method: :height).xml)

              expect(xml).to match("<ObservationValue>123</ObservationValue>")
            end
          end
        end
      end
    end
  end
end
