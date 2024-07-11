# frozen_string_literal: true

require "base64"

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        module V3
          class Document < Rendering::Base
            pattr_initialize [:letter!]

            def xml
              document_element
            end

            private

            def document_element # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
              create_node("Document") do |elem|
                elem << create_node("DocumentTime", letter.datetime.iso8601)
                elem << Clinician.new(user: letter.author).xml
                elem << create_node("DocumentName", letter.title)
                elem << create_node("Status") do |status|
                  status << create_node("Code", "ACTIVE")
                end
                elem << EnteredBy.new(user: letter.updated_by).xml
                if letter.hospital_unit_renal_registry_code.present?
                  elem << create_node("EnteredAt") do |entered_at|
                    entered_at << create_node("CodingStandard", "LOCAL")
                    entered_at << create_node("Code", letter.hospital_unit_renal_registry_code)
                  end
                end
                elem << create_node("FileType", "application/pdf")
                elem << create_node("FileName", letter.pdf_stateless_filename)
                elem << create_node("Stream", encoded_document_content)
              end
            end

            def encoded_document_content
              renderer = Letters::RendererFactory.renderer_for(letter, :pdf)
              Base64.encode64(renderer.call)
            end
          end
        end
      end
    end
  end
end
