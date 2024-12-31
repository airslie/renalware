# A decorator for handling a collection of hashes with similar keys.
#
class HashCollection < SimpleDelegator
  alias collection __getobj__

  # Example:
  #
  #   foo = [
  #     {a: 1, b: 2},
  #     {b: 3, c: 4}
  #   ]
  #
  #   bar = HashCollection.new(foo)
  #   bar.to_a => [[:a, 1, nil], [:b, 2, 3], [:c, nil, 4]]
  #
  def to_a
    keys = find_unique_keys
    build_items(keys)
  end

  private

  def find_unique_keys
    collection.flat_map(&:keys).uniq
  end

  def build_items(keys)
    keys.each_with_object([]) do |key, memo|
      memo << build_item_for_key(key)
    end
  end

  def build_item_for_key(key)
    [key] + find_values(key)
  end

  def find_values(key)
    collection.map { |result| result.fetch(key) }
  end
end
