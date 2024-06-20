# frozen_string_literal: true

#
# See here for all options: https://github.com/ddnexus/pagy/blob/master/lib/config/pagy.rb
#

# Allow easy handling of overflowing pages (i.e. requested page > count).
# It internally rescues Pagy::OverflowError exceptions offering the following ready to use
# behaviors/modes: :empty_page, :last_page, and :exception.
require "pagy/extras/overflow"

# Allow the client to request a custom number of items per page with an optional selector UI.
# It is useful with APIs or highly user-customizable apps.
# Useful for testing pagination from testing by supplying eg :items => 1
require "pagy/extras/items"

Pagy::DEFAULT[:items] = 25
Pagy::DEFAULT[:size] = [1, 4, 4, 1]
Pagy::DEFAULT[:overflow] = :last_page
