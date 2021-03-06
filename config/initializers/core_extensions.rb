# frozen_string_literal: true

require "core_extensions/i18n/handle_blank_value"
require "core_extensions/i18n/always_cascade"
require "core_extensions/dumb_delegator"
# require "core_extensions/active_record/sort"
require "core_extensions/date"
require "core_extensions/active_support/duration_additions"
require "core_extensions/scenic"
require "core_extensions/hash"
require "core_extensions/active_record/migration_helpers"
require "core_extensions/ox/element_additions"

I18n.extend CoreExtensions::I18n::HandleBlankValue
I18n::Backend::Simple.include(I18n::Backend::Cascade)
I18n.extend CoreExtensions::I18n::AlwaysCascade
# ActiveRecord::Base.include(CoreExtensions::ActiveRecord::Sort)
Date.include(CoreExtensions::Date::Constants)
Hash.include(CoreExtensions::Hash::OpenStructConversion)
