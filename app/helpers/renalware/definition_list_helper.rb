# frozen_string_literal: true

module Renalware
  module DefinitionListHelper
    class DefinitionList
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::TextHelper
      include ActionView::Context
      pattr_initialize :model
      delegate_missing_to :model

      def definition(attribute, label = nil)
        text = label || model.class.human_attribute_name(attribute)
        value = model.public_send(attribute)
        value = yield(value) if value.present? && block_given?
        capture do
          concat tag.dt(text)
          concat tag.dd(value)
        end
      end
    end

    def definition_list_for(model, size: :large)
      tag.dl(class: "dl-horizontal #{size}") do
        yield DefinitionList.new(model)
      end
    end
  end
end
