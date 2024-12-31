module Renalware
  module Virology
    class ProfileDocument < Document::Embedded
      attribute :hiv, YearDatedDiagnosis
      attribute :hepatitis_b, YearDatedDiagnosis
      attribute :hepatitis_b_core_antibody, YearDatedDiagnosis
      attribute :hepatitis_c, YearDatedDiagnosis
      attribute :htlv, YearDatedDiagnosis
    end
  end
end
