# frozen_string_literal: true

module Renalware
  module Virology
    class VaccinationTypesController < BaseController
      def index
        types = VaccinationType.with_deleted.ordered
        authorize types
        render locals: { types: types }
      end

      def new
        type = VaccinationType.new
        authorize type
        render locals: { type: type }
      end

      def edit
        type = find_and_authorise_type
        render locals: { type: type }
      end

      def create
        type = VaccinationType.new(type_params)
        authorize type
        if type.save
          redirect_to virology_vaccination_types_path
        else
          render :new, locals: { type: type }
        end
      end

      def update
        type = find_and_authorise_type
        if type.update(type_params)
          redirect_to virology_vaccination_types_path
        else
          render :edit, locals: { type: type }
        end
      end

      def destroy
        find_and_authorise_type.destroy!
        redirect_to virology_vaccination_types_path
      end

      def move
        find_and_authorise_type.insert_at(params[:position].to_i)

        head :ok
      end

      private

      def find_and_authorise_type
        VaccinationType.find(params[:id]).tap { |type| authorize type }
      end

      def type_params
        params
          .require("virology_vaccination_type")
          .permit(:name, :code, :position, atc_codes: [])
      end
    end
  end
end
