const { defineConfig, globalIgnores } = require("eslint/config")
const { builtinRules } = require("eslint/use-at-your-own-risk")

const eslintRecommendedRules = Object.fromEntries(
  Array.from(builtinRules)
    .filter(([, rule]) => rule.meta?.docs?.recommended)
    .map(([name]) => [name, "error"])
)

const browserGlobals = Object.fromEntries(
  [
    "AbortController",
    "AbortSignal",
    "Blob",
    "ClipboardItem",
    "CustomEvent",
    "DOMParser",
    "Element",
    "Event",
    "EventSource",
    "File",
    "FileReader",
    "FormData",
    "Headers",
    "HTMLInputElement",
    "History",
    "Image",
    "IntersectionObserver",
    "KeyboardEvent",
    "Location",
    "MouseEvent",
    "MutationObserver",
    "Navigator",
    "Node",
    "Notification",
    "Option",
    "Request",
    "Response",
    "Renalware",
    "ResizeObserver",
    "URL",
    "URLSearchParams",
    "WebSocket",
    "Window",
    "XMLHttpRequest",
    "$",
    "alert",
    "clearInterval",
    "clearTimeout",
    "console",
    "document",
    "event",
    "fetch",
    "history",
    "jQuery",
    "location",
    "navigator",
    "requestAnimationFrame",
    "setInterval",
    "setTimeout",
    "window"
  ].map((name) => [name, "readonly"])
)

module.exports = defineConfig([
  globalIgnores([
    "app/assets/javascripts/**/*",
    "vendor/assets/javascripts/**/*",
    "**/*{.,-}min.js",
    "coverage/**/*"
  ]),
  {
    files: ["app/javascript/**/*.js"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      globals: browserGlobals
    },
    rules: {
      ...eslintRecommendedRules,
      semi: ["error", "never"],
      quotes: ["error", "double"],
      "no-unused-vars": ["error", { vars: "all", args: "none" }]
    }
  }
])
