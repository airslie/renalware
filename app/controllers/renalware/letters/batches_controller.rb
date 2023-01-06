# frozen_string_literal: true

module Renalware
  module Letters
    class BatchesController < BaseController
      include Renalware::Concerns::Pageable

      def create
        batch = create_unprocessed_batch_and_batch_items(ids_of_letters_to_batch_print)
        authorize batch
        Printing::BatchPrintJob.perform_later(batch, current_user)
        respond_to do |format|
          format.js {
            render locals: { batch: batch }
          }
        end
      end

      # rubocop:disable Metrics/MethodLength
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
      # rubocop:enable Metrics/MethodLength

      # rubocop:disable Metrics/MethodLength
      def show
        batch = find_and_authorize_batch
        respond_to do |format|
          format.pdf do
            # Returns the PDF itself using path saved in the Batch - provided status is correct
            send_file(
              batch.filepath,
              type: "application/pdf",
              disposition: "inline",
              filename: "letter_batch_#{batch.id}.pdf"
            )
          end
          format.html do
            # Returns a partial with a link to the compiled batch pdf
            render layout: false, locals: { batch: find_and_authorize_batch }
          end
        end
      end
      # rubocop:enable Metrics/MethodLength

      def index
        batches = Batch.order(created_at: :desc)
        authorize batches
        render locals: { batches: batches.page(page).per(per_page) }
      end

      private

      def find_and_authorize_batch(id = nil)
        id ||= params[:id]
        Letters::Batch.find(id).tap do |batch|
          authorize batch
        end
      end

      def ids_of_letters_to_batch_print
        LetterQuery
          .new(q: batch_params)
          .call
          .select(:id, :event_type, :event_id)
          .take(Renalware.config.max_batch_print_size)
          .map(&:id)
      end

      def create_unprocessed_batch_and_batch_items(letter_ids)
        batch = Batch.new
        Batch.transaction do
          letter_ids.each { |letter_id| batch.items.build(letter_id: letter_id) }
          batch.save_by!(current_user)
        end
        batch
      end

      def batch_params
        params
          .require(:batch)
          .permit(
            :enclosures_present,
            :notes_present,
            :state_eq,
            :author_id_eq,
            :created_by_id_eq,
            :letterhead_id_eq,
            :page_count_in_array
          )
      end
    end
  end
end
