# frozen_string_literal: true

module Renalware
  module UKRDC
    class SummaryMailer < ApplicationMailer
      def export_summary(to: "dev@airslie.com", **args)
        mail(
          to: Array(to),
          subject: "UKRDC export summary #{I18n.l(Time.zone.today)}"
        ) do |format|
          format.text { render(locals: args) }
          format.html { render(locals: args) }
        end
      end
    end
  end
end
