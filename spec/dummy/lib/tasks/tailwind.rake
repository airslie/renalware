# frozen_string_literal: true

# On asset precompilation the tailwindcss purges unused classes so it only outputs a css file with
# the utility classes we have actually used in the app. You can set the paths to search
# in config/tailwind.config.js. However we need to tell the tailwindcss executable to
# include in the purge any view files etc in downstream rails engines. We can't inject the
# path to these folders in the usual config/tailwind.config.js very easily, so here
# we take the approach (based on https://github.com/rails/tailwindcss-rails/issues/108)
# of re-writing the config/tailwind.config.js file using ruby so we can resolve the
# correct path to the the engine's root, and so include the correct physical paths in the
# js file. This way tailwindcss will search these paths for css classes when purging unused
# classes.

# Used by dumy app only

namespace :tailwind do
  desc "Generate a component-aware config/tailwind.config.js file"
  task :generate_config do
    roots = [
      Renalware::Engine.root,
      "."
    ]
    paths = roots.map do |root|
      [
        "'#{root}/app/helpers/**/*.rb'",
        "'#{root}/app/inputs/**/*.rb'",
        "'#{root}/app/views/**/*.{erb,haml,html,slim}'",
        "'#{root}/app/components/**/*.{erb,haml,html,slim,rb}'",
        "'#{root}/app/assets/javascripts/**/*'",
        "'#{root}/app/javascript/**/*'"
      ]
    end.flatten

    Rails.root.join("config/tailwind.config.js").write(<<~JS)
      const defaultTheme = require('tailwindcss/defaultTheme')
      const plugin = require('tailwindcss/plugin')

      /*
      See here for some tint nhs colours
      https://github.com/NHS-digital-website/design-system/blob/main/src/nhsd/scss-core/tokens/_colours.scss
      */
      module.exports = {
        content: [
          #{paths.join(",\n    ")},
        ],
        theme: {
          extend: {
            fontFamily: {
              sans: ['Inter var', ...defaultTheme.fontFamily.sans],
            },
            colors: {
              'nhs-blue': {
                light: '#41B6E6',
                DEFAULT: '#005EB8',
                dark: '#003087',
                bright: '#0072CE',
                aqua: '#00A9CE',
              },
              'nhs-black': '#231f20',
              'nhs-grey': {
                dark: '#425563',
                DEFAULT: '#768692',
                mid: '#768692',
                pale: '#E8EDEE'
              },
              'nhs-green': {
                light: '#78BE20',
                DEFAULT: '#009639',
                dark: '#006747',
                aqua: '#00A499'
              },
              'nhs-pink': {
                DEFAULT: '#AE2573',
                dark: '#7C2855'
              },
              'nhs-yellow': {
                DEFAULT: '#FAE100',
                warm: '#FFB81C'
              },
              'nhs-orange': '#ED8B00',
              'nhs-red': {
                emergency: '#DA291C',
                dark: '#8A1538'
              },
            },
          },
        },
        plugins: [
          require('@tailwindcss/forms'),
          require('@tailwindcss/aspect-ratio'),
          require('@tailwindcss/typography'),
          plugin(function({ addVariant }) {
            // Usage: style elements which are down to an immediate right sibling of a checkbox or radio button
            // e.g. <input type='radio'/><label><div class="next-to-checked-down:border-red-500"></div></label>
            addVariant('next-to-checked-down', ':checked + * &')
          })
        ]
      }
    JS
  end
end

# fontSize: {
#   'sm': '.75rem',
#   'base': '.875rem',
#   'lg': '1rem',
#   'xl': '1.125rem',
#   '2xl': '1.25rem',
#   '3xl': '1.5rem',
#   '4xl': '1.875rem',
#   '5xl': '2.25rem',
#   '6xl': '3rem'
# },

# This enhance only works when using `yarn build:css` as it runs in the scope of the dummy app.
# It does however syntactically match the host site rails app tailwind.rake file
# Note that for watching for css changes, if were not using `yarn build:css` but
# rather `rake app:tailwindcss:watch`` then we would need to add
#   Rake::Task["app:tailwindcss:watch"].enhance(["app:tailwind:generate_config"])
Rake::Task["tailwindcss:build"].enhance(["app:tailwind:generate_config"])
