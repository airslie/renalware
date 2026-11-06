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
            return unless GPLetterDelivery.builtin_mesh?
            return unless Delivery::PrimaryCareDeliveryPolicy.new(letter).send_electronically?

            transmission = Transmission.create!(letter: letter)

            if register_after_commit
              register_after_commit.call { enqueue_delivery(transmission) }
            else
              enqueue_delivery(transmission)
            end
          end

          private

          attr_reader :letter, :register_after_commit

          def enqueue_delivery(transmission)
            delay = Renalware.config.mesh_delay_seconds_between_letter_approval_and_mesh_send
            job = SendMessageJob.set(wait: delay).perform_later(transmission)
            transmission.update!(active_job_id: job.job_id) if job.respond_to?(:job_id)
          end
        end
      end
    end
  end
end
