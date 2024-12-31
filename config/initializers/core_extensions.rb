require "core_extensions/i18n/handle_blank_value"
require "core_extensions/dumb_delegator"
require "core_extensions/date"
require "core_extensions/active_support/duration_additions"
require "core_extensions/resolve_scenic_views_in_engine_only"
require "core_extensions/hash"
require "core_extensions/active_record/migration_helpers"
require "core_extensions/ox/element_additions"
require "core_extensions/hl7/message_additions"

I18n.extend CoreExtensions::I18n::HandleBlankValue
Date.include(CoreExtensions::Date::Constants)
Hash.include(CoreExtensions::Hash::OpenStructConversion)
