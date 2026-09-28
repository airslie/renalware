require "pdf/reader"

module Renalware
  module Letters
    module Printing
      describe PdfCombining do
        subject(:combiner) { Class.new { include PdfCombining }.new }

        it "combines PDFs into a temporary .pdf file and cleans it up afterwards" do
          input = Rails.root.join("app/assets/pdf/blank_page.pdf")
          output_path = nil

          combiner.using_a_temporary_output_file do |output|
            output_path = output.path
            expect(File.extname(output_path)).to eq(".pdf")

            combiner.shell_to_ghostscript_to_combine_files([input, input], input.dirname, output)

            expect(PDF::Reader.new(output_path).page_count).to eq(2)
          end

          expect(File).not_to exist(output_path)
        end
      end
    end
  end
end
