module Renalware
  module System
    class Version < PaperTrail::Version
      self.table_name = :system_versions
    end
  end
end
