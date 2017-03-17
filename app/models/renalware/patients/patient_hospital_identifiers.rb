# A patient can have may 'local hospital identifers' for example they may have come
# initially into hospital id where they were assigned the id e.g. KCH123. Subsequently
# they might move to or be treated in another hospital and may be assigned a different number.
# We capture all these numbers in the database. The hospital hosting Renalware will have a
# preference for certain numbers; for example it may wich KCH numbers to float to the top and
# always be displayed if present; if no KCH number is found continue down the list of numbers
# in order of preferred until one is. That number becomes the one displayed for example in the
# patient number, at least until another number with a higher 'preference' is assigned to the
# patient. The order of preference for local patient ids is set in Renalware.config (in an
# initialiser in the host application) in
module Renalware
  module Patients
    class PatientHospitalIdentifiers
      attr_reader :patient, :name, :value, :first
      delegate :present?, to: :name
      delegate :name, :id, to: :first
      delegate :to_s, to: :first
      alias_method :to_sym, :name

      def initialize(patient)
        @patient = patient
      end

      Identifier = Struct.new(:name, :id) do
        def to_s
          return "" unless id
          "#{name}: #{id}"
        end
      end

      def first
        @first ||= Identifier.new(*all.first)
      end

      def all
        @all ||= begin
          identifier_map.each_with_object({}) do |name_and_column, hash|
            name, column = name_and_column
            patient_id = patient.public_send(column)
            hash[name] = patient_id if patient_id.present?
          end
        end
      end

      private

      def identifier_map
        Renalware.config.patient_hospital_identifier_map
      end
    end
  end
end
