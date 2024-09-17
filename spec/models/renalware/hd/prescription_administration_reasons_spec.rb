# frozen_string_literal: true

module Renalware
  module HD
    describe PrescriptionAdministrationReason do
      it { is_expected.to have_db_index(:name).unique(true) }
    end
  end
end
