# frozen_string_literal: true

class Forms::Fresenius::Homecare::Document < Forms::Fresenius::Homecare::Base
  pattr_initialize :args

  def self.build(args)
    new(args).tap(&:build)
  end

  def document
    @document ||= Prawn::Document.new(page_size: "A4", page_layout: :portrait, margin: 15)
  end

  def build
    Prawn::Font::AFM.hide_m17n_warning = true
    %w(
      Heading
      ReturnAddress
      PatientDetailsTable
      ModalityTable
      PrescriptionsTable
      DeliveryDetailsTable
      PrescriberDetailsTable
      Footer
    ).each { |klass| to_class(klass).new(document, args).build }
  end

  private

  def to_class(name)
    "Forms::Fresenius::Homecare::#{name}".constantize
  end
end
