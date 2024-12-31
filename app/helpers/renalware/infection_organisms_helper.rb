module Renalware
  module InfectionOrganismsHelper
    def pd_infection_organisms_path(infectable)
      super(infectable_type: infectable.class.to_s, infectable_id: infectable.id)
    end

    def new_pd_infection_organism_path(infectable)
      super(infectable_type: infectable.class.to_s, infectable_id: infectable.id)
    end
  end
end
