# frozen_string_literal: true

module Forms
end

Rails.autoloaders.main.push_dir(Rails.root.join("app/pdfs/forms"), namespace: Forms)
