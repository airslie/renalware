module Renalware
  module Pathology
    class Version < PaperTrail::Version
      self.table_name = :pathology_versions
    end
  end
end
