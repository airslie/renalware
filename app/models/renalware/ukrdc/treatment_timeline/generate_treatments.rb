require "benchmark"

module Renalware
  module UKRDC
    module TreatmentTimeline
      # Re-generates the ukrdc_treatments table
      class GenerateTreatments
        def self.call
          new.call
        end

        def call
          elapsed_ms = Benchmark.ms do
            generate_treatments
          end
          log("\nCreated #{UKRDC::Treatment.count} UKRDC Treatments in #{elapsed_ms / 1000.0}s")
        end

        private

        def patient_scope
          Renalware::Patient
            .select(:id)
            .where("send_to_renalreg = true or send_to_rpv = true")
        end

        # rubocop:disable Rails/Output
        def generate_treatments
          PrepareTables.call
          Rails.logger.info "#{patient_scope.count} patients"
          patient_scope.find_each.with_index do |patient, _index|
            print "\n#{patient.id}: "
            GenerateTimeline.new(patient).call
            # Start garbage collection periodically to prevent server ram issues.
            # GC.start if (index % 50).zero?
          end
        end
        # rubocop:enable Rails/Output

        def log(msg)
          Rails.logger.info(msg)
        end
      end
    end
  end
end
