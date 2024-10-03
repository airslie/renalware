# frozen_string_literal: true

require "duration_calculator"

module Renalware
  module HD
    class SessionPatientGroupDirection < ApplicationRecord
      belongs_to :session, inverse_of: :session_patient_group_directions
      belongs_to :patient_group_direction, class_name: "Drugs::PatientGroupDirection"
      validates :session, presence: true
      validates :patient_group_direction, presence: true
    end
  end
end
