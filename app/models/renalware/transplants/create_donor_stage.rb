require "success"
require "failure"

# Service object responsible for creating a new DonorStage and terminated the previous one
# if found.
module Renalware
  module Transplants
    class CreateDonorStage
      def initialize(patient:, options: {})
        @patient = patient
        @options = options
      end

      def call
        DonorStage.transaction do
          terminate_current_stage if current_stage.present?
          stage = build_new_stage
          if stage.save
            ::Success.new(stage)
          else
            ::Failure.new(stage)
          end
        end
      end

      private

      attr_reader :patient, :options

      def current_stage
        @current_stage ||= DonorStage.for_patient(patient).current.first
      end

      def terminate_current_stage
        current_stage.terminated_on = started_on_for_new_stage
        current_stage.by = by
        current_stage.save!
        @current_stage = nil
      end

      def build_new_stage
        DonorStage.new(
          patient: patient,
          started_on: started_on_for_new_stage,
          stage_position_id: options.fetch(:stage_position_id),
          stage_status_id: options.fetch(:stage_status_id),
          notes: options.fetch(:notes),
          by: by
        )
      end

      def by
        options.fetch(:by)
      end

      def started_on_for_new_stage
        options.fetch(:started_on)
      end
    end
  end
end
