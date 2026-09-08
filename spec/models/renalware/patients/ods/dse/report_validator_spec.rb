module Renalware
  module Patients
    module ODS
      module DSE
        describe ReportValidator do
          def with_csv(content)
            Tempfile.create(["report", ".csv"]) do |file|
              file.write(content)
              file.flush
              yield file.path
            end
          end

          it "returns the number of valid rows" do
            with_csv("a,b\nc,d\n") do |path|
              count = described_class.new(
                path:,
                report_name: "test",
                expected_columns: 2,
                minimum_rows: 2
              ).call

              expect(count).to eq(2)
            end
          end

          it "rejects rows with an unexpected number of columns" do
            with_csv("a,b\nc,d,e\n") do |path|
              validator = described_class.new(
                path:,
                report_name: "test",
                expected_columns: 2,
                minimum_rows: 1
              )

              expect { validator.call }.to raise_error(ValidationError, /row 2 has 3 columns/)
            end
          end

          it "rejects a suspiciously small report" do
            with_csv("a,b\n") do |path|
              validator = described_class.new(
                path:,
                report_name: "test",
                expected_columns: 2,
                minimum_rows: 2
              )

              expect { validator.call }.to raise_error(ValidationError, /only 1 rows/)
            end
          end
        end
      end
    end
  end
end
