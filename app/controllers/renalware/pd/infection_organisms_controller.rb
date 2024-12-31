module Renalware
  module PD
    class InfectionOrganismsController < BaseController
      def index
        @infectable = infectable_class.find(infectable_id)
        @infection_organisms = @infectable.infection_organisms

        authorize @infectable.patient
      end

      def new
        @infectable = infectable_class.find(infectable_id)
        @infection_organism = InfectionOrganism.new

        authorize @infectable.patient
      end

      def edit
        @infection_organism = InfectionOrganism.find(params[:id])
        @infectable = @infection_organism.infectable

        authorize @infectable.patient
      end

      def create
        @infectable = infectable_class.find(infectable_id)

        authorize @infectable.patient

        @infection_organism = @infectable.infection_organisms.create(infection_organism_params)
      end

      def update
        @infection_organism = InfectionOrganism.find(params[:id])
        @infectable = @infection_organism.infectable

        authorize @infectable.patient

        @infection_organism.update(infection_organism_params)
      end

      def destroy
        @infection_organism = InfectionOrganism.find(params[:id])
        @infectable = @infection_organism.infectable
        @infection_organisms = @infectable.infection_organisms

        authorize @infectable.patient

        @infection_organism.destroy!
      end

      private

      def infection_organism_params
        params
          .require(:pd_infection_organism)
          .permit(:organism_code_id, :sensitivity, :resistance)
      end

      def infectable_class
        @infectable_class ||= infectable_type.singularize.classify.constantize
      end

      def infectable_type
        params.fetch(:infectable_type)
      end

      def infectable_id
        params.fetch(:infectable_id)
      end
    end
  end
end
