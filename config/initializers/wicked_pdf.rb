# WickedPDF Configuration
WickedPdf.config = {
  # Path to wkhtmltopdf executable (usually auto-detected)
  # exe_path: '/usr/local/bin/wkhtmltopdf',

  # Enable JavaScript (if needed for charts, etc.)
  enable_local_file_access: true,
  javascript_delay: 1000,

  # Default options for all PDFs
  orientation: 'Portrait',
  page_size: 'A4',
  margin: {
    top: 10,
    bottom: 10,
    left: 10,
    right: 10
  },

  # Footer with page numbers
  footer: {
    right: '[page] of [topage]',
    font_size: 8
  }
}

# Mime type registration for PDF format
Mime::Type.register "application/pdf", :pdf