class BigintPkConversions1 < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      # A test migration converting integer PKs to bigint for some example tables.
      # A some point we should apply this (and to FKs) across the board
      # Rails used to use integer (4 bytes) PK/FKs with a max value of 2,147,483,648 (2 billion)
      # which sounds a lot, but in terms of feed_messages/pathology, it puts an unnecessary
      # limit in place. 2 billion rows is 20 years at 100 million a year. Even if a large table
      # was truncated/housekept to only keep the 100m rows, the ids still increment and would
      # eventually reach their limit. Fixing an outage where a PK had maxed at 2bn would be
      # an interesting proposition, even if it is for an AI 20 years from now!
      # Rails more recently uses bigint (max 9223372036854775808) for PKs and FKs which is more
      # sensible.
      # Some bigint conversions might baulk if the affected column is returned from a SQL view,
      # so the view would need to be changed (or dropped and re-created) at the same time.
      # Unfortunately where we should embrace bigint the most is for the largest tables, which
      # will take a long time to convert, and the table is locked during the conversion, so
      # converting eg pathology_observations.id will need some careful testing.
      # You see a list of tables where we could convert to bigint here
      # https://github.com/airslie/renalwarev2/issues/4858 4859 4860
      safety_assured do
        reversible do |direction|
          direction.up do
            change_column :directory_people, :id, :bigint
            change_column :snippets_snippets, :id, :bigint
            change_column :feed_file_types, :id, :bigint
          end
          direction.down do
            change_column :directory_people, :id, :integer
            change_column :snippets_snippets, :id, :integer
            change_column :feed_file_types, :id, :integer
          end
        end
      end
    end
  end
end
