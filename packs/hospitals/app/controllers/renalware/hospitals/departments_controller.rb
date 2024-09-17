# frozen_string_literal: true

module Renalware
  module Hospitals
    class DepartmentsController < BaseController
      def index
        departments = centre.departments.includes(:hospital_centre).ordered
        authorize departments
        render locals: { centre: centre, departments: departments }
      end

      def new
        department = centre.departments.new
        authorize department
        render_new(department)
      end

      def edit
        render_edit(find_and_authorize_department)
      end

      def create
        department = centre.departments.new(department_params)
        authorize department

        if department.save
          redirect_to(
            hospitals.centre_departments_path(centre),
            notice: success_msg_for("department")
          )
        else
          flash.now[:error] = failed_msg_for("department")
          render_new(department)
        end
      end

      def update
        department = find_and_authorize_department
        if department.update(department_params)
          redirect_to hospitals.centre_departments_path, notice: success_msg_for("department")
        else
          flash.now[:error] = failed_msg_for("department")
          render_edit(department)
        end
      end

      # def destroy
      #   hospital_unit = find_and_authorize_hospital_unit
      #   hospital_unit.destroy!
      #   redirect_to hospitals.units_path, notice: success_msg_for("hospital unit")
      # end

      private

      def centre
        @centre ||= Centre.find(params[:centre_id])
      end

      def render_new(department)
        render :new, locals: { centre: centre, department: department }
      end

      def render_edit(department)
        render :edit, locals: { centre: centre, department: department }
      end

      def find_and_authorize_department
        centre.departments.find(params[:id]).tap { |dep| authorize dep }
      end

      def department_params
        params.require(:department).permit(
          :name, address_attributes: address_attributes
        )
      end

      def address_attributes
        [
          :id, :name, :organisation_name, :street_1, :street_2, :street_3, :town, :county,
          :postcode, :country_id, :telephone, :email, :_destroy
        ]
      end
    end
  end
end
