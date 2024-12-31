# Example:
#
#     indexed_case_stmt(:code, "DT", "AC", "XY")
#
# Will return the string:
#
#    CASE code
#       WHEN 'DT' THEN 1
#       WHEN 'AC' THEN 2
#    END
#
# Used for creating an explicit sort order in conjunction with a find:
#
#    Description.where(code: codes).order(indexed_case_stmt(:code, codes))
#
class SqlIndexedCaseStmt
  pattr_initialize :column, :items

  def generate
    return if items.blank?

    clauses = []
    Array(items).each_with_index do |item, index|
      clauses << Arel.sql("WHEN '#{item}' THEN #{index}")
    end

    Arel.sql("CASE #{column} #{clauses.join(' ')} END")
  end
end
