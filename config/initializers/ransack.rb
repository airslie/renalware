Ransack.configure do |config|
  # Change default search parameter key name.
  # Default key name is :q
  # config.search_key = :query

  # Raise errors if a query contains an unknown predicate or attribute.
  # Default is true (do not raise error on unknown conditions).
  config.ignore_unknown_conditions = !Rails.env.local?

  # Globally display sort links without the order indicator arrow.
  # Default is false (sort order indicators are displayed).
  # This can also be configured individually in each sort link (see the README).
  # config.hide_sort_order_indicators = true
  #

  # Add a predicate to allow a datepicker for instance to find all items
  # with a certain created_at. It ensures the datetime is resolved as a date.
  # See
  # - https://github.com/activerecord-hackery/ransack/issues/101
  # - https://github.com/activerecord-hackery/ransack/wiki/Custom-Predicates
  config.add_predicate(
    "date_equals",
    arel_predicate: "eq",
    formatter: proc { |val| val&.to_date },
    validator: proc { |val| val.present? },
    type: :string
  )

  # This predicate is used for example in letters/lists/show when a users filters a list of letters
  # to display only letters with a page cont of 1 or 2, or 3 or 4, e.g.
  # = f.input :page_count_in_array, collection: [["1 or 2", "[1,2]"],["3 or 4", "[3,4]"]]
  config.add_predicate(
    "in_array",
    arel_predicate: "in",
    formatter: proc { |val| val.to_s.scan(/\d+/).map(&:to_i) },
    validator: proc { |val| val.present? },
    type: :array
  )

  # Make NULLS always sink to the bottom when sorting eg by a date desc, so that
  # and there are NULL dates, the NULLs will appear last, ie treated as far-past dates.
  # While there is a nulls_last option, nulls_first is actually what we want here.
  config.postgres_fields_sort_option = :nulls_first
end
