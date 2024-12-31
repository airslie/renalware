module Renalware
  # rubocop:disable Style/AsciiComments
  # Prawn uses the Windows-1252 character set so that it can be compatible with the limited fonts
  # built into PDF viewers. This has the advantage that PDF file sizes are very small (5-6KB as
  # opposed to 40KB+ if adding a custom TTF font to allow wider glyph support).
  # Prawn converts the content to UTF-8 before rendering, and characters, outside
  # of the Windows-1252 set will generally be represented as e.g. â™£. However, some characters,
  # especially glyphs (e.g. the empty checkbox \x90) will raise:
  #   Encoding::UndefinedConversionError ("\x90" to UTF-8 in conversion from
  #   Windows-1252 to UTF-8)
  # We trap these and set a (hopefully-useful) validation message, asking the user to find and
  # remove them. Hopefully this will not happen very often, though a copy and paste from Word is the
  # most likely. If it happens a lot and irritates users, we could attempt to replace the most
  # common offending chars.
  # It is important we trap these errors early, with the user present, as once the event is created,
  # the async generation of PDFs prevents changing the content.
  # rubocop:enable Style/AsciiComments
  class PdfFriendlyValidator < ActiveModel::EachValidator
    PRAWN_PDF_ENCODING = "Windows-1252".freeze

    def validate_each(record, attribute, value)
      value.to_s.dup.force_encoding(PRAWN_PDF_ENCODING).encode("utf-8")
    rescue Encoding::UndefinedConversionError
      record.errors.add(
        attribute,
        "contains unusual characters (e.g. checkboxes, special quotes) which may " \
        "stop us from using this content in a PDF. These characters can appear if copying and " \
        "pasting from Word for example."
      )
    end
  end
end
