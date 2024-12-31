module Renalware
  class LeftRightConfirmation < NestedAttribute
    attribute :left, Document::Enum, enums: %i(yes no)
    attribute :right, Document::Enum, enums: %i(yes no)
  end
end
