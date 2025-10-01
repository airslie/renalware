# frozen_string_literal: true

module Renalware
  class Patients::Timeline
    TIMELINES = [
      Admissions::Admission,
      Admissions::Consult,
      Clinics::ClinicVisit,
      Events::Event,
      Letters::Letter,
      Messaging::Internal::Message,
      Modalities::Modality
    ].freeze

    FIELDS = [:id].freeze

    def self.all(patient)
      new(TIMELINES.flat_map { |model_class| timeline_items_for(model_class, patient) })
    end

    delegate :count, to: :@items

    def initialize(items)
      @items = items.sort_by(&:sort_date).reverse
    end

    def offset(start, limit: 20)
      finish = start + limit - 1
      @items[start..finish].map(&:fetch)
    end

    private_class_method def self.timeline_items_for(model_class, patient)
      model_class
        .where(patient:)
        .ordered
        .pluck(FIELDS + model_class::ORDER_FIELDS)
        .map { |fields| create_timeline_item(model_class, fields) }
    end

    private_class_method def self.create_timeline_item(model_class, fields)
      timeline_item_class = NameService.from_model(model_class, to: "TimelineItem")
      timeline_item_class.new(id: fields.shift, sort_date: DateTimeHelper.merge(fields))
    end
  end
end
