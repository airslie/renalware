# Javascript

The js or js.erb files in this top-level folder will be compiled and linked
by sprockets 4 as individually downloadble .js assets.

core.js.erb is the main js file which imports other .js files in
./components and includes js assets from external gem dependencies.

See https://github.com/rails/sprockets#link_directory


## rollupjs

We use rollupjs to compile the modern JS entrypoint into `app/assets/builds`,
which is then served by Sprockets alongside the legacy bundle during the migration.

### renalware.js

This is the JS output from running `rollup --config rollup.config.js`
and is compiled from `app/javascript/renalware/application.js`.

You need to have run `yarn install` before running rollup.

To keep rollup running (watching for changes), add the ` -w` switch to the rollup
command.
