module Renalware
  module Deaths
    class LocationsController < BaseController
      def index
        locations = Location.with_deleted.order(:name)
        authorize locations
        render locals: { locations: locations }
      end

      def new
        location = Location.new
        authorize location
        render locals: { location: location }
      end

      def edit
        location = Location.find(params[:id])
        authorize location
        render(locals: { location: location })
      end

      def create
        location = Location.new(location_params)
        authorize location
        if location.save
          redirect_to deaths_locations_path
        else
          render :new, locals: { location: location }
        end
      end

      def update
        location = Location.find(params[:id])
        authorize location
        if location.update(location_params)
          redirect_to deaths_locations_path
        else
          render(:edit, locals: { location: location })
        end
      end

      def destroy
        location = Location.find(params[:id])
        authorize location
        location.destroy
        redirect_to deaths_locations_path
      end

      private

      def location_params
        params
          .require(:location)
          .permit(:name, :rr_outcome_code, :rr_outcome_text)
      end
    end
  end
end
