module Renalware
  # How the GP's copy of an approved letter is delivered. This replaces direct use of the
  # send_gp_letters_over_mesh boolean, which was doing several jobs at once (enable sending,
  # set gp_send_status, and decide what the print list shows).
  #
  #   :none          GP copy is printed. gp_send_status is not_applicable. (default)
  #   :builtin_mesh  Renalware sends it over MESH itself (GP Connect Send Document), and
  #                  tracks the outcome in gp_send_status.
  #   :relay         Reserved for delivery via the Relay service. Not yet implemented.
  #
  # Configured by GP_LETTER_DELIVERY. When that is unset we fall back to the legacy
  # SEND_GP_LETTERS_OVER_MESH boolean (true => :builtin_mesh) so existing deployments are
  # unaffected.
  #
  # This lives in lib/ (not app/) because the scheduled jobs config reads it from an
  # initializer, before app/ classes can be autoloaded.
  class GPLetterDelivery
    MODES = %i(none builtin_mesh relay).freeze

    class << self
      def current
        mode = explicit_mode || legacy_mode
        raise_if_unsupported(mode)
        mode
      end

      # The GP copy is expected to be delivered electronically, so gp_send_status is
      # meaningful and a pending copy should not yet be printed.
      def electronic? = current != :none

      # Renalware itself talks to MESH (queues transmissions, polls the inbox etc).
      def builtin_mesh? = current == :builtin_mesh

      private

      def explicit_mode
        value = Renalware.config.gp_letter_delivery.to_s.strip
        return if value.blank?

        value.to_sym.tap do |mode|
          next if MODES.include?(mode)

          raise ArgumentError,
                "Unknown GP_LETTER_DELIVERY #{value.inspect}, expected: #{MODES.join(', ')}"
        end
      end

      def legacy_mode
        Renalware.config.send_gp_letters_over_mesh ? :builtin_mesh : :none
      end

      def raise_if_unsupported(mode)
        return unless mode == :relay

        raise NotImplementedError,
              "GP_LETTER_DELIVERY=relay is not implemented yet. Letters would be left " \
              "pending and never sent."
      end
    end
  end
end
