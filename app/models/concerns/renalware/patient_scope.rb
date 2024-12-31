require "active_support/concern"

module Renalware
  module PatientScope
    extend ActiveSupport::Concern

    included do
      scope :for_patient, ->(patient) { where(patient: patient) }
    end
  end
end
