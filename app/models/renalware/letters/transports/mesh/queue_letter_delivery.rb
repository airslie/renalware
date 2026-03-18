module Renalware
  module Letters
    module Transports
      module Mesh
        class QueueLetterDelivery
          include Callable

          def initialize(letter:, register_after_commit: nil)
            @letter = letter
            @register_after_commit = register_after_commit
          end

          def call
            return unless send_to_gp_using_mesh?

            transmission = Transmission.create!(letter: letter)

            if register_after_commit
              register_after_commit.call { enqueue_delivery(transmission) }
            else
              enqueue_delivery(transmission)
            end
          end

          private

          attr_reader :letter, :register_after_commit

          delegate :patient, to: :letter

          def enqueue_delivery(transmission)
            delay = Renalware.config.mesh_delay_seconds_between_letter_approval_and_mesh_send
            job = SendMessageJob.set(wait: delay).perform_later(transmission)
            transmission.update!(active_job_id: job.job_id) if job.respond_to?(:job_id)
          end

          def send_to_gp_using_mesh?
            return false unless Renalware.config.send_gp_letters_over_mesh
            return false if patient.confidentiality_restricted?
            return false unless letter.gp_is_a_recipient?

            true
          end
        end
      end
    end
  end
end
