module Renalware
  class Medication < ActiveRecord::Base
    include Accountable

    attr_accessor :drug_select

    has_paper_trail class_name: 'Renalware::MedicationVersion'

    belongs_to :patient
    belongs_to :drug, class_name: "Renalware::Drugs::Drug"
    belongs_to :treatable, polymorphic: true
    belongs_to :medication_route

    validates :patient, presence: true
    validates :treatable, presence: true
    validates :drug, presence: true
    validates :dose, presence: true
    validates :medication_route, presence: true
    validates :frequency, presence: true
    validates :start_date, presence: true
    validates :provider, presence: true
    validate :constrain_route_description

    enum provider: Provider.codes

    scope :ordered, -> { order(default_search_order) }
    scope :current, -> { where(state: "current") }
    scope :terminated, -> { where(state: "terminated") }

    def self.default_search_order
      "start_date desc"
    end

    def self.peritonitis
      self.new(treatable_type: 'Renalware::PeritonitisEpisode')
    end

    def self.exit_site
      self.new(treatable_type: 'Renalware::ExitSiteInfection')
    end

    def formatted
      [].tap { |ary|
        ary << drug.name if drug.present?
        ary << dose
        ary << medication_route.name if medication_route.present?
        ary << frequency
        ary << start_date
      }.compact.join(", ")
    end

    def terminate(by:)
      self.by = by
      self.state = "terminated"
      self.terminated_at = Time.zone.now
      self
    end

    def current?
      self.state == "current"
    end

    def terminated?
      self.state == "terminated"
    end

    private

    def constrain_route_description
      return unless medication_route

      case
      when medication_route.other? && !route_description.present?
        errors.add(:route_description, :blank)
      when !medication_route.other? && route_description.present?
        errors.add(:route_description, :not_other)
      end
    end
  end
end
