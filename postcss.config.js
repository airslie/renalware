
let environment = {
  plugins: [
    require("tailwindcss"),
    require("autoprefixer"),
    require("postcss-import"),
    require("postcss-flexbugs-fixes"),
    require("postcss-preset-env")({
      autoprefixer: {
        flexbox: "no-2009"
      },
      stage: 3
    })
  ]
}

// Only run PurgeCSS in production (you can also add staging here)
console.log("PURGECSS", process.env.NODE_ENV)
if (process.env.NODE_ENV === "production" || process.env.NODE_ENV === "staging") {
  environment.plugins.push(
    require("@fullhuman/postcss-purgecss")({
      content: [
        "./app/**/*.html.erb",
        "./app/**/*.html.slim",
        "./app/helpers/**/*.rb",
        "./app/javascript/**/*.js",
        "./app/javascript/**/*.vue",
        "./app/javascript/**/*.jsx",
      ],
      defaultExtractor: content => content.match(/[A-Za-z0-9-_:/]+/g) || []
    })
  )
}

module.exports = environment
