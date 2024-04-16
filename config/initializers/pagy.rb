# frozen_string_literal: true

#
# See here for all options: https://github.com/ddnexus/pagy/blob/master/lib/config/pagy.rb
#

Pagy::DEFAULT[:items] = 25
Pagy::DEFAULT[:size] = [1, 4, 4, 1]

# Allow the client to request a custom number of items per page with an optional selector UI.
# It is useful with APIs or higly user-customizable apps.
# Useful for testing pagination from testing by supplying eg :items => 1
require "pagy/extras/items"
