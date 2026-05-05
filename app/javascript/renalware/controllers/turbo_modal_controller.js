import { Controller } from "@hotwired/stimulus"


export default class extends Controller {

  // Example usage:
  //  div(data-controller="turbo-modal" data-action="turbo:submit-end->turbo-modal#submitEnd")
  //
  // Note that the current Turbo support for breaking out of say a modal form after a successful
  // create, where we want to redirect somewhere else, is not very good. Until it is baked into to
  // Turbo, or there is a good recommended approach, we are currently using a "turbo:frame-missing"
  // handler in application.js
  // However the below approach also works but we are not currently using it:
  // When the Create button is hit in the modal and the rails controller successfully creates
  // the modal, it should return eg
  //   head :no_content, location: hd_slot_requests_path
  // and as long as the markup looks like the above, we will come into submitEnd and
  // detect the 204 and redirect to the specific url. This avoids a double render (a problem with
  // the "turbo:frame-missing" redirect solution)
  submitEnd(event) {
    let response = event.detail?.fetchResponse?.response
    let status = response?.status
    let url = response?.headers?.get("location") ?? null

    if (status === 204 && url) {
        event.preventDefault()
        window.location = url
        return false
    }
  }

  close(e) {
    e.preventDefault()
    this.element.remove()
  }
}
