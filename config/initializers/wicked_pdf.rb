# WickedPDF Global Configuration
#
# Use this to set up shared configuration options for your entire application.
# Any of the configuration options shown here can also be applied to single
# models by passing arguments to the `render :pdf` call.
#
# To learn more, check out the README:
#
# https://github.com/mileszs/wicked_pdf/blob/master/README.md

WickedPdf.configure {
  # Path to the wkhtmltopdf executable: This usually isn't needed if using
  # one of the wkhtmltopdf-binary family of gems.
  # exe_path: '/usr/local/bin/wkhtmltopdf',
  #   or
  # exe_path: Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf')
  # Layout file to be used for all PDFs
  # (but can be overridden in `render :pdf` calls)
  # layout: 'pdf.html',
}

# This is a hack to get ViewComponent and WickedPDF to work together.
# See https://github.com/github/view_component/issues/288
# Basically in Rails 5.x, both gems monkey patch ActionView render_to_string
# and we can get an infinite loop when rendering PDFs.
# Once we move to Rails 6 I think think this can be removed
# class WickedPdf
#   module PdfHelper
#     remove_method(:render_to_string)
#     remove_method(:render)
#   end
# end
