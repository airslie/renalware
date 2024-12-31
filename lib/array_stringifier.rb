# Responsible for decorating a collection which responds to `to_a` which will
# stringify all of the elements.
#
# Example
#
#     ArrayStringifier.new({a: 1, b: 2}).to_a # => [["a", "1"], ["b", "2"]]
#
class ArrayStringifier < SimpleDelegator
  alias collection __getobj__

  def to_a
    stringify_items(collection.to_a)
  end

  private

  def stringify_items(collection)
    collection.map do |item|
      if item.respond_to?(:map)
        stringify_items(item)
      else
        item.to_s
      end
    end
  end
end
