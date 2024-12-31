module Renalware
  module Accesses
    class Version < PaperTrail::Version
      self.table_name = :access_versions
    end
  end
end
