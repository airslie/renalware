require "csv"

module Renalware
  module Drugs
    class DMDMatchesController < BaseController
      include Pagy::Backend

      def index
        authorize Drug

        dmd_matches_search = DMDMatch.ransack(params.fetch(:q, {}))
        dmd_matches_search.sorts = "name"
        pagy, dmd_matches = pagy(dmd_matches_search.result)

        render locals: {
          dmd_matches: dmd_matches,
          dmd_matches_search: dmd_matches_search,
          pagy: pagy
        }
      end

      def new
        authorize Drug

        form = Form.new

        render locals: { form: form }
      end

      def create
        authorize Drug

        form = Form.new(
          params.require(Form.model_name.param_key).permit(:file)
        )

        ProcessFile.new.call(form: form)

        redirect_to drugs_dmd_matches_path, notice: "Imported!"
      end

      private

      def drug_params
        params.require(:drugs_drug).permit(
          :name, :deleted_at, drug_type_ids: []
        )
      end

      class ProcessFile
        def call(form:)
          approved_vtms = []
          approved_trade_families = []

          CSV.foreach(form.file, headers: true) do |row|
            if row["approved_vtm_match"] == "TRUE"
              approved_vtms.push(row)
            end

            if row["approved_trade_family_match"] == "TRUE"
              approved_trade_families.push(row)
            end
          end

          approved_vtms.each do |approved_vtm|
            DMDMatch.where(drug_name: approved_vtm["drug_name"])
              .update_all(
                approved_vtm_match: true,
                vtm_name: approved_vtm["vtm_name"]
              )
          end

          approved_trade_families.each do |approved_trade_family|
            DMDMatch.where(drug_name: approved_trade_family["drug_name"])
              .update_all(
                approved_trade_family_match: true,
                trade_family_name: approved_trade_family["trade_family_name"]
              )
          end

          # Identify VTMs by Trade Family match
          DMDMigration::IdentifyVtmByTradeFamily.new.call

          # Now migrate the data
          DMDMigration::TradeFamilyMigrator.new.call
          DMDMigration::DrugMigrator.new.call
        end
      end

      class Form
        include ActiveModel::Model
        include ActiveModel::Attributes

        attribute :file
      end
    end
  end
end
