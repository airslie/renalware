module Renalware
  module Problems
    class ProblemPresenter < SimpleDelegator
      # When the problem was added by a user, they may have specified a problem date by selecting
      # a year, a year+ month, or year+month+day. The style of date chosen (eg 'my' = month+ year)
      # will have been stored in problem#date_display_style (a PG enum).
      # Here we format the date they specified so that the visual representation matches what
      # they entered, i.e.:
      # - if they entered only a year, return e.g. '2011'
      # - if they entered a month and year return e.g. 'Feb-2011'
      # - if they entered day, month and year,  return e.g. '21-Feb-2011'
      def date
        return unless super

        format = case date_display_style
                 when "y" then "%Y"
                 when "my" then "%b-%Y"
                 else "%d-%b-%Y"
                 end

        I18n.l(super, format: format)
      end
    end
  end
end
