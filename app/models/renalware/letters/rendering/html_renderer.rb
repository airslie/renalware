module Renalware
  module Letters
    module Rendering
      # Note we cannot use a partial layout with render_to_string as it will always expect
      # the location to be in views/layouts and its not possible in Rails 5.1 to specify
      # another or absolute path
      class HtmlRenderer
        include Callable
        pattr_initialize :letter

        def call
          LettersController.new.render_to_string(
            partial: "/renalware/letters/formatted_letters/letter",
            locals: { letter: letter },
            encoding: "UTF-8"
          )
        end
      end
    end
  end
end
