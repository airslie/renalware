module Renalware
  module Feeds
    module Files
      describe CreateFeedFile do
        describe "#call" do
          it "saves an uploaded practices zip file to a Feeds::File" do
            path_to_zipfile = Pathname.new(
              Renalware::Engine.root.join("spec", "fixtures", "files", "simple.zip")
            )
            file_type = create(:feed_file_type, :primary_care_physicians)
            user = create(:user)
            file = nil

            expect {
              file = described_class.call(
                file_type: file_type,
                uploaded_file: path_to_zipfile,
                user: user
              )
            }.to change(Feeds::File, :count).by(1)

            expect(file.file_type).to eq(file_type)
            expect(file.created_by_id).to eq(user.id)

            file = Feeds::File.find_by!(
              file_type_id: file_type.id,
              created_by_id: user.id,
              updated_by_id: user.id
            )

            # Will have saved away out file but in a new location, and the filename will have
            # been changed but still contain out original base name e.g. sample.zip
            expect(file.location).to match(/#{path_to_zipfile.basename}/)
          end
        end
      end
    end
  end
end
