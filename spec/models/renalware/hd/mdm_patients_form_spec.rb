# frozen_string_literal: true

module Renalware::HD
  describe MDMPatientsForm do
    describe "#options" do
      describe "hospital_unit_id" do
        it "maps to a ransack predicate" do
          options = described_class.new(hospital_unit_id: "1").ransacked_parameters
          expect(options[:hd_profile_hospital_unit_id_eq]).to eq(1)
        end
      end

      describe "schedule" do
        context "when a schedule definition id eg 'Mon Wed Fri PM' was chosen" do
          it "maps to a ransack predicate so we can query for patients having the matching " \
             "schedule definition" do
            options = described_class.new(schedule_definition_ids: "[1]").ransacked_parameters
            expect(options[:hd_profile_schedule_definition_id_in]).to eq([1])
          end
        end

        context "when 'Mon Wed Fri' (representing an array of possible schedule ids including " \
                "AM PM EVE etc on that day" do
          it "maps to a ransack predicate" do
            options = described_class.new(schedule_definition_ids: "[1 ,2, 3]").ransacked_parameters
            expect(options[:hd_profile_schedule_definition_id_in]).to eq([1, 2, 3])

            options = described_class.new(schedule_definition_ids: "[1,2,3]").ransacked_parameters
            expect(options[:hd_profile_schedule_definition_id_in]).to eq([1, 2, 3])
          end
        end
      end
    end
  end
end
