require "collection_presenter"

module Renalware
  module Directory
    class PeopleController < BaseController
      include Pagy::Backend

      def index
        query = PersonQuery.new(q: params[:q])
        pagy, people = pagy(call_query(query))
        authorize people
        render locals: { q: query.search, people: people, pagy: pagy }
      end

      def search
        authorize Person, :index?

        query = PersonQuery.new(q: { name_cont: params.fetch(:term) })
        render json: CollectionPresenter.new(query.call, PersonAutoCompletePresenter).to_json
      end

      def show
        person = Person.find(params[:id])
        authorize person
        render locals: { person: person }
      end

      def new
        person = Person.build
        authorize person
        render_new(person)
      end

      def edit
        person = Person.find(params[:id])
        authorize person
        render_edit(person)
      end

      def create
        person = Person.new(person_params)
        authorize person

        if person.save
          redirect_to directory.people_path, notice: success_msg_for("Directory person")
        else
          flash.now[:error] = failed_msg_for("Directory person")
          render_new(person)
        end
      end

      def update
        person = Person.find(params[:id])
        authorize person
        if person.update(person_params)
          redirect_to directory.people_path, notice: success_msg_for("Directory person")
        else
          flash.now[:error] = failed_msg_for("Directory person")
          render_edit(person)
        end
      end

      private

      def render_edit(person)
        render :edit, locals: { person: person }
      end

      def render_new(person)
        render :new, locals: { person: person }
      end

      def call_query(query)
        query
          .call
          .with_address
      end

      def person_params
        params
          .require(:person)
          .permit(attributes)
          .merge(by: current_user)
      end

      def attributes
        [
          :given_name, :family_name, :title,
          address_attributes: address_attributes
        ]
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
