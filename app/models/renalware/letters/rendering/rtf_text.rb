module Renalware
  module Letters
    module Rendering
      # RTF uses signed UTF-16 code units rather than UTF-8, including surrogate pairs.
      class RTFText
        pattr_initialize :node

        def self.escape(value)
          value.encode(Encoding::UTF_16LE).unpack("v*").map do |unit|
            case unit
            when 92, 123, 125 then "\\#{unit.chr}"
            when 0..127 then unit.chr
            else "\\u#{unit > 32_767 ? unit - 65_536 : unit}?"
            end
          end.join
        end

        def call
          value = node.text
          if node.ancestors.any? { |ancestor| ancestor.name == "pre" }
            self.class.escape(value).gsub(/\r\n|\r|\n/, "\\line\n").gsub("\t", '\tab ')
          else
            self.class.escape(value.gsub(/[\t\r\n ]+/, " "))
          end
        end
      end
    end
  end
end
