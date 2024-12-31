module Renalware
  module HD
    # Backed by a Postgres view which defines all the possible permutations of
    # filter that can be selected in a schedule definition filter dropdown, for example
    #  days: "Mon Wed Fri", ids: [1,3,4]
    #  days: "Mon Wed Fri PM", ids: [3]
    # See also HD::MDMPatientsForm and db/views/hd_schedule_definition_filters_*.sql
    class ScheduleDefinitionFilter < ApplicationRecord
    end
  end
end
