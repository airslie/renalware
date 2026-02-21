# frozen_string_literal: true

module Forms
end

Rails.autoloaders.main.push_dir(ENGINE.join("app/pdfs/forms"), namespace: Forms)
