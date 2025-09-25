module Renalware
  # A value object that wraps a full qualifies column reference eg schema.table.column
  # with some AR-sanitised methods added to make it more helpful in various contexts.
  class ColumnReference
    attr_reader :schema, :table, :column

    def initialize(schema, table, column)
      @schema = schema
      @table = table
      @column = column
    end

    def quoted_table  = "#{conn.quote_table_name(schema)}.#{conn.quote_table_name(table)}"
    def quoted_column = conn.quote_column_name(column)

    private

    def conn = ActiveRecord::Base.connection
  end
end
