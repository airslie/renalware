# frozen_string_literal: true

module Renalware
  module ArticleHelper
    # Renders:
    # <article>
    #   <header>
    #     <h1>[title]</h1>
    #   </header>
    #   [yielded content]
    # </article>
    def article_tag(title = nil, options = nil, &)
      output = tag(:article, options, true)
      if title.present?
        output.safe_concat(
          tag.header do
            tag.h2(title)
          end
        )
      end
      output.concat(capture(&)) if block_given?
      output.safe_concat("</article>")
    end

    # Renders
    # <span>5 of 16<div>
    # if the collection has been paginated, otherwise
    # <span>5<div>
    def collection_count(collection)
      return unless collection.respond_to?(:length)

      parts = ["("]
      parts.append(collection.length)
      if collection.respond_to?(:total_count)
        if collection.total_count > collection.length
          parts.append(" of #{collection.total_count}")
        end
      end
      parts.append(")")
      tag.span(parts.join(""))
    end
  end
end
