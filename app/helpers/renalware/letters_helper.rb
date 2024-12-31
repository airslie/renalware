module Renalware
  module LettersHelper
    def letters_breadcrumb(patient)
      breadcrumb_for("Letters", patient_letters_letters_path(patient))
    end

    def patient_letters_letters_path(patient, event = nil)
      if event.present?
        super(patient, event_type: event.class.to_s, event_id: event.id)
      else
        super(patient)
      end
    end

    def inline_value(label, value, unit = nil)
      [
        tag.strong("#{label}: "),
        value,
        unit
      ].flatten.join(" ").html_safe
    end

    def patient_letters_letter_print_path(letter)
      patient_letters_letter_formatted_path(letter.patient,
                                            letter,
                                            format: "pdf", disposition: "inline")
    end

    def patient_letters_letter_download_path(letter, format = :pdf)
      patient_letters_letter_formatted_path(letter.patient, letter, format: format)
    end

    def patient_letters_letter_preview_path(letter)
      patient_letters_letter_formatted_path(letter.patient, letter)
    end

    def state_options
      Letters::Letter.states.map do |state|
        label = I18n.t(state.to_sym, scope: "enums.letter.state")
        [label, state]
      end
    end

    def state_options_for_receptionists
      Letters::Letter.states.map do |state|
        label = I18n.t(state.to_sym, scope: "enums.letter.for_receptionists.state")
        [label, state]
      end
    end
  end
end
