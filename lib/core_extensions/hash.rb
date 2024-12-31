# Recursively covert a nested hash into nested OpenStructs
# See https://coderwall.com/p/74rajw/convert-a-complex-nested-hash-to-an-object
module CoreExtensions
  module Hash
    module OpenStructConversion
      def to_o
        JSON.parse to_json, object_class: OpenStruct
      end
    end
  end
end
