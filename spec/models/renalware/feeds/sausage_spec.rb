module Renalware
  describe Feeds::Sausage do
    it :aggregate_failures do
      is_expected.to have_db_index(:orc_filler_order_number).unique(true)
    end
  end
end
