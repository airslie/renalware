module Renalware
  module HD
    module SessionForms
      class BatchesController < BaseController
        def show
          batch = find_and_authorize_batch
          respond_to do |format|
            format.pdf do
              # Returns the PDF itself using path saved in the Batch - provided status is correct
              send_file(
                batch.filepath,
                type: "application/pdf",
                disposition: "inline",
                filename: "session_forms_batch_#{batch.id}.pdf"
              )
            end
            format.html do
              # Returns a partial with a link to the compiled batch pdf
              render layout: false, locals: { batch: find_and_authorize_batch }
            end
          end
        end

        def create
          batch = create_unprocessed_batch_and_batch_items
          authorize batch
          BatchPrintJob.perform_later(batch.id, current_user.id)

          respond_to do |format|
            format.js {
              render locals: { batch: batch }
            }
          end
        end

        def status
          batch = find_and_authorize_batch(params[:batch_id])
          respond_to do |format|
            format.json {
              render(
                status: :ok,
                json: {
                  id: batch.id,
                  status: batch.status,
                  percent_complete: batch.percent_complete
                }
              )
            }
          end
        end

        private

        def create_unprocessed_batch_and_batch_items
          batch = Batch.new
          Batch.transaction do
            patient_ids.each { |patient_id| batch.items.build(printable_id: patient_id) }
            batch.save_by!(current_user)
          end
          batch
        end

        def patient_ids
          params.require(:batch).require(:patient_ids)
        end

        def find_and_authorize_batch(id = nil)
          Batch.find(id || params[:id]).tap { |batch| authorize batch }
        end
      end
    end
  end
end
