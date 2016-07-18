module Renalware
  class ClinicalSummariesController < BaseController

    skip_after_action :verify_authorized

    before_action :load_patient

    def show
      @events = Events::Event.for_patient(@patient)
      @problems = @patient.problems.ordered
      @prescriptions = @patient.prescriptions.current.ordered
    end
  end
end
