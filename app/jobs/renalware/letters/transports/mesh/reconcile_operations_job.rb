# frozen_string_literal: true

module Renalware
  module Letters::Transports
    module Mesh
      # Runs periodically against state=pending transmissions, to:
      # - mark them as complete when we have a successful inf and bus response
      # - mark as failed if insufficient responses returned after a period of time
      # - .. more to add here no doubt
      #
      # Find all pending transmissions with two download_operations and update the
      # status accordingly. Note that if an operation fails, it updates the parent transmission
      # status to failure, so here we only need to worry about pending transmissions with
      # two successful operations.
      class ReconcileOperationsJob < ApplicationJob
        queue_as :mesh
        queue_with_priority 5

        def perform
          flag_pending_transmissions_as_successful_if_inf_and_bus_operations_were_successful
          flag_pending_transmissions_as_failed_if_any_operation_has_error
          flag_pending_transmissions_as_failed_if_no_bus_and_inf_response_yet
        end

        # private

        def flag_pending_transmissions_as_successful_if_inf_and_bus_operations_were_successful
          transmissions = Transmission.includes(:letter)
            .where(id: pending_transmission_ids_with_two_successful_download_operations)

          transmissions.find_each do |transmission|
            transmission.update!(status: "success")
            transmission
              .letter
              .update_columns(gp_send_status: :success, updated_at: Time.zone.now)

            complete_letter_if_gp_is_the_only_recipient_so_no_printing_required(transmission.letter)
          end
        end

        def complete_letter_if_gp_is_the_only_recipient_so_no_printing_required(letter)
          recipients = letter.recipients
          if recipients.size == 1 && recipients.first.person_role == :primary_care_physician
            Letters::CompleteLetter.build(letter).call(by: letter.approved_by)
          end
        end

        def flag_pending_transmissions_as_failed_if_any_operation_has_error
          Transmission
            .status_pending
            .joins(:operations)
            .where("action in ('send_message', 'download_message') and " \
                   "(http_error = true OR mesh_error = true OR itk3_error = true)")
            .update_all(status: :failure)
        end

        # rubocop:disable Metrics/MethodLength
        def pending_transmission_ids_with_two_successful_download_operations
          sql = <<-SQL.squish
            select lmt.id from letter_mesh_transmissions lmt
            where
              lmt.status = 'pending'
              and exists(
                select 1 from letter_mesh_operations lmo
                  where
                    lmo.transmission_id = lmt.id
                    and lmo.action = 'download_message'
                    and lmo.itk3_response_type = 'bus'
                    and lmo.itk3_operation_outcome_code = '30001'
                )
              and exists(
                select 1 from letter_mesh_operations lmo
                  where
                    lmo.transmission_id = lmt.id
                    and lmo.action = 'download_message'
                    and lmo.itk3_response_type = 'inf'
                    and lmo.itk3_operation_outcome_code = '20013'
            );
          SQL

          ActiveRecord::Base.connection.execute(sql).values.flatten
        end
        # rubocop:enable Metrics/MethodLength

        # rubocop:disable Metrics/LineLength
        def flag_pending_transmissions_as_failed_if_no_bus_and_inf_response_yet
          # timeout_duration = Renalware.config.mesh_timeout_transmissions_with_no_response_after
          # Transmission
          #   .status_pending
          #   .joins("inner join mesh_transmission_operations send_op on send_op.transmission_id = mesh_transmissions.id and send_op.action = 'send_operation'")
          #   .joins("left outer join mesh_transmission_operations download_op on download_op.transmission_id = mesh_transmissions.id and download_op.")
          #   .where("action in ('send_message', 'download_message') and " \
          #          "(http_error = true OR mesh_error = true OR itk3_error = true)")
          # Transmission
          #   .status_pending
          #   .joins(:operations)
          # ..
        end
        # rubocop:enable Metrics/LineLength
      end
    end
  end
end
