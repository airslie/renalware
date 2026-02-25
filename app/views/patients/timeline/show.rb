class Views::Patients::Timeline::Show < Views::Base
  register_output_helper :within_patient_layout

  def initialize(patient:, page:)
    @patient = patient
    @page = page
    super()
  end

  def view_template
    within_patient_layout(title: "Activity Summary") do
      render Renalware::Patients::TimelineComponent
        .new(patient:, page:, full_view: true)
    end
  end

  private

  attr_reader :patient, :page
end
