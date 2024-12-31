# This HDF validator is used somewhat unconventionally from the parent object (e.g. a
# the HD::SessionDocument to allow us to conditionally validate the presence of the HDF fields
# only if a condition external to the HDF class is met.
# It might be prudent to look at moving this sort of validation logic to a
# form object in the future.
module Renalware
  module Patients
    class HDFPresenceValidator < ActiveModel::EachValidator
      def validate_each(_record, _attribute, value)
        hdf = value
        attribute_names = [:subs_volume]
        attribute_names.each do |attribute_name|
          hdf.errors.add(attribute_name, :blank) if value[attribute_name].blank?
        end
      end
    end
  end
end
