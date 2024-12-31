module Renalware
  module Concerns::ReturnTo
    extend ActiveSupport::Concern

    included do
      helper_method :return_to_param, :back_url
    end

    def return_to_param
      return_to = params[:return_to].presence
      return unless return_to

      uri = URI.parse(return_to)
      uri.scheme = nil
      uri.port = nil
      uri.host = nil
      uri.to_s
    end

    def back_url(fallback_url)
      if request.env["HTTP_REFERER"].present? &&
         URI.parse(request.env["HTTP_REFERER"]).path != request.env["REQUEST_URI"]
        :back
      else
        fallback_url
      end
    end
  end
end
