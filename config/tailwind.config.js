const defaultTheme = require("tailwindcss/defaultTheme")
const plugin = require("tailwindcss/plugin")

/*
  See here for some tint nhs colours
  https://github.com/NHS-digital-website/design-system/blob/main/src/nhsd/scss-core/tokens/_colours.scss
*/

/*
Specifying paths for css class purging
--------------------------------------
Include relevant paths in:
  - engine ./app
  - engine ./packs/app folder
  - current host app's ./app folder (${process.cwd() resolves to ./demo in this project but will
    resolve to ./app in eg the hospital rails project.

Note that this config file is used by each consuming hos app. Tailwind thee is run using
eg 'yarn build:css' which will invoke the tailwind binary like so:

  tailwindcss -c `bundle show renalware-core`/config/tailwind.config.js

*/

module.exports = {
  content: {
    relative: true,
    files: [
      "../**/app/helpers/**/*.rb",
      `${process.cwd()}../app/helpers/**/*.rb`,
      "../**/app/inputs/**/*.rb",
      `${process.cwd()}/app/inputs/**/*.rb`,
      "../**/app/views/**/*.{erb,haml,html,slim}",
      `${process.cwd()}/app/views/**/*.{erb,haml,html,slim}`,
      "../**/app/components/**/*.{erb,haml,html,slim,rb}",
      `${process.cwd()}/app/components/**/*.{erb,haml,html,slim,rb}`,
      "../**/app/presenters/**/*.rb",
      `${process.cwd()}/app/presenters/*.rb`,
      "../**/app/javascript/**/*",
      `${process.cwd()}/app/javascript/**/*`,
    ],
  },
  safelist: [
    {
      /*
      We need to whitelist these classes as are they are used dynamically from the database eg in
        pathology_observation_description.colour = 'lime' becomes 'bg-lime-100'
        pathology_code_group.subgroup_colours[] = ['lime'] becomes ['border-l-lime-300']
      The idea here is that we allow users to configure colours but we control their intensity
      by mapping them to tailwindcss classes.
      */
      pattern: /(bg|border-l)-(slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)-(100|300)/,
    },
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
      colors: {
        "nhs-blue": {
          light: "#41B6E6",
          DEFAULT: "var(--nhs-blue)",
          dark: "#003087",
          bright: "#0072CE",
          aqua: "#00A9CE",
        },
        "nhs-black": "#231f20",
        "nhs-grey": {
          dark: "#425563",
          DEFAULT: "#768692",
          mid: "#768692",
          pale: "#E8EDEE",
        },
        "nhs-green": {
          light: "#78BE20",
          DEFAULT: "#009639",
          dark: "#006747",
          aqua: "#00A499",
        },
        "nhs-pink": {
          DEFAULT: "#AE2573",
          dark: "#7C2855",
        },
        "nhs-yellow": {
          DEFAULT: "#FAE100",
          warm: "#FFB81C",
        },
        "nhs-orange": "#ED8B00",
        "nhs-red": {
          emergency: "#DA291C",
          dark: "#8A1538",
        },
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
    plugin(function ({ addVariant }) {
      // Usage: style elements which are down to an immediate right sibling of a checkbox or radio button
      // e.g. <input type='radio'/><label><div class="next-to-checked-down:border-red-500"></div></label>
      addVariant("next-to-checked-down", ":checked + * &")
    }),
  ],
}
