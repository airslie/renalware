module Renalware
  module UKRDC
    module Incoming
      class FileList
        pattr_initialize [pattern: "survey*.xml", paths: Paths.new]

        # Helper which yields each file in the incoming folder.
        def each_file
          Dir.glob(paths.incoming.join(pattern)).each do |filepath|
            filename = File.basename(filepath)
            yield(Pathname(filepath), filename) if block_given?
          end
        end
      end
    end
  end
end
