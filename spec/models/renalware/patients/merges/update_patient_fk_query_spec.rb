module Renalware
  describe Patients::Merges::UpdatePatientFkQuery do
    subject(:query) do
      operation = Renalware::Patients::Merges::Operation.new(
        :patients_merges_operation,
        column_reference: ColumnReference.new(schema, table, column),
        major_patient_id: major_patient_id,
        minor_patient_id: minor_patient_id
      )
      described_class.new(operation: operation)
      #   column_reference: ColumnReference.new(schema, table, column),
      #   major_patient_id: major_patient_id,
      #   minor_patient_id: minor_patient_id
      # )
    end

    let(:schema) { "renalware" }
    let(:table) { "problem_problems" }
    let(:column) { "patient_id" }
    let(:major_patient) { create(:patient) }
    let(:minor_patient) { create(:patient) }
    let(:other_patient) { create(:patient) }
    let(:major_patient_id) { major_patient&.id }
    let(:minor_patient_id) { minor_patient&.id }

    describe "#update" do
      context "when there are records to update" do
        let!(:problem1) { create(:problem, patient: minor_patient) }
        let!(:problem2) { create(:problem, patient: minor_patient) }
        let!(:problem3) { create(:problem, patient: major_patient) }
        let!(:problem4) { create(:problem, patient: other_patient) }

        it "updates the foreign keys from minor to major patient" do
          count_up_updated_rows = nil
          expect {
            count_up_updated_rows = query.call
          }.to change { Renalware::Problems::Problem.where(patient: major_patient).count }.by(2)
            .and change { Renalware::Problems::Problem.where(patient: minor_patient).count }.by(-2)

          expect(count_up_updated_rows).to eq(2)
          expect(problem1.reload.patient).to eq(major_patient)
          expect(problem2.reload.patient).to eq(major_patient)
          expect(problem3.reload.patient).to eq(major_patient)
          expect(problem4.reload.patient).to eq(other_patient) # unchanged
        end
      end

      context "when minor patient has no records to update" do
        before { create(:problem, patient: major_patient) }

        it "does not change any records" do
          count_up_updated_rows = query.call

          expect(count_up_updated_rows).to eq(0)
        end
      end

      context "when major_patient_id is missing" do
        let(:major_patient) { nil }

        it "raises an ArgumentError" do
          expect { query.call }.to raise_error(ArgumentError, /major_patient_id is required/)
        end
      end

      context "when minor_patient_id is missing" do
        let(:minor_patient) { nil }

        it "raises an ArgumentError" do
          expect { query.call }.to raise_error(ArgumentError, /minor_patient_id is required/)
        end
      end

      context "when schema is missing" do
        let(:schema) { nil }

        it "raises an ArgumentError for missing schema" do
          expect { query.call }.to raise_error(ArgumentError, /schema is required/)
        end
      end

      context "when table is missing" do
        let(:table) { nil }

        it "raises an ArgumentError for missing table" do
          expect { query.call }.to raise_error(ArgumentError, /table is required/)
        end
      end

      context "when column is missing" do
        let(:column) { nil }

        it "raises an ArgumentError for missing column" do
          expect { query.call }.to raise_error(ArgumentError, /column is required/)
        end
      end

      context "when table is invalid" do
        let(:table) { "invalid-table-name!" }

        it "raises an ArgumentError" do
          expect { query.call }.to raise_error(ArgumentError, /invalid identifier/)
        end
      end

      context "when column is invalid" do
        let(:column) { "invalid-column-name!" }

        it "raises an ArgumentError" do
          expect { query.call }.to raise_error(ArgumentError, /invalid identifier/)
        end
      end

      context "when schema is invalid" do
        let(:schema) { "invalid-schema-name!" }

        it "raises an ArgumentError" do
          expect { query.call }.to raise_error(ArgumentError, /invalid identifier/)
        end
      end

      context "when minor_patient_id is the same as major_patient_id" do
        let(:minor_patient_id) { major_patient_id }

        it "raises an ArgumentError" do
          expect(major_patient_id).to eq(minor_patient_id) # sanity check
          expect { query.call }.to raise_error(
            ArgumentError,
            /minor_patient_id must be different from major_patient_id/
          )
        end
      end

      context "when major_patient_id is not an integer" do
        let(:major_patient_id) { "not-an-integer" }

        it "raises an ArgumentError" do
          expect { query.call }.to raise_error(ArgumentError, /invalid value for Integer/)
        end
      end

      context "when minor_patient_id is not an integer" do
        let(:minor_patient_id) { "not-an-integer" }

        it "raises an ArgumentError" do
          expect { query.call }.to raise_error(ArgumentError, /invalid value for Integer/)
        end
      end
    end
  end
end
