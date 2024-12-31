module Renalware
  # Presenter formatting a collection of patients for use behind any MDM Patients listing.
  class MDMPatientsPresenter
    include PresenterHelper
    attr_reader :patients, :view_proc, :page_title, :q, :pagy

    def initialize(patients:,
                   view_proc:,
                   page_title:,
                   q:,
                   pagy:,
                   patient_presenter_class: nil)
      patient_presenter_class ||= MDMPatientPresenter
      @view_proc = view_proc
      @patients = present(patients, patient_presenter_class)
      @page_title = page_title
      @q = q
      @pagy = pagy
    end
  end
end
