module Renalware
  class EffectiveUpdatedInfoPresenter
    include ::Renalware::AccountablePresentation

    def initialize(record)
      @record = record
    end

    delegate :updated_at, :created_at, :updated_by, to: :record

    private

    attr_reader :record
  end
end
