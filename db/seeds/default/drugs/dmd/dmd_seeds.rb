# frozen_string_literal: true

require_relative "../../../seeds_helper"

module Renalware
  module Drugs::DMD
    extend SeedsHelper

    log "DM+D -> Forms" do
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

    log "DM+D -> Routes" do
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

    log "DM+D -> UnitOfMeasures" do
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

    log "DM+D -> VirtualTherapeuticMoiety" do
      file_path = File.join(File.dirname(__FILE__),
                            "dmd_virtual_therapeutic_moieties.csv")

      repository = lambda {
        CSV.foreach(file_path, headers: true).map do |row|
          Repositories::VirtualTherapeuticMoietyRepository::Entry.new(
            name: row["name"],
            code: row["code"]
          )
        end
      }

      APISynchronisers::VirtualTherapeuticMoietySynchroniser.new(vtm_repository: repository).call
    end

    log "DM+D -> VirtualMedicalProduct" do
      file_path = File.join(File.dirname(__FILE__), "dmd_virtual_medical_products.csv")

      upserts = CSV.foreach(file_path, headers: true).map do |row|
        {
          name: row["name"],
          code: row["code"],
          form_code: row["form_code"],
          route_code: row["route_code"],
          unit_dose_uom_code: row["unit_dose_uom_code"],
          unit_dose_form_size_uom_code: row["unit_dose_form_size_uom_code"],
          active_ingredient_strength_numerator_uom_code:
            row["active_ingredient_strength_numerator_uom_code"],
          basis_of_strength: row["basis_of_strength"],
          strength_numerator_value: row["strength_numerator_value"],
          virtual_therapeutic_moiety_code: row["virtual_therapeutic_moiety_code"],
          atc_code: row["atc_code"]
        }
      end

      VirtualMedicalProduct.upsert_all(upserts, unique_by: :code)
    end

    log "DM+D -> ActualMedicalProduct" do
      file_path = File.join(File.dirname(__FILE__), "dmd_actual_medical_products.csv")
      upserts = CSV.foreach(file_path, headers: true).map do |row|
        {
          code: row["code"],
          virtual_medical_product_code: row["virtual_medical_product_code"],
          trade_family_code: row["trade_family_code"]
        }
      end

      ActualMedicalProduct.upsert_all(upserts, unique_by: :code)
    end

    log "DM+D -> TradeFamilies" do
      file_path = File.join(File.dirname(__FILE__), "drug_trade_families.csv")

      upserts = CSV.foreach(file_path, headers: true).map do |row|
        {
          name: row["name"],
          code: row["code"]
        }
      end
      Drugs::TradeFamily.upsert_all(upserts, unique_by: :code)
    end

    log "DM+D -> ClassificationAndDrugsSynchroniser" do
      Synchronisers::ClassificationAndDrugsSynchroniser.new.call
    end

    log "DM+D -> enabling a handful of trade families" do
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
