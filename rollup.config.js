import resolve from "@rollup/plugin-node-resolve"
import commonjs from "@rollup/plugin-commonjs" // required for uglify
import babel from "rollup-plugin-babel"
// rollup-plugin-stimulus helps us include stimulus controllers as webpack helpers unavaialable
import stimulus from "rollup-plugin-stimulus"
import uglify from "rollup-plugin-uglify" // beautify the js output

const uglifyOptions = {
  mangle: false,
  compress: false,
  output: {
    beautify: true,
    indent_level: 2
  }
}

const resolveOption = {
  browser: true,
  preferBuiltins: false,
  jsnext: true,
  main: true
}

// Had to add context window to avoid rollup converting self to undefined in stimulus
export default {
  context: "window",
  input: "app/javascript/renalware/index.js",
  output: {
    file: "app/assets/javascripts/renalware/rollup_compiled.js",
    format: "esm",
    name: "renalwarec-core",
    sourcemap: false,
  },
  plugins: [
    stimulus(),
    babel(),
    resolve(),
    commonjs(),
    uglify(uglifyOptions)
  ]
}
