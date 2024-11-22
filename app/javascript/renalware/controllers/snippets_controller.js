import { Controller } from "@hotwired/stimulus"

// This is the Snippets (as opposed to Snippet) controller.
// It is responsible for receiving an #insert message from a snippet_controller elsewhere in the
// DOM - eg in a modal dialog listing a table of available snippets, where each row/tr is controlled
// by a SnippetController. The link between the individual snippet controller and this this
// snippets controller is via the stimulus outlets API.
// See also snippet_controller.js
export default class extends Controller {
  static targets = ["destination"] // a Trix editor that supports .insertHTML()

  insert(snippetText) {
    this.destinationTarget.editor.insertHTML(snippetText)
  }
}
