module Renalware
  # Renders article markup with optional title and action links/buttons.
  # We use <article> extensively so this is a useful component that lets us
  # style them consistently and reuse them.
  class ArticleComponent < ApplicationComponent
    rattr_initialize [classes!: nil]

    renders_one :title # block returning a string or link_to(..)
    renders_many :actions # blocks returning a link_to or button_to etc
  end
end
