require "active_support/concern"

module Renalware
  module PdfCompilation
    extend ActiveSupport::Concern

    def combine_multiple_pdfs_into_file(filepath:, glob:)
      filepath = Pathname(filepath)
      Rails.logger.info " Compiling PDFs #{glob.join(',')} into #{filepath}"
      shell_to_ghostscript_to_combine_files(glob, dir, filepath)
      filepath
    end

    def combine_multiple_pdfs_using_filenames(filenames, dir, output_filepath)
      filenames = Array(filenames)
      Rails.logger.info " Compiling PDFs #{filenames.join(',')} into #{output_filepath}"
      using_a_temporary_output_file do |tmp_outfile|
        shell_to_ghostscript_to_combine_files(filenames, dir, tmp_outfile)
        move_tempfile_to_output_file(tmp_outfile, output_filepath)
      end
    end

    def shell_to_ghostscript_to_combine_files(filenames, dir, outputfile)
      outputfile = Pathname(outputfile)
      cmd = "gs -dNOPAUSE " \
            "-sDEVICE=pdfwrite " \
            "-sOUTPUTFILE=#{outputfile} " \
            "-dBATCH #{filenames.join(' ')}"
      err = msg = nil
      Open3.popen3(cmd, chdir: dir.to_s) do |_stdin, stdout, stderr|
        err = stderr.read
        msg = stdout.read
      end
      if err.present?
        raise "Error combining PDFs: #{[err, msg].join(' ')} command: #{cmd}"
      end
    end

    def move_tempfile_to_output_file(tmp_outfile, output_file)
      FileUtils.mv tmp_outfile.path, output_file
      output_file
    end

    def rails_tmp_folder
      Rails.root.join("tmp").to_s
    end

    # Create a tempfile outside the temp dir as dir will be destroyed when outside block closes.
    def using_a_temporary_output_file
      file = Tempfile.new("pdf_combined", rails_tmp_folder)
      begin
        yield file
      ensure
        file.close
        file.unlink # deletes the temp file
      end
    end
  end
end
