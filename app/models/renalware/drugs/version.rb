module Renalware
  module Drugs
    class Version < PaperTrail::Version
      # Without an explicit table_name, changes will persists to the generic 'versions' table
      self.table_name = :drug_versions
    end
  end
end
