module Relay
  module GPConnect
    # Raised when asked to build a message for a document that has no PDF content (yet).
    class MissingPdfContentError < StandardError; end
  end
end
