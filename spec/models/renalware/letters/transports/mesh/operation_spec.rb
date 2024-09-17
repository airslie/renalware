# frozen_string_literal: true

module Renalware::Letters::Transports::Mesh
  describe Operation do
    # it { is_expected.to validate_presence_of(:transmission) }
    it { is_expected.to validate_presence_of(:direction) }
    it { is_expected.to validate_presence_of(:action) }
    it { is_expected.to belong_to(:transmission) }
    it { is_expected.to have_db_index(:transmission_id) }
    it { is_expected.to have_db_index(:direction) }
    it { is_expected.to have_db_index(:action) }
  end
end
