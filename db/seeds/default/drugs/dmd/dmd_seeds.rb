require_relative "../../../seeds_helper"

module Renalware
  module Drugs::DMD
    DMD_UPSERT_BATCH_SIZE = ENV.fetch("DMD_UPSERT_BATCH_SIZE", 1_000).to_i

    def self.upsert_csv_in_batches(file_path, model, unique_by:, &)
      CSV.foreach(file_path, headers: true).each_slice(DMD_UPSERT_BATCH_SIZE) do |rows|
        upserts = rows.map(&)
        model.upsert_all(upserts, unique_by: unique_by)
      end
    end

    Rails.benchmark "DM+D -> Forms" do
      file_path = File.join(File.dirname(__FILE__), "dmd_forms.csv")

      repository = lambda {
        CSV.foreach(file_path, headers: true).map do |row|
          Drugs::DMD::Repositories::FormRepository::Entry.new(
            name: row["name"],
            code: row["code"]
          )
        end
      }

      APISynchronisers::FormSynchroniser.new(form_repository: repository).call
    end

    Rails.benchmark "DM+D -> Routes" do
      file_path = File.join(File.dirname(__FILE__), "dmd_routes.csv")

      repository = lambda {
        CSV.foreach(file_path, headers: true).map do |row|
          Repositories::RouteRepository::Entry.new(
            name: row["name"],
            code: row["code"]
          )
        end
      }

      APISynchronisers::RouteSynchroniser.new(route_repository: repository).call
      rr22_other_code = Medications::MedicationRoute.rr22_code_for("Other")
      Medications::MedicationRoute.where(rr_code: nil).update!(rr_code: rr22_other_code)
      Medications::MedicationRoute.where(name: "Oral").update!(weighting: 10)
      Medications::MedicationRoute.where(name: "Subcutaneous").update!(weighting: 9)
    end

    Rails.benchmark "DM+D -> UnitOfMeasures" do
      file_path = File.join(File.dirname(__FILE__), "dmd_unit_of_measures.csv")

      repository = lambda {
        CSV.foreach(file_path, headers: true).map do |row|
          Repositories::UnitOfMeasureRepository::Entry.new(
            name: row["name"],
            code: row["code"]
          )
        end
      }

      APISynchronisers::UnitOfMeasureSynchroniser.new(unit_of_measure_repository: repository).call
    end

    Rails.benchmark "DM+D -> VirtualTherapeuticMoiety" do
      file_path = File.join(File.dirname(__FILE__),
                            "dmd_virtual_therapeutic_moieties.csv")

      repository = lambda {
        CSV.foreach(file_path, headers: true).map do |row|
          Repositories::VirtualTherapeuticMoietyRepository::Entry.new(
            name: row["name"],
            code: row["code"],
            inactive: false
          )
        end
      }

      APISynchronisers::VirtualTherapeuticMoietySynchroniser.new(vtm_repository: repository).call
    end

    Rails.benchmark "DM+D -> VirtualMedicalProduct" do
      file_path = File.join(File.dirname(__FILE__), "dmd_virtual_medical_products.csv")

      upsert_csv_in_batches(file_path, VirtualMedicalProduct, unique_by: :code) do |row|
        row.to_h.slice(
          "name",
          "code",
          "form_code",
          "route_code",
          "unit_dose_uom_code",
          "unit_dose_form_size_uom_code",
          "active_ingredient_strength_numerator_uom_code",
          "basis_of_strength",
          "strength_numerator_value",
          "virtual_therapeutic_moiety_code",
          "atc_code"
        )
      end
    end

    Rails.benchmark "DM+D -> ActualMedicalProduct" do
      file_path = File.join(File.dirname(__FILE__), "dmd_actual_medical_products.csv")

      upsert_csv_in_batches(file_path, ActualMedicalProduct, unique_by: :code) do |row|
        {
          code: row["code"],
          virtual_medical_product_code: row["virtual_medical_product_code"],
          trade_family_code: row["trade_family_code"]
        }
      end
    end

    Rails.benchmark "DM+D -> TradeFamilies" do
      file_path = File.join(File.dirname(__FILE__), "drug_trade_families.csv")

      upsert_csv_in_batches(file_path, Drugs::TradeFamily, unique_by: :code) do |row|
        {
          name: row["name"],
          code: row["code"]
        }
      end
    end

    Rails.benchmark "DM+D -> ClassificationAndDrugsSynchroniser" do
      Synchronisers::ClassificationAndDrugsSynchroniser.new.call
    end

    Rails.benchmark "DM+D -> enabling a handful of trade families" do
      file_path = File.join(File.dirname(__FILE__), "enabled_trade_families.csv")

      trade_family_name_to_id_mapping = Drugs::TradeFamily.pluck(:name, :id).to_h
      enabled_trade_family_ids = CSV.foreach(file_path, headers: true).map do |row|
        trade_family_name_to_id_mapping[row["name"]]
      end

      Drugs::TradeFamilyClassification.where(trade_family_id: enabled_trade_family_ids)
        .update_all(enabled: true)
    end
  end
end
