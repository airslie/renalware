require "pdf/reader"

module Renalware
  module Letters
    describe Printing::BatchCompilePdfs do
      include LettersSpecHelper

      let(:user) { create(:user) }

      it "compiles each letter to a PDF comprising address sheet + letter for each recipient " \
         "then merges all letter PDFs into one batch PDF" do
        batch = Letters::Batch.create!(by: create(:user))

        # Our batch will comprise 2 letters.
        # Each is going to the patient and also CCd to the GP and a contact.
        # The 2nd letter however we will say has already been emailed to the GP so we should not
        # expect to see any snail mail output for them in the PDF.
        letter1 = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(page_count: 1)
        letter2 = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(page_count: 1)

        update_letter_to_indicate_gp_has_already_been_emailed(letter2)

        batch.items.create(letter: letter1)
        batch.items.create(letter: letter2)

        # BatchCompilePdfs works in the context of the current working folder
        # So here we create an OS temp folder inside the Rails tmp folder.
        # In this project you can find this in demo/tmp/{tmp folder name} e.g.
        # demo/tmp/d20210307-88904-1iul2n7/

        # These are the filenames that should be created during the compilation of the PDF.
        letter1_filename = "compiled_letter_#{letter1.id}.pdf"
        letter2_filename = "compiled_letter_#{letter2.id}.pdf"

        Dir.mktmpdir(nil, Rails.root.join("tmp").to_s) do |dir|
          path = Pathname(dir)

          # Move into the temp folder we batch compilation happens in the context of this folder.
          Dir.chdir(path) do
            described_class.call(batch, user)

            expect(batch.reload.status).to eq("awaiting_printing")

            # Note this bit is peeking into the letter compilation process...
            # In a tmp folder eg tmp/d20210307-88904-1iul2n7/ there will be 2 PDF letters
            # created.
            expect(File.exist?(letter1_filename)).to be(true)
            expect(File.exist?(letter2_filename)).to be(true)

            # In each letter each recipient will have each 4 pages:
            # - the cover sheet (2 pages, front and pack)
            # - the 1 page letter and
            # - blank page (reverse of letter) added for padding to ensure the next letter starts at
            # the correct place.
            # Hence:
            # - letter1 12 sheets (3 recipient x 4 sides) and l
            # - letter2 8 sheets (2 recipients (GP was emailed so excluded) x 4 sides)
            expect(PDF::Reader.new(letter1_filename).page_count).to eq(12)
            expect(PDF::Reader.new(letter2_filename).page_count).to eq(8) # omits GP as emailed
          end
        end

        # OK, Compilation is complete, and the combined batch PDF filepath stored in the batch model
        # Path is eg demo/tmp/batches/{batchid}.pdf  and should have the correct number
        # of pages (12 + 8)
        expect(PDF::Reader.new(batch.filepath).page_count).to eq(20)
      end

      def update_letter_to_indicate_gp_has_already_been_emailed(letter)
        letter
          .recipients
          .detect { |rec| rec.person_role == "primary_care_physician" }
          .update(emailed_at: Time.zone.now)
      end
    end
  end
end
