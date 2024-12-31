module Renalware
  module Drugs
    module DMD::APISynchronisers
      class FormSynchroniser
        def initialize(form_repository: DMD::Repositories::FormRepository.new)
          @form_repository = form_repository
        end
        attr_reader :form_repository

        def call
          entries = form_repository.call

          return if entries.empty?

          now = Time.current
          upserts = entries.map do |entry|
            {
              code: entry.code,
              name: entry.name,
              updated_at: now
            }
          end

          Form.upsert_all(upserts, unique_by: :code)
        end
      end
    end
  end
end
