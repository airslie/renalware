module Renalware
  module Drugs
    module DMDMigration
      class RouteMigrator
        MAPPINGS = {
          "Per Oral" => "Oral",
          "Intravenous" => "Intravenous",
          "Subcutaneous" => "Subcutaneous",
          "Intramuscular" => "Intramuscular",
          "Intraperitoneal" => "Intraperitoneal",
          "Inhaler" => "Inhalation",
          "Sublingual" => "Sublingual",
          "Nasogastric" => "Gastroenteral",
          # Parenteral - cannot use anything as parenteral can be intramuscular, intravenous
          # or subcut. Will therefore need to look at the individual cases.
          # "Parenteral" => "",
          "Percutaneous" => "Cutaneous",
          # Topical difficult as can be eye drops, ear drops or some skin stuff
          # (or even topical stuff to a cut tongue. Can we look at the cases -
          #   lots should just be cutaneous (eg all the Gentamicin Cream to PD catheter exit site.

          # "Topical" => "", # ? which one

          # Best to leave, as this ties with the now removed "Route Description" textbox
          # "Other" => "",
          "PerRectum" => "Rectal" # ?
        }.freeze

        def call
          # TODO: where inactive??
          dmd_only_routes_by_name = Medications::MedicationRoute
            .where.not(code: nil)
            .index_by(&:name)

          Medications::MedicationRoute.where.not(rr_code: nil).find_each do |old_route|
            matched_route_name = MAPPINGS[old_route.name]
            next unless matched_route_name

            matching_dmd_route = dmd_only_routes_by_name[matched_route_name]
            next unless matching_dmd_route

            Medications::Prescription.where(medication_route_id: old_route.id)
              .update_all(
                medication_route_id: matching_dmd_route.id,
                legacy_medication_route_id: old_route.id
              )
          end
        end
      end
    end
  end
end
