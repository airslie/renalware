//
// Entry point for the build script in package.json
//

import "@stimulus/polyfills" // required for IE11 support
import "promise-polyfill/src/polyfill"
import "whatwg-fetch"
import "./controllers"
import { Turbo } from "@hotwired/turbo-rails"

if (window.Renalware && Renalware.Configuration) {
  Renalware.Configuration.init({
    disable_inputs_controlled_by_tissue_typing_feed: false,
    disable_inputs_controlled_by_demographics_feed: false
  })
}

Turbo.session.drive = false // By default disable Turbo on all pages

// Handle the situation where a modal has created an object and the controller wants to
// redirect to another page but not render it inside the frame. In this case we will get a
// turbo:frame-missing event so handle this and redirect to the relevant page.
// This does involve a double render though -
// - create button in modal inside turbo_frame "modal" is clicked
// - controller creates model successfully and returns 301 redirect
// - browser redirects (first render)
// - Turbo cannot find the "modal" turbo-frame tag in the page, so (below) we redirect again
//   this time at the window level so there is a full navigation (second render)
// Various discussion here
// https://github.com/hotwired/turbo/issues/257#issuecomment-1591737862
document.addEventListener("turbo:frame-missing", function (event) {
  event.preventDefault()
  event.detail.visit(event.detail.response)
})
