module Renalware
  module Letters
    module Housekeeping
      # When a letter batch operation is executed by e.g a receptionist from the
      # the Renal => Letters => Batch Printable page, some temporary files are created including
      # the final batched PDF which is a concatenation of all the PDFs they chose to include
      # in the final PDF (which they go on to Print and put through an envelope stuffer).
      # While some of the tmp files created in this process use the Tempfile class to create a
      # file that the OS will remove, the final PDF does not (I can't recall why) and so this file
      # needs housekeeping. This class removes these stale files. The Batch record helpfully stores
      # the path to the file to remove. We set the batch.filepath to null after removing the file.
      class RemoveStaleFiles
        include Callable

        def initialize(created_before: nil)
          @created_before = created_before || 2.days.ago
        end

        def call
          remove_stale_batched_letter_pdf_files
        end

        private

        def remove_stale_batched_letter_pdf_files
          stale_batches.select(:id, :filepath).each do |batch|
            FileUtils.rm_f(batch.filepath)
            batch.update_by(Renalware::SystemUser.find, filepath: nil)
          end
        end

        def stale_batches
          Batch.where("created_at < ? and filepath is not null", @created_before)
        end
      end
    end
  end
end
