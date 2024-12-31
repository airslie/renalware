module Renalware
  module Patients
    class WorryCategoriesController < BaseController
      def index
        categories = WorryCategory.with_deleted.order(:name).includes(:updated_by)
        authorize categories
        render locals: { categories: categories }
      end

      def new
        category = WorryCategory.new
        authorize category
        render_new(category)
      end

      def edit
        render_edit(find_and_authorise_category)
      end

      def create
        category = WorryCategory.new(category_params)
        authorize category
        if category.save_by(current_user)
          redirect_to worry_categories_path
        else
          render_new(category)
        end
      end

      def update
        category = find_and_authorise_category
        if category.update_by(current_user, category_params)
          redirect_to worry_categories_path
        else
          render_edit(category)
        end
      end

      def destroy
        find_and_authorise_category.destroy
        redirect_to worry_categories_path
      end

      private

      def find_and_authorise_category
        WorryCategory.find(params[:id]).tap { |category| authorize(category) }
      end

      def render_edit(category)
        render :edit, locals: { category: category }
      end

      def render_new(category)
        render :new, locals: { category: category }
      end

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
