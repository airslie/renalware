import { Controller } from "@hotwired/stimulus"

// This is the Snippet (as opposed to Snippets) controller.
// Each row (tr) in a table of snippets has a snippet controller.
// When the Insert link in the row is clicked, the #insert() action is called.
// This extracts the snippet text from the sourceTarget (eg a td in the tr), and then
// delegates the insert call to each (usually just one) snippets outlet; this outlet is a link
// to a stimulus snippets elsewhere in the DOM, defined by CSS - see eg
//   td(snippet-snippets-outlet="#snippets-controller")
// The overarching snippets controller knows about the destination for the snippet ie where it will
// be inserted, the individual snippet controllers are there to receive user command.
// Whenever a snippet is inserted, we issue a POST to 'create' a snippet usage so users can see
// which snippets are being used the most.
export default class extends Controller {
  static targets = ["source"]
  static outlets = ["snippets"]
  static values = {
    invocationUrl: String // url to POST to when the snippet is inserted
  }

  insert(event) {
    event.preventDefault()
    const snippetText = this.sourceTarget.innerHTML
    this.snippetsOutlets.forEach(x => x.insert(this.invocationUrlValue, snippetText))
  }
}
