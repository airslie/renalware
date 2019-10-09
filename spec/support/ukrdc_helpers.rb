# frozen_string_literal: true

module UKRDCSpecHelper
  def remove_all_test_files
    FileUtils.rm_r Dir.glob(paths.incoming.join("*.xml"))
  end

  def copy_test_files_into_incoming_folder(paths:, num: 1, filename: "example.xml")
    remove_all_test_files
    source = file_fixture("ukrdc/incoming/#{filename}")
    num.to_i.times do |idx|
      destination = paths.incoming.join("#{idx}.xml")
      FileUtils.cp(source, destination)
    end
  end
end
