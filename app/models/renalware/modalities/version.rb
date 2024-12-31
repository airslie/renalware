module Renalware
  module Modalities
    class Version < PaperTrail::Version
      self.table_name = :modality_versions
    end
  end
end
