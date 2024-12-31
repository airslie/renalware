module Renalware
  class Renalware::TimeOfDayPresenter < SimpleDelegator
    def to_s
      ::I18n.l self, format: :time
    end
  end
end
