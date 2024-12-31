require_relative "letterheads"
require_relative "letter_topics"
require_relative "contact_descriptions"
require_relative "contacts"
require_relative "rabbit"

# Create demo SQL view to demostrate mailshots
ActiveRecord::Base.connection.execute(<<-SQL.squish)
  create or replace view renalware.letter_mailshot_patients_where_surname_starts_with_r
  as select id as patient_id from patients where family_name like 'R%';
SQL
