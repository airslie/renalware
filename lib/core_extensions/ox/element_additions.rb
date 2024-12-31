module CoreExtensions
  module Ox
    module ElementAdditions
      # We override << so that we can handle the case where we try and add a null
      # node child - in which case, rather than allowing Oc to raise an error, we silently
      # return self
      def <<(node)
        return self unless node

        super
      end
    end
  end
end

Ox::Element.prepend(CoreExtensions::Ox::ElementAdditions)
