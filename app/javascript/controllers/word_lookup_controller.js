import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { word: String }

  showDefinition(event) {
    const word = this.wordValue; // Access the word value
    const modalBody = document.querySelector('#definitionModal .modal-body p');

    // Fetch the word's definition
    const url = `https://api.dictionaryapi.dev/api/v2/entries/en/${word}`;

    fetch(url)
      .then(response => response.json())
      .then(data => {
        const definition = data[0]?.meanings[0]?.definitions[0]?.definition || 'Definition not found.';
        modalBody.textContent = `${word}: ${definition}`;
      })
      .catch(error => {
        console.error('Error fetching word definition:', error);
        modalBody.textContent = `Error fetching definition for "${word}".`;
      });
  }
}
