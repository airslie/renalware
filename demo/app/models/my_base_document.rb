# We define an Document::Embedded subclass so we can re-include Virtus model
# and ensure nullify_blank: true
class MyBaseDocument < Document::Embedded
  include Virtus.model(nullify_blank: true)

  class << self
    def numeric_attribute_names
      attribute_set.select { |x| [Integer, Float].include?(x.primitive) }.map(&:name)
    end

    def string_attribute_names
      attribute_set.select { |x| x.primitive == String }.map(&:name)
    end
  end
end
