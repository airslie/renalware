module Renalware
  describe Feeds::SausageQueue do
    it :aggregate_failures do
      is_expected.to have_db_index(:feed_sausage_id)
    end
  end
end
