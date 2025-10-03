# frozen_string_literal: true

module Renalware
  # These can be removed once Heroic integration is complete
  class Heroic::Events::HeroicEvent < Events::Event; end
  class Heroic::Events::Mgfr < Heroic::Events::HeroicEvent; end

  # The useful thing here is that we're ensuring all the classes
  # actually exist so if anything gets renamed this spec will flag it.
  RSpec.describe NameService do
    # Timeline classes
    [
      %w(Admissions::Admission Admissions::AdmissionTimelineItem Admissions::AdmissionTimelineRow),
      %w(Admissions::Consult Admissions::ConsultTimelineItem Admissions::ConsultTimelineRow),
      %w(Clinics::ClinicVisit Clinics::ClinicVisitTimelineItem Clinics::ClinicVisitTimelineRow),
      %w(Events::Event Events::EventTimelineItem Events::EventTimelineRow),
      %w(Letters::Letter Letters::LetterTimelineItem Letters::LetterTimelineRow),
      %w(Modalities::Modality Modalities::ModalityTimelineItem Modalities::ModalityTimelineRow),
      %w(Messaging::Internal::Message
         Messaging::Internal::MessageTimelineItem
         Messaging::Internal::MessageTimelineRow)
    ].each do |model, service, component|
      it "maps #{model} to #{service} and #{component}" do
        model = "Renalware::#{model}".constantize
        service = "Renalware::#{service}".constantize
        component = "Renalware::#{component}".constantize

        klass = described_class.from_model(model, to: "TimelineItem")
        expect(klass).to eq service

        klass = described_class.from_model(model, to: "TimelineRow")
        expect(klass).to eq component
      end
    end

    # Detail classes
    [
      %w(Events::AdvancedCarePlan Events::AdvancedCarePlanDetail),
      %w(Admissions::Consult Admissions::ConsultDetail),
      %w(Heroic::Events::Mgfr Heroic::Events::HeroicEventDetail)
    ].each do |model, component|
      it "maps #{model} to #{component}" do
        model = "Renalware::#{model}".constantize
        component = "Renalware::#{component}".constantize

        klass = described_class.from_model(model, to: "Detail")
        expect(klass).to eq component
      end
    end

    it "maps an STI class" do
      model = Letters::Letter::Draft.new

      klass = described_class.from_model(model, to: "TimelineItem")
      expect(klass).to eq Letters::LetterTimelineItem

      klass = described_class.from_model(model, to: "TimelineRow")
      expect(klass).to eq Letters::LetterTimelineRow

      model = RemoteMonitoring::Registration.new
      klass = described_class.from_model(model, to: "TimelineItem")
      expect(klass).to eq Events::EventTimelineItem

      model = Heroic::Events::Mgfr.new
      klass = described_class.from_model(model, to: "TimelineItem")
      expect(klass).to eq Heroic::Events::HeroicEventTimelineItem

      model = Dietetics::ClinicVisit.new
      klass = described_class.from_model(model, to: "TimelineRow")
      expect(klass).to eq Clinics::ClinicVisitTimelineRow
    end
  end
end
