module Renalware
  module Pathology
    describe PatientPathologyScopes do
      describe "class methods" do
        describe "#pathology_result_sort_predicate" do
          it "creates a SQL coalesce statement that will map null results as -1" do
            # pending
            expect(
              Patient.include(described_class).pathology_result_sort_predicate(:HGB)
            ).to eq("coalesce(convert_to_float(values -> 'HGB' ->> 'result'), -1)")
          end
        end

        describe "#pathology_date_sort_predicate(column)" do
          it "creates a SQL statement to cast the column as a date so sorting is consistent" do
            expect(
              Patient.include(described_class).pathology_date_sort_predicate(:HGB)
            ).to eq "cast(values -> 'HGB' ->> 'observed_at' as date)"
          end
        end
      end
    end
  end
end
