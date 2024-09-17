# frozen_string_literal: true

#
# See here for all options: https://github.com/ddnexus/pagy/blob/master/lib/config/pagy.rb
#

# Allow easy handling of overflowing pages (i.e. requested page > count).
# It internally rescues Pagy::OverflowError exceptions offering the following ready to use
# behaviors/modes: :empty_page, :last_page, and :exception.
require "pagy/extras/overflow"

Pagy::DEFAULT[:items] = 25
Pagy::DEFAULT[:size] = 8
Pagy::DEFAULT[:overflow] = :last_page
