# Cache PDF Letters so we are not constantly regenerating the same ones - wkhtml2pdf takes around
# 2.5 seconds and a fair chunk of memory to convert html to pdf, so we want to cache generated PDFs
# for a period of time.
#
# Note that the cache in question here is not intended to be a canonical archive of PDFs for
# future reference; it is up to the host application to move the PDFs into EPR folders etc
# for archiving. This cache could be cleared at any time.
#
# Note that even when checking to see if the PDF exists in the cache, we *always* regenerate at
# least the HTML letter content (i.e. the letter content wrapped in a layout) as we want to make
# sure we are picking up any view and layout changes (fragment caching could possibly be levered
# here as it knows the MD5 of the views and layouts used, and thus might help us to avoid having
# to re-render the letter HTML each time - but I have started by taking the less `magical` route
# of rendering the entire HTML letter to get its MD5 hash, which is then used in trying to find a
# PDF file cache hit for that filename).
#
# Note that PDF Letters are stored in the rails cache, which is currently Filestore. If we move
# to a multi-server environment we would need to switch to Memcached or Redis, and the PDF files
# would be poked into that - using quite a lot of memory I am sure (avg 25k per PDF), so would be
# unable to keep PDFs in the cache for as long as we can in the FileStore implementation, which is
# only limited by disc space. However PDFs can be regenerated on demand so there is no need to be
# bothered about not keeping them other than as mentioned the wasted resources in creating the
# same file several times.
#
# Example usage which stores the PDF in the rails cache if not found
#
#   PdfLetterCache.fetch(..) do
#     # No cache hit so render and return the PDF content which will be stored in the cache
#     WickedPdf.new.pdf_from_string(...)
#   end
#

module Renalware
  module Letters
    class PdfLetterCache
      class << self
        delegate :clear, :cleanup, to: :store

        def fetch(letter, **, &)
          store.fetch(
            cache_key_for(letter),
            version: cache_version_for(letter, **),
            expires_in: 4.weeks,
            &
          )
        end

        private

        def store
          @store ||= begin
            if ActiveSupport::Cache.const_defined?(:DatabaseStore)
              ActiveSupport::Cache::DatabaseStore.new namespace: "letter_pdf"
            else
              ActiveSupport::Cache::FileStore.new(file_store_cache_path)
            end
          end
        end

        def file_store_cache_path
          Rails.root.join("tmp/pdf_letter_cache")
        end

        # Note the letter must be a LetterPresenter which has a #to_html method
        # The to_html method should (and does on the LetterPresenter class) render the complete
        # html including surrounding layout with inline css and images. This way if the
        # layout changes or the image is changed for example, the cache for the pdf is no longer
        # valid and a new key and cache entry will be created.
        def cache_key_for(letter)
          [
            "patient",
            letter.patient.id,
            "letter",
            letter.id,
            "pdf"
          ].join("-")
        end

        def cache_version_for(letter, **)
          [
            letter&.updated_at&.strftime("%Y%m%d%H%M%S"),
            Digest::MD5.hexdigest(letter.to_html(**))
          ].join("-")
        end
      end
    end
  end
end
