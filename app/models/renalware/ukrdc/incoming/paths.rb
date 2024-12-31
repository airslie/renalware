module Renalware
  module UKRDC
    module Incoming
      class Paths
        def incoming
          @incoming ||= begin
            working_path.join("incoming").tap { |path| FileUtils.mkdir_p(path) }
          end
        end

        def archive
          @archive ||= begin
            working_path.join("archive", "incoming").tap { |path| FileUtils.mkdir_p(path) }
          end
        end

        private

        def working_path
          Pathname(Renalware.config.ukrdc_working_path)
        end
      end
    end
  end
end
