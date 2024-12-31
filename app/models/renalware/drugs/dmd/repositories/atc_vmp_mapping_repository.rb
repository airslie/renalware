module Renalware
  module Drugs::DMD
    module Repositories
      require "open-uri"
      require "faraday"

      # Obtains an XML file which contains VMP to ATC code mappings.
      #
      # ## How to use
      # Run `AtcCodeSynchroniser.new.call` to fetch the XML file and persist
      # the ATC codes next to each VMP.
      #
      class AtcVMPMappingRepository
        attr_reader :xml_path

        API_KEY = Renalware.config.nhs_trud_api_key
        API_ENDPOINT =
          "https://isd.digital.nhs.uk/trud/api/v1/keys/#{API_KEY}/items/25/releases".freeze

        Entry = Struct.new(:atc_code, :vmp_code,
                           keyword_init: true)

        class NHSTrudApiFetchReleaseListError < StandardError; end
        class NHSTrudApiFetchLatestReleaseError < StandardError; end

        def call
          zip_file = download_zip(url_of_latest_release)

          xml_file = extract_xml(zip_file.path)
          zip_file.unlink

          file_contents = File.read(xml_file)
          xml_file.unlink

          doc = Nokogiri::XML(file_contents)

          doc.remove_namespaces!
          doc.css("VMP").filter_map do |thing|
            atc_node = thing.at_css("ATC")
            vmp_node = thing.at_css("VPID")

            next if atc_node.nil? || vmp_node.nil?

            Entry.new(
              atc_code: atc_node.content,
              vmp_code: vmp_node.content
            )
          end
        end

        # Example xml row
        # <VMP>
        #   <VPID>41329711000001103</VPID>
        #   <BNF>03040200</BNF>
        #   <ATC>R03DX11</ATC>
        # </VMP>

        private

        # To avoid manually changing the version url
        # we use an api to get the latest version of the file. The API url is:
        # https://isd.digital.nhs.uk/trud/api/v1/keys/API_KEY/items/25/releases
        # where 25 is the item number for NHSBSA Supplementary and
        # API_KEY is the API key from this page
        # https://isd.digital.nhs.uk/trud/users/authenticated/filters/0/account/manage
        #
        # @see https://isd.digital.nhs.uk/trud/users/authenticated/filters/0/api
        #
        # The API endpoint returns a json array of releases.
        # The latest release is at index 0 in the array of returned releases e.g.
        # {
        #   "apiVersion" => "1",
        #   "releases" => [
        #     { "id" => "nhsbsa_dmdbonus_9.3.0_20230925000001.zip",
        #        "name" => "Release 9.3.0",
        #        "releaseDate" => "2023-09-25",
        #        "archiveFileUrl" => "https://isd.digital.nhs.uk/download/api/v1/key...",
        #        ...
        #     },
        #     ...
        #   ]
        # }
        def url_of_latest_release
          response = Faraday.get(API_ENDPOINT)
          raise(NHSTrudApiFetchReleaseListError, response.status) unless response.status

          archive_file_url = JSON.parse(response.body)["releases"]&.first&.dig("archiveFileUrl")
          if archive_file_url.blank?
            raise(
              NHSTrudApiFetchLatestReleaseError,
              "Could not resolve JSON path ['releases'][0]['archiveFileUrl'] in #{API_ENDPOINT}"
            )
          end

          archive_file_url
        end

        def download_zip(zip_url)
          tempfile = Tempfile.new(["nhs_atc_code_mappings", ".zip"])

          case io = ::OpenURI.open_uri(zip_url)
          when StringIO then File.write(tempfile.path, io.read)
          when Tempfile then io.close
                             FileUtils.mv(io.path, tempfile.path)
          end

          tempfile
        end

        def extract_xml(location)
          xml_file = Tempfile.new(["nhs_atc_code_mappings", ".xml"])

          ZipArchive.new(location).unzip do |zip_files|
            zip_files.each do |file|
              next if file.basename.to_s.starts_with?(".")
              next unless file.extname == ".zip"

              # There should be just a single inner .zip file
              ZipArchive.new(file.to_s).unzip do |inner_zip_files|
                inner_zip_files.each do |inner_file|
                  next if inner_file.basename.to_s.starts_with?(".")
                  next unless inner_file.extname == ".xml"

                  # There should be just a single .xml file
                  FileUtils.cp(inner_file, xml_file)
                end
              end
            end
          end

          xml_file
        end
      end
    end
  end
end
