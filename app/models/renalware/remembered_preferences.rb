# frozen_string_literal: true

module Renalware
  class RememberedPreferences
    def initialize(session)
      @session = session
    end

    def persist(model)
      return unless model

      self.class::ATTRIBUTES_TO_REMEMBER.each do |attribute|
        remembered_attributes[attribute] = model.public_send(attribute)
      end
      session[self.class::SESSION_KEY] = remembered_attributes
    end

    def apply_to(model)
      return unless model

      self.class::ATTRIBUTES_TO_REMEMBER.each do |attribute|
        unless model.public_send(:"#{attribute}?")
          model.public_send(:"#{attribute}=", remembered_attributes[attribute])
        end
      end
    end

    protected

    attr_accessor :session

    def remembered_attributes
      @remembered_attributes ||= session.fetch(self.class::SESSION_KEY, {}).with_indifferent_access
    end
  end
end
