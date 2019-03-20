# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Patients
    module Ingestion
      describe Command do
        describe ".for" do
          it "delegates to CommandFactory#for" do
            message = double(
              :message,
              type: :update_person_information,
              has_assigned_location?: false
            )

            expect_any_instance_of(CommandFactory).to receive(:for).with(message)
            Command.for(message)
          end
        end
      end
    end
  end
end
