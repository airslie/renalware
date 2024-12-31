module Renalware
  module HD
    module Housekeeping
      class RemoveStaleFiles
        include Callable

        def initialize(created_before: nil)
          @created_before = created_before || 2.days.ago
        end

        def call
          remove_stale_batched_hd_session_form_pdf_files
        end

        private

        def remove_stale_batched_hd_session_form_pdf_files
          stale_batches.select(:id, :filepath).each do |batch|
            FileUtils.rm_f(batch.filepath)
            batch.update_by(Renalware::SystemUser.find, filepath: nil)
          end
        end

        def stale_batches
          SessionForms::Batch.where("created_at < ? and filepath is not null", @created_before)
        end
      end
    end
  end
end
