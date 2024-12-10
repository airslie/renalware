import { Controller } from "@hotwired/stimulus"

// This is the Snippets (as opposed to Snippet) controller.
// It is responsible for receiving an #insert message from a snippet_controller elsewhere in the
// DOM - eg in a modal dialog listing a table of available snippets, where each row/tr is controlled
// by a SnippetController. The link between the individual snippet controller and this this
// snippets controller is via the stimulus outlets API.
// See also snippet_controller.js
export default class extends Controller {
  static targets = ["destination"] // a Trix editor that supports .insertHTML()

  // Called my subscribing snippet controllers (we are their outlet)
  insert(invocationUrl, text) {
    this.destinationTarget.editor.insertHTML(text)
    this.createSnippetInvocation(invocationUrl)
  }

  // Note protect_from_forgery options in SnippetInvocationsController
  createSnippetInvocation(invocationUrl) {
    fetch(invocationUrl, {
      method: 'POST',
      credentials: 'same-origin',
      headers: new Headers({"content-type": "application/json"})
    })
    .then(response => response.json())
    .then(json => {
      // OK!
    })
  }
}
