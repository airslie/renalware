# A Liquid 'Drop' - a safe, read-only presenter compatible with Liquid templates.
# We use Liquid templates for one-off hospital-specific views or print-outs.

module Renalware
  module PD
    class ExitSiteInfectionDrop < Liquid::Drop
      delegate :outcome, :diagnosis_date, to: :esi

      def initialize(esi)
        @esi = esi
      end

      def organisms
        esi.infection_organisms.map(&:to_s).join(", ")
      end

      def date
        I18n.l(diagnosis_date)
      end

      private

      attr_reader :esi
    end
  end
end
