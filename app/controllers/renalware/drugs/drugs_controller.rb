# frozen_string_literal: true

module Renalware
  module Drugs
    class DrugsController < BaseController
      include Pagy::Backend

      after_action :track_action, except: [:selected_drugs, :prescribable]

      def prescribable
        authorize Renalware::Drugs::Drug, :prescribable?
        term = params[:term]
        type = params[:type]

        render json: find_drugs_matching_term_and_ordered_by_relevance(term, type)
      end

      # Return a list of drugs as JSON for specific drug type (medication_switch)
      # TODO: Make a separate resource eg drug_/esa/drugs.json. E.g.
      # drug_type.drugs.ordered.pluck(:id, :name)
      def selected_drugs
        selected_drugs = Drug.for(params[:medication_switch])
          .ordered
          .pluck(:id, :name)
        authorize Renalware::Drugs::Drug, :selected_drugs?
        render json: selected_drugs
      end

      def index
        drugs = drug_search.result(distinct: true)
        authorize drugs

        respond_to do |format|
          format.html do
            pagy, drugs = pagy(drugs)
            render locals: { drugs: drugs, pagy: pagy, drug_search: drug_search }
          end
          format.json { render json: drugs }
        end
      end

      def new
        @drug = Drug.new
        authorize @drug
      end

      def edit
        @drug = Drug.find(params[:id])
        authorize @drug
      end

      def create
        @drug = Drug.new(drug_params)
        authorize @drug

        if @drug.save
          refresh_prescribable_drugs_materialised_view
          redirect_to drugs_drugs_path, notice: success_msg_for("drug")
        else
          flash.now[:error] = failed_msg_for("drug")
          render :new
        end
      end

      def update
        @drug = Drug.find(params[:id])
        authorize @drug
        if @drug.update(drug_params)

          enabled_trade_family_ids = params[:drugs_drug][:enabled_trade_family_ids]

          Drug.transaction do
            @drug.trade_family_classifications
              .update_all(enabled: false)
            @drug.trade_family_classifications.where(trade_family_id: enabled_trade_family_ids)
              .update_all(enabled: true)
          end
          refresh_prescribable_drugs_materialised_view
          redirect_to drugs_drugs_path, notice: success_msg_for("drug")
        else
          flash.now[:error] = failed_msg_for("drug")
          render :edit
        end
      end

      def destroy
        authorize Drug.destroy(params[:id])
        refresh_prescribable_drugs_materialised_view
        redirect_to drugs_drugs_path, notice: success_msg_for("drug")
      end

      private

      def sanitize(*) = Arel.sql(ActiveRecord::Base.sanitize_sql_array(*))

      def find_drugs_matching_term_and_ordered_by_relevance(term, type)
        drugs = Drugs::PrescribableDrug
        if type.present?
          drugs = drugs.joins(:drug_types).where(drug_types: { code: type })
        end
        drugs.where(sanitize(["compound_name ilike ?", "%#{term}%"]))
          .or(
            Drugs::PrescribableDrug.where(
              sanitize(["SIMILARITY(compound_name,?) > 0.3", "%#{term}%"])
            )
          )
          .order(
            sanitize(["compound_name ilike ? desc", "#{term}%"]),
            sanitize(["SIMILARITY(compound_name,?) desc", term]),
            "compound_name"
          )
      end

      def drug_params
        params.require(:drugs_drug).permit(
          :name, :deleted_at, drug_type_ids: []
        )
      end

      def drug_search
        @drug_search ||= begin
          search_params = params.fetch(:q, { inactive_eq: false })
          Drug.ransack(search_params).tap { |query| query.sorts = "name" }
        end
      end

      def refresh_prescribable_drugs_materialised_view
        Scenic.database.refresh_materialized_view(
          PrescribableDrug.table_name,
          concurrently: true,
          cascade: false
        )
      end
    end
  end
end
