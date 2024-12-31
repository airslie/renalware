module Renalware
  module Patients
    class WorryPresenter
      pattr_initialize :worry

      # If worry is present will return eg
      # "Yes (category name) notes and everything truncated to 30 chara..."
      def summary(truncate_at: 30)
        if worry.present?
          [
            "Yes",
            category_name,
            worry.notes
          ].compact.join(" ").truncate(truncate_at)
        else
          "No"
        end
      end

      private

      def category_name
        return if worry.worry_category.nil?

        "(#{worry.worry_category})"
      end
    end
  end
end
