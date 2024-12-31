require "csv"

module Renalware
  module Reporting
    class SqlView
      pattr_initialize :view_name

      # Create a class under Renalware:: for this SQL name
      # Note that Ransack search_form_for requires our otherwise anonymous class to have a name.
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def klass
        return Renalware.const_get(class_name) if class_exists?

        underlying_view_name = view_name
        Class.new(ApplicationRecord) do
          include RansackAll
          self.table_name = underlying_view_name
          define_method(:to_s, ->(_x) { patient_name })
          define_method(:to_param, -> { secure_id })
          define_singleton_method(:to_csv) do |relation|
            CSV.generate do |csv|
              csv << column_names
              relation.each do |row|
                csv << row.attributes.values_at(*column_names)
              end
            end
          end
        end.tap do |klass|
          Renalware.const_set(class_name, klass)
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      private

      def class_name
        @class_name ||= begin
          unless view_name.match?(/^[.a-z_0-9]*$/)
            raise ArgumentError, "Invalid view name '#{view_name}'"
          end

          "AnonymousView#{view_name.split('.').last.camelcase}"
        end
      end

      def class_exists?
        Renalware.const_get(class_name)
      rescue NameError
        false
      end
    end
  end
end
