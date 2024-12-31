module Renalware
  module Virology
    class VaccinationPresenter < ApplicationPresenter
      include Renalware::Engine.routes.url_helpers

      # Return an array to be loaded into an html select, where each option has a data attribute
      # pointing to the current url with a vaccination_type_id appended.
      # The turbo frame in the _inputs partial issues a GET to this url when the option is selected
      # in order to refresh the list of vaccine drugs associated with the vaccination type
      # (via atc_codes).
      def types_collection(url)
        Renalware::Virology::VaccinationType.ordered.select(:id, :name, :code).map do |opt|
          [
            opt[:name],
            opt[:code],
            {
              data: {
                frame_url: url_with_vaccination_type_id(url, opt[:id])
              }
            }
          ]
        end
      end

      def drugs_collection(vaccination_type)
        VaccinesQuery.new(vaccination_type: vaccination_type)
          .call
          .pluck(:compound_name, :compound_name)
      end

      # Note that a new or edit url for a vaccination could be eg vaccinations/new or events/new
      # depending on the context (a controller/routing concern) so we
      # remain agnostic about context here and just try and make sure the current url
      # has e.g. vaccination_type_id=123 in the query string.
      def url_with_vaccination_type_id(url, vaccination_type_id)
        url.gsub!(".js", "")
        uri = URI.parse(url)
        vaccination_type_query = { vaccination_type_id: vaccination_type_id }.to_a
        params = URI.decode_www_form(uri.query || "") + vaccination_type_query
        uri.query = URI.encode_www_form(params)
        uri.to_s
      end
    end
  end
end
