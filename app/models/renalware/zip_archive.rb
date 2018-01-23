require_dependency "renalware"

module Renalware
  class ZipArchive
    def initialize(file)
      @file = Pathname.new(file)
    end

    def unzip
      Dir.mktmpdir do |dir|
        files = unzip_to_tmp_dir_and_return_pathames_array(dir)
        yield(files)
      end
    end

    def rar_archive?
      `file #{file}`.match? /RAR/
    end

    private

    attr_reader :file

    # Zip arguments
    # -o = overwrite if files already there (to avoid unattended)
    # -j = junk (throw away) the path structure in the zip file - this has the risk that
    #      files in separate folders but with the same name could overwrite each other..
    # Unrar aguments
    #  - e extract files
    #  - o+ overwrite existing
    def unzip_to_tmp_dir_and_return_pathames_array(dir)
      zip_realpath = file.realpath
      Dir.chdir(dir) do
        if rar_archive?
          execute("unrar e -o+ #{zip_realpath}")
        else
          execute("unzip -o -j #{zip_realpath}")
        end
      end
      Pathname.new(dir).children
    end

    def execute(cmd)
      success = system(cmd)
      raise("Command '#{cmd}' returned #{$CHILD_STATUS.exitstatus}") unless success
    end
  end
end