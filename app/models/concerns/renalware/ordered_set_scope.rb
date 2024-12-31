module Renalware
  module OrderedSetScope
    extend ActiveSupport::Concern

    class_methods do
      # Produces a scope that orders a relation based on a attribute and the
      # order of the values.
      #
      # @example
      #
      # Give the relation 'qux':
      #   |id | code |
      #   | 1 | baz  |
      #   | 2 | bar  |
      #   | 3 | foo  |
      #
      # When I execute the following:
      #
      #   Qux.fixed_order_for(:code, %i(foo bar))
      #
      # Then the following set is returned:
      #   |id | code |
      #   | 3 | foo  |
      #   | 2 | bar  |
      #
      # The implementation is based on this blog post:
      # http://sqlandme.com/2013/11/18/sql-server-custom-sorting-in-order-by-clause/
      #
      def ordered_set(attribute, values)
        verified_values = verify_values(attribute, values.map(&:to_s))

        where(attribute => verified_values)
          .order(Arel.sql("CASE #{generate_conditions(attribute, values.uniq)} END"))
      end

      private

      # Verify the values exist in the database, prevents a SQL inject attack
      # when ordering, as order scopes doesn't sanitize.
      #
      def verify_values(attribute, values)
        values & where(attribute => values).pluck(attribute)
      end

      # Example:
      #   Given the following:
      #     attribute: 'code'
      #     values: %w(foo bar)

      #   Then generates:
      #     WHEN code = 'foo' THEN 0
      #     WHEN code = 'bar' THEN 1
      #
      def generate_conditions(attribute, values)
        values.each_with_index.map do |value, idx|
          "WHEN #{attribute} = '#{value}' THEN '#{idx}'"
        end.join(" ")
      end
    end
  end
end
