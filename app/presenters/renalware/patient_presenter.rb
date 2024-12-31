module Renalware
  class PatientPresenter < DumbDelegator
    def address
      AddressPresenter::SingleLine.new(current_address)
    end

    def to_s(format = :long)
      super
    end

    def nhs_number
      return super unless super.present? && super.length >= 10
      return if super.index(" ")

      # "#{super[0..2]} #{super[3..5]} #{super[6..-1]}"
      # Rubocop prefers:
      "#{super[0..2]} #{super[3..5]} #{super[6..]}"
    end

    def rpv_decision
      [
        ::I18n.l(rpv_decision_on),
        rpv_recorded_by
      ].compact.join(" by ")
    end

    def renalreg_decision
      [
        ::I18n.l(renalreg_decision_on),
        renalreg_recorded_by
      ].compact.join(" by ")
    end
  end
end
