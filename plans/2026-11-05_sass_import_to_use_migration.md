# Sass `@import` to `@use` migration

## Status

The `global-builtin`, `color-functions`, `slash-div`, `if-function` and `function-units`
deprecations are fixed, with compiled CSS byte-identical to the baseline.
127 warnings remain: 123 `@import` (the `import` deprecation) and 4 from `node_modules/balloon-css`
(`fade-out`, `map-has-key`, `map-get`, which we cannot edit).

`@import` is removed in Dart Sass 3.0.0. Nothing breaks until we upgrade past 2.x, so this is
planned work, not urgent.

## Why it is not mechanical

1. **Foundation is global by design.** `lib/_foundation_and_overrides.scss` sets about 700 lines
   of `$variables` and then `@import`s `foundation/components/*`, which read those variables
   as globals (`$column-gutter`, `$rem-base`, `$primary-color`, ...) and use each other's
   mixins. `@use` gives each file its own scope, so every reference needs a namespace or a
   `@forward`.
2. **Glob imports.** `core.scss` does `@import "./modules/**/*"` and `"./partials/**/*"`.
   That is a `dartsass-sprockets` importer feature. `@use` does not support globs.
3. **Implicit globals in app partials.** About 70 files under `modules/` and `partials/`
   rely on `$nhs-*`, `$link-colour`, `$column-gutter`, `rem-calc()`, and the mixins in
   `base/_mixins.scss`, with no import of their own. Their order in `core.scss` is what makes
   it work.
4. **`!global` mutation.** Foundation's `_functions.scss` does `$modules: append(...) !global`
   (the `exports()` mixin). Module-scoped `@use` changes what that touches.
5. **Plain CSS and third-party imports.** `trix`, `print-js/dist/print` and
   `slim-select/dist/slimselect` are `.css` or vendor files. Check each: `@use` on plain CSS
   needs the `.css` extension or a load path that resolves it.

## Safety net (do first)

Commit the comparison harness so every step is diffable.

- Add a rake task or `bin/` script (e.g. `rake assets:css_snapshot[dir]`) that compiles every
  stylesheet entry point (`renalware/*.scss` and `heroic`) through Sprockets and writes the CSS to a directory.
  Base it on the scratchpad `compile.rb` used for the first pass. Set
  `config.sass.verbose = true`, clear `tmp/cache/assets` first, and log warnings to a file.
- Take a snapshot on `main`. After each step: recompile, `diff -r`, and require zero diff.
- Note: `lighten()` clamps to 100% but `color.adjust` does not, so watch for out-of-range values.
- Also run the system specs that load pages with the stylesheet (Playwright) once at the end.

## Approach

Avoid a big-bang rewrite. Convert from the leaves inwards, one commit per step, and diff after each.

### Step 1. Make order and scope explicit (no behaviour change)

Introduce a single entry for shared config: `base/_config.scss` that `@forward`s the
Foundation settings, `base/variables` and `base/mixins`. Do not change imports yet.
Goal: one place that defines what app partials depend on.

### Step 2. Replace the globs

Add `modules/_index.scss` and `partials/_index.scss` that list the files explicitly
(`@import "clinical"; @import "hd"; ...`). `core.scss` imports `modules/index` and
`partials/index`. Alphabetical order must match the glob order exactly, so CSS ordering
is unchanged. Add a spec or rake check that fails when a new file is not listed in the index
(otherwise new partials silently disappear).

### Step 3. Third-party and leaf imports

- `trix`, `print-js`, `slim-select`, `clockpicker`, `flatpickr`: convert to `@use ... ` where
  they are self-contained. Where a package is `.css`, import as plain CSS in the layout or
  Sprockets `require` instead.
- `balloon-css`: either upgrade to a version without global functions, vendor a patched copy
  into `vendor/assets/stylesheets`, or silence it with `quiet_deps`. Recommended: vendor a copy,
  since the package is tiny and unmaintained.

### Step 4. Foundation as a module

- Convert `_foundation_and_overrides.scss` into a configured module:
  `@use "foundation/components/grid" with ($column-gutter: ..., $row-width: ...)`,
  or, less invasive, split the overrides into `_foundation_settings.scss` and have each
  component `@use "settings"` for its variables.
- Convert each of the 17 components: replace `@import "global"` with `@use "global"`, namespace
  cross-file references, and mark overridable variables `!default` (they already are).
- `_functions.scss` becomes `@use`d with `rem-calc`, `strip-unit` etc. exposed.
- Foundation is deprecated in this project (Tailwind is the target), so keep this to the
  minimum. If the settings approach gets large, consider **freezing** Foundation into a
  pre-resolved partial instead (see Alternatives).

### Step 5. App modules and partials

- Give each partial `@use "../base/config" as *;` as its first line. This keeps all existing
  variable and mixin names unchanged, so there is no mass renaming.
- Add `@use "sass:color"` etc. where already needed (done).
- Remove the `@import "./base/..."` lines from `core.scss` once every partial pulls in its own deps.

### Step 6. `core.scss`

Replace remaining `@import`s with `@use` (order-sensitive CSS emitted by `@use` happens once, in
the order of first use; verify with the diff). Delete the `*= require_self` oddity only if the
diff stays clean.

## Alternatives

- **Silence only:** set `config.sass.silence_deprecations = ["import"]` in
  `config/application.rb`. Zero risk, hides the warnings until Dart Sass 3.0. Reasonable
  if the real plan is to drop Foundation and Sprockets Sass for Tailwind.
- **Freeze Foundation:** compile the Foundation parts once with the app's settings, check the
  resulting CSS in as `vendor/assets/stylesheets/foundation.css`, and keep only app-owned
  variables for the partials. Removes steps 3 to 4 but gives up the ability to tweak Foundation variables.

## Risks and checks

- CSS ordering changes (cascade): caught by `diff -r` on compiled CSS. Never merge a step with a non-empty diff unless the diff is understood and reviewed.
- Sprockets dependency tracking: dev-mode recompiles when `@use`d files change; confirm by editing a partial.
- `dartsass-sprockets` custom importer may not resolve `@use` for load paths the way it does `@import`. Spike on one partial before committing to the approach (do this at the start of Step 1).
- Heroic pack: `_wizard.scss` and `_biopsy.scss` use `require_tree`, not `@import`, and rely on app variables. Verify they still resolve.

## Done when

- Zero `import` deprecation warnings, verbose compile (balloon-css handled per Step 3).
- `diff -r` against the `main` snapshot is empty for all entry points.
- System specs pass.

## Open decisions for the owner

1. Do the full migration, or silence `import` and wait for the Tailwind move? Recommend silencing if
   Foundation removal is planned within about 12 months.
2. For balloon-css: vendor, upgrade or silence?
