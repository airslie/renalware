# frozen_string_literal: true

require_dependency "renalware/letters"
require "attr_extras"

module Renalware
  module Letters
    # Use pandoc to convert the html letter to RTF
    class RTFRenderer
      pattr_initialize :letter
      REGEX_TO_STRIP_IMAGES = %r{(?m)<img\s*.*?"\s*\/>}.freeze

      def render
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

      def rtf_content_converted_from(html_temp_file)
        rtf_template = File.join(Engine.root, "lib", "pandoc", "templates", "default.rtf")
        options = { template: rtf_template }
        PandocRuby.html([html_temp_file.path], options, :standalone).to_rtf
      end

      def html_with_images_stripped
        letter.to_html.gsub(REGEX_TO_STRIP_IMAGES, "")
      end
    end
  end
end
