module Renalware
  module Letters
    module Rendering
      # Use pandoc to convert the html letter to RTF
      # rubocop:disable Style/RedundantRegexpEscape
      class RTFRenderer
        pattr_initialize :letter
        REGEX_TO_STRIP_IMAGES = %r{(?m)<img\s*.*?"\s*\/>}
        REGEX_TO_STRIP_SVG = %r{(?m)<svg\s*.*?"\s*\/>}

        def call
          using_temp_html_file do |temp_file|
            rtf_content_converted_from(temp_file)
          end
        end

        def filename
          "#{letter.pdf_filename}.rtf"
        end

        def disposition
          "attachment; filename=\"#{filename}\""
        end

        private

        def using_temp_html_file
          temp_html_file = Tempfile.new("html_to_be_converted_to_rtf")
          temp_html_file << html_with_images_stripped
          temp_html_file.close

          yield(temp_html_file) if block_given?
        ensure
          temp_html_file.unlink # allows garbage collection and temp file removal
        end

        # Use windows line endings (CRLF) rather than linux (LF).
        # This solves a problem at Barts exporting RTFs to send to GPs
        def rtf_content_converted_from(html_temp_file)
          rtf_template = File.join(Engine.root, "lib", "pandoc", "templates", "default.rtf")
          options = { template: rtf_template }
          PandocRuby.html([html_temp_file.path], options, :standalone).to_rtf("--eol=crlf")
        end

        def html_with_images_stripped
          letter
            .to_html
            .gsub(REGEX_TO_STRIP_IMAGES, "")
            .gsub(REGEX_TO_STRIP_SVG, "")
        end
      end
    end
    # rubocop:enable Style/RedundantRegexpEscape
  end
end
