module Renalware
  module UKRDC
    class SummaryMailer < ApplicationMailer
      def export_summary(to: "dev@airslie.com", **args)
        mail(
          to: Array(to),
          subject: "UKRDC export summary #{I18n.l(Time.zone.today)}"
        ) do |format|
          format.html { render(locals: args) }
        end
      end
    end
  end
end
