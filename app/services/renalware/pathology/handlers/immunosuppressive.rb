module Renalware
  # This is currently used by the transplants letter section to ensure the
  # correct level is displayed based on whether the patient has more recent
  # tacrolimus or cyclosporin level. It then also fetches the appropriate
  # label for the level as well as the date of the result.
  #
  # FIXME: Is this the right namespace for this class or should it go into
  # a ObservationSet module?
  class Pathology::Handlers::Immunosuppressive
    def initialize(values)
      @values =
        values
          .filter { |_code, obs| obs&.any? }
          .max_by { |_code, obs| obs[:observed_at] }
    end

    def level
      result[:result]
    end

    def date
      result[:observed_at]&.to_date
    end

    def type
      title = Pathology::ObservationDescription.where(code:).pick(:name)
      "#{title} Level"
    end

    private

    def code = @values.first
    def result = @values&.second || {}
  end
end
