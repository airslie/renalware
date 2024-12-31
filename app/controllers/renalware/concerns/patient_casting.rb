require "active_support/concern"

module Renalware
  module Concerns
    module PatientCasting
      extend ActiveSupport::Concern

      included do
        # Create a method in the controller to cast the patient to its module version
        # if there is one eg if we are in the HD module and there is an HD::Patient class
        # defined then create a memoised getter
        # equivalent to:
        #   def hd_patient
        #     @hd_patient ||= HD.cast_patient(patient)
        #   end
        # This assumes #patient is defined in a superclass probably Renalware::BaseController
        def self.create_casted_patient_getter
          namespace_name = to_s.deconstantize # e.g. "Renalware::HD"
          module_name = namespace_name.split("::")[1] # e.g. "HD"
          method_name = :"#{module_name.underscore}_patient" # e.g. hd_patient
          var_name = "@#{method_name}" # e.g. @hd_patient

          define_method(method_name) do
            return instance_variable_get(var_name) if instance_variable_defined?(var_name)

            namespace_name.constantize.cast_patient(patient).tap do |a_patient|
              instance_variable_set var_name, a_patient
            end
          end
        end

        create_casted_patient_getter
      end
    end
  end
end
