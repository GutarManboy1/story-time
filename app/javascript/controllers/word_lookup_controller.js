import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="word-lookup"
export default class extends Controller {

  connect() {
  }

  lookupWord(event) {

    event.preventDefault();

    const word = event.currentTarget.dataset.word;
    alert(`Lookup: ${word}`);
  }
}
