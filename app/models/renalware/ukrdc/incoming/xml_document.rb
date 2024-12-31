module Renalware
  module UKRDC
    module Incoming
      # Encapsulates the structure of the UKRDC XML Document.
      # Assumes one patient per file.
      class XmlDocument
        XPATHS = {
          dob: "string(Patient[1]/BirthTime)",
          family_name: "string(Patient[1]/Names[1]/Name/Family)",
          nhs_number: <<-XPATH.squish
            string(
              Patient[1]/
                PatientNumbers/
                  PatientNumber[Organization[text()='NHS']][NumberType[text()='MRN']][1]/
                    Number
            )
          XPATH
        }.freeze

        attr_reader :root

        def initialize(file)
          xml_document = File.open(file) { |f| Nokogiri::XML(f) }
          @root = xml_document.root
        end

        # Accessing eg XmlDocument.new(file).nhs_number will search the document with looked-up
        # entry in the XPATHS constant, to save us having to write attributes for the things we
        # need.
        def method_missing(method_name, *_args, &)
          xpath = XPATHS[method_name]
          return root.xpath(xpath) if xpath

          super
        end

        def respond_to_missing?(method_name, *_args)
          XPATHS.key?(method_name)
        end

        # Turn the surveys XML into a hash because it is easier to consume
        def surveys
          root.xpath("Surveys/Survey").each_with_object([]) do |survey_node, arr|
            hash = {}
            hash[:code] = survey_node.xpath("string(SurveyType/Code)")
            hash[:time] = survey_node.xpath("string(SurveyTime)")
            hash[:responses] = question_hash_from(survey_node)
            arr << hash
          end
        end

        # Note that if a response has a QuestionText this can be some text the user entered
        # (presumably so they can then assign it a response value) so we need to store the
        # question text (e.g. Paranoia) as well as the response (eg 4).
        # If we find a QuestionText we store an array containing it and the response in the hash
        # otherwise we just add the response.
        def question_hash_from(survey_node)
          question_nodes = survey_node.xpath("Questions/Question")
          question_nodes.each_with_object({}) do |question_node, responses|
            code = question_node.xpath("string(QuestionType/Code)")
            response = question_node.xpath("string(Response)")
            question_text = question_node.xpath("string(QuestionText)")
            responses[code] = if question_text.present?
                                [response, question_text]
                              else
                                response
                              end
          end
        end
      end
    end
  end
end
