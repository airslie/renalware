# frozen_string_literal: true

class Forms::Alcura::Homecare::Document < Forms::Alcura::Homecare::Base
  pattr_initialize :args

  def self.build(args)
    new(args).tap(&:build)
  end

  def document
    @document ||= Prawn::Document.new(
      page_size: "A4",
      page_layout: :portrait,
      margin: [15, 15, 8, 15]
    )
  end

  def build # rubocop:disable Metrics/MethodLength
    Prawn::Font::AFM.hide_m17n_warning = true
    %w(
      Heading
      OrderDetails
      HospitalDetails
      PatientDetails
      Medications
      DeliveryFrequency
      PrescriptionDuration
      Comments
      PrescriberDetails
      PharmacistDetails
      Footer
    ).each { |klass| to_class(klass).new(document, args).build }
  end

  private

  def to_class(name)
    "Forms::Alcura::Homecare::#{name}".constantize
  end
end
