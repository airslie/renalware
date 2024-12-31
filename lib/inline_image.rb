require "base64"

class InlineImage
  def initialize(file_path)
    @filename = File.join(Renalware::Engine.root, file_path)
    @data = File.read(@filename)
  end

  def src
    "data:#{mime_type};base64,#{to_base64}"
  end

  def to_base64
    Base64.encode64(@data)
  end

  def mime_type
    MIME::Types.type_for(@filename).first.to_s
  end
end
