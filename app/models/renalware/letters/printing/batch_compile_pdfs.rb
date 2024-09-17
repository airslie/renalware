# frozen_string_literal: true

module Renalware
  module Letters
    module Printing
      # Given a Batch object that has many associated letters, it
      # - compiles each letter with a cover sheet for each recipient, adding blank padding pages
      #   if needed to ensure the envelop stuffer will work correctly (ie each letter starts on an
      #   odd page)
      # - combines all these letter PDFs into one batch PDF. The output filepath is stored on the
      # batch model.
      #
      # Note that this class creates files and combines them using ghost script.
      # These operations take place in the current working directory, so to use this class
      # you might need to create a OS tmp folder first and cdhir into it. See the spec for an
      # example.
      class BatchCompilePdfs
        include Callable
        include PdfCombining
        PAGE_COUNTS = %w(2 3 4 5 6 7 8 9 10).freeze

        def initialize(batch, user)
          @batch = batch
          @user = user
          @dir = Pathname(Dir.pwd) # a tmp dir - see where we are called
          Rails.logger.info "Compiling letter PDFs for batch #{batch.id} in folder #{dir}"
        end

        def call
          batch.status = :processing
          batch.save_by!(user)
          batch.items.each do |item|
            validate_letter(item.letter)
            assemble_letter_pdfs(item.letter, dir)
            item.update(status: :compiled)
          end
          batch.filepath = append_files
          batch.status = :awaiting_printing
          batch.save_by!(user)
        end

        private

        attr_reader :batch, :dir, :user

        def append_files
          pdf_file = working_folder.join("#{batch.id}.pdf")
          glob = Dir.glob(dir.join("*.pdf"))
          combine_multiple_pdfs_into_file(filepath: pdf_file, glob: glob) if glob.any?
          Pathname(pdf_file).to_s
        end

        def page_count_allowing_for_cover_sheet(letter)
          (letter.page_count + 1).to_s
        end

        def validate_letter(letter)
          raise "Letter has no page_count" if letter.page_count.to_i.zero?
          if letter.page_count.to_i > PAGE_COUNTS.last.to_i
            raise "Letter page count (#{letter.page_count}) unexpected"
          end
        end

        # TODO: refactor
        def assemble_letter_pdfs(letter, dir) # rubocop:disable Metrics/AbcSize
          Rails.logger.info "Interleaving address sheets and letters for letter #{letter.id}"
          letter_has_an_odd_number_of_pages = letter.page_count.odd?
          filenames = []
          working_folder = dir.join("letter_#{letter.id}")
          FileUtils.mkdir_p working_folder

          output_filepath = dir.join("compiled_letter_#{letter.id}.pdf")

          Dir.chdir(working_folder) do
            letter_filename = write_letter_to_pdf_file(letter)

            printable_recipients_for(letter).each do |recipient|
              next if recipient.emailed_at.present?

              Rails.logger.info " Recipient #{recipient.id}"
              filenames << write_recipient_cover_sheet_pdf(letter, recipient)
              filenames << letter_filename
              filenames << blank_page_filename if letter_has_an_odd_number_of_pages
            end
            combine_multiple_pdfs_using_filenames(filenames, working_folder, output_filepath)
          end
        end

        def printable_recipients_for(letter)
          CollectionPresenter.new(
            Recipient.printable_recipients_for(letter),
            RecipientPresenter::WithCurrentAddress
          )
        end

        # Remove letter and recipient working files
        def remove_working_files
          FileUtils.rm Dir.glob(dir.join("*.pdf"))
        end

        def write_letter_to_pdf_file(letter)
          filename = "original_letter_#{letter.id}.pdf"
          File.binwrite(filename, RendererFactory.renderer_for(letter, :pdf).call)
          filename
        end

        def write_recipient_cover_sheet_pdf(letter, recipient)
          filename = "letter_#{letter.id}_address_sheet_for_recipient_#{recipient.id}.pdf"
          Formats::Pdf::RecipientAddressPagePdf.new(recipient).render_file filename
          filename
        end

        def blank_page_filename
          @blank_page_filename ||= begin
            Renalware::Engine.root.join("app", "assets", "pdf", "blank_page.pdf").to_s
          end
        end

        def working_folder
          @working_folder ||= begin
            Renalware.config.base_working_folder.join("batched_letters").tap do |folder|
              FileUtils.mkdir_p folder
            end
          end
        end
      end
    end
  end
end
