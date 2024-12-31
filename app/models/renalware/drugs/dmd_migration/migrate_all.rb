module Renalware
  module Drugs
    module DMDMigration
      class MigrateAll
        def call
          PopulateAtcCodesForDrugTypes.new.call
          RouteMigrator.new.call
          UnitOfMeasureMigrator.new.call
          FormMigrator.new.call

          TradeFamilyMigrator.new.call
          DrugMigrator.new.call
        end
      end
    end
  end
end
