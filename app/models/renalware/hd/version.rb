module Renalware
  module HD
    class Version < PaperTrail::Version
      self.table_name = :hd_versions
    end
  end
end
