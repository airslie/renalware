ParameterType(
  name: "date",
  regexp: /(\d{2})-(\d{2})-(\d{4})/,
  transformer: ->(day, month, year) { Date.new(year.to_i, month.to_i, day.to_i) }
)
