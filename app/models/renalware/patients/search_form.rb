# A form object for use behind a form (see to_partial_path) which can add a patient filter
# to a page. See Letters/ElectronicReceiptsController for an example.
# Works in concert with Patients::SearchQuery.
module Renalware
  module Patients
    class SearchForm
      include ActiveModel::Model
      attr_accessor :term, :url

      def to_partial_path
        "renalware/patients/search_form"
      end
    end
  end
end
