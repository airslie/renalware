// rollupjs setup adapted from the approach used by ActiveStorage

import resolve from "@rollup/plugin-node-resolve"
import commonjs from "@rollup/plugin-commonjs" // required for uglify
import babel from "rollup-plugin-babel"
import pkg from "./package.json"

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
    sourcemap: false,
  },
  plugins: [babel(), resolve(), commonjs()],
  external: [],
}
