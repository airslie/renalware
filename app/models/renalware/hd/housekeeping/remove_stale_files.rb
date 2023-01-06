# frozen_string_literal: true

module Renalware
  module HD
    module Housekeeping
      class RemoveStaleFiles
        def initialize(created_before: nil)
          @created_before = created_before || 2.days.ago
        end

        def self.call(...)
          new(...).call
        end

        def call
          remove_stale_batched_hd_session_form_pdf_files
        end

        private

        def remove_stale_batched_hd_session_form_pdf_files
          stale_batches.select(:id, :filepath).each do |batch|
            FileUtils.rm_f(filepath)
            batch.update!(filepath: nil)
          end
        end

        def stale_batches
          SessionForms::Batch.where("created_at < ? and filepath is not null", @created_before)
        end
      end
    end
  end
end
