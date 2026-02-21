# frozen_string_literal: true

class Forms::Generic::Homecare::Document < Forms::Base
  pattr_initialize :args

  def self.build(args)
    new(args).tap(&:build)
  end

  def document
    @document ||= Prawn::Document.new(
      page_size: "A4",
      page_layout: :portrait,
      margin: [25, 25, 10, 25]
    )
  end

  def build
    Prawn::Font::AFM.hide_m17n_warning = true
    sections.each { |klass| to_class(klass).new(document, args).build }
  end

  private

  def sections
    %w(
      Heading
      PatientDetails
      Medications
      Allergies
      PrescriptionDurations
      DeliveryFrequencies
      Signoff
      Footer
    ).tap { |s| s.delete("Allergies") unless Renalware.config.enable_allergies }
  end

  def to_class(name)
    "Forms::Generic::Homecare::#{name}".constantize
  end
end
