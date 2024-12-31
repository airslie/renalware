module Renalware
  module Drugs::DMD
    module APISynchronisers
      class AtcCodeSynchroniser
        def initialize(atc_vmp_mapping_repository: Repositories::AtcVMPMappingRepository.new)
          @atc_vmp_mapping_repository = atc_vmp_mapping_repository
        end
        attr_reader :atc_vmp_mapping_repository

        def call
          now = Time.current

          atc_vmp_mapping_repository.call.each do |mapping|
            VirtualMedicalProduct.where(code: mapping.vmp_code)
              .update_all(atc_code: mapping.atc_code, updated_at: now)
          end
        end
      end
    end
  end
end
