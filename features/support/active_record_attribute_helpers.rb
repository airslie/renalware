module ActiveRecordAttributeHelpers
  def bool_from_string(value)
    ActiveRecord::Type::Boolean.new.cast(value)
  end
end

World(ActiveRecordAttributeHelpers)
