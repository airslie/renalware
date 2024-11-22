import { Controller } from "@hotwired/stimulus"

// This is the Snippet (as opposed to Snippets) controller.
// Each row (tr) in a table of snippets has a snippet controller.
// When the Insert link in the row is clicked, the #insert() action is called.
// This extracts the snippet text from the sourceTarget (eg a td in the tr), and then
// delegates the the insert call to each (usually just one) snippets outlet; this outlet is a link
// to a stimulus snippets elsewhere in the DOM, defined by CSS - see eg
//   td(snippet-snippets-outlet="#snippets-controller")
// The snippets controller knows about the destination for the snippet ie where it will be
// inserted.
export default class extends Controller {
  static targets = ["source"]
  static outlets = ["snippets"]

  insert(event) {
    event.preventDefault()
    const snippetText = this.sourceTarget.innerHTML
    this.snippetsOutlets.forEach(x => x.insert(snippetText))
  }
}
