// rollupjs setup adapted from the approach used by ActiveStorage

import resolve from "@rollup/plugin-node-resolve"
import commonjs from "@rollup/plugin-commonjs" // required for uglify
import pkg from "./package.json"

const watchDirectories = [
  pkg.main,
  "app/views",
  "app/components",
  "demo/app/assets/builds", // Output from Tailwindcss and JS
]

// Had to add context window to avoid rollup converting self to undefined in stimulus
export default {
  context: "window",
  input: "app/javascript/renalware/application.js",
  output: {
    file: pkg.main,
    format: "esm",
    //format: "es",
    inlineDynamicImports: true,
    globals: {
      jquery: "jQuery",
    },
    name: "renalware-core",
    sourcemap: true,
  },
  plugins: [
    resolve(),
    commonjs()
  ],
  external: [],
}
