# frozen_string_literal: true

require "renalware/feeds"
require "attr_extras"

module Renalware
  module Patients
    module Ingestion
      class UpdateMasterPatientIndex < ApplicationJob
        queue_as :master_patient_index
        queue_with_priority 10

        def perform(feed_message:)
          raise "todo"
          # UpdateMasterPatientIndex.call()
        end
      end
    end
  end
end
