module Renalware
  module HD
    module SessionForms
      # Given a Batch object representing a request to 'print' (ie compile) a PDF of multiple
      # HD Session Forms (aka protocols), where each batch.item points to the patient we want to
      # print, we render each PDF in the current folder (we assume the caller has chdir'ed
      # us into a tmp location), and then append them all together as <batchid>.pdf in a known
      # location. The filepath is assigned to the batch and saved, so it can be served to
      # a user via the user later.
      class BatchCompilePdfs
        include Callable
        include PdfCompilation

        def initialize(batch, user)
          @batch = batch
          @user = user
          @dir = Pathname(Dir.pwd)
        end

        def call
          batch.update_by(user, status: :processing)
          process_batch_items
          batch.filepath = append_files
          batch.status = :awaiting_printing
          batch.save_by!(user)
        rescue StandardError => e
          batch.update(last_error: e.message, status: :failure)
          raise e
        end

        private

        attr_reader :batch, :dir, :user

        def process_batch_items
          filename = "batch_#{batch.id}.pdf"
          File.binwrite(filename, PdfRenderer.new(patients: patients).call)
          batch.items.each { |item| item.update(status: :compiled) }
        end

        def patients
          @patients ||= HD::Patient.where(id: batch.items.pluck(:printable_id))
        end

        def render_session_form_pdf_to_file_for(patient)
          filename = "session_form_#{patient.id}.pdf"
          File.binwrite(filename, PdfRenderer.new(patient: patient).call)
          filename
        end

        def append_files
          glob = Dir.glob(dir.join("*.pdf"))
          if glob.any?
            combine_multiple_pdfs_into_file(
              filepath: compiled_output_pdf_filename,
              glob: glob
            )
          end
          Pathname(compiled_output_pdf_filename).to_s # TODO: what happens if no content?
        end

        def working_folder
          Renalware.config.base_working_folder.join("batched_hd_session_forms").tap do |folder|
            FileUtils.mkdir_p folder
          end
        end

        def compiled_output_pdf_filename
          working_folder.join("#{batch.id}.pdf")
        end
      end
    end
  end
end
