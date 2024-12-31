module Renalware
  module Letters
    module Mailshots
      describe Mailshot do
        it :aggregate_failures do
          is_expected.to validate_presence_of(:description)
          is_expected.to validate_presence_of(:author)
          is_expected.to validate_presence_of(:letterhead)
          is_expected.to validate_presence_of(:body)
          is_expected.to validate_presence_of(:sql_view_name)
        end
      end
    end
  end
end
