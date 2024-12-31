module Renalware
  module Pathology
    module Requests
      class RequestsFactory
        pattr_initialize :patients, :params

        def build
          patients.map do |patient|
            RequestFactory.new(patient, params).build
          end
        end
      end
    end
  end
end
