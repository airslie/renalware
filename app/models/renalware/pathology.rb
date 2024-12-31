module Renalware
  module Pathology
    module_function

    def table_name_prefix = "pathology_"
    def cast_patient(patient) = patient.becomes(Pathology::Patient)

    class MissingRequestDescriptionError < StandardError; end
    class MissingObservationDescriptionError < StandardError; end
  end
end
