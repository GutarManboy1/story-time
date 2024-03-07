import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { word: String }

  showDefinition(event) {
    const str = this.wordValue;
    const regex = /[.,\s]/g;
    const word = str.replace(regex, '');
    const modalBody = document.querySelector('#definitionModal .modal-body p');
    const excerptInput = document.querySelector('#flashcard_excerpt');
    const answerInput = document.querySelector('#flashcard_answer');
    const modalTitle = document.querySelector('.modal-title');
    // Fetch the word's definition
    const url = `https://api.dictionaryapi.dev/api/v2/entries/en/${word}`;

    fetch(url)
      .then(response => response.json())
      .then(data => {
        const definition = data[0]?.meanings[0]?.definitions[0]?.definition || 'Definition not found.';
        modalBody.innerHTML = definition;
        excerptInput.value = word;
        answerInput.value = definition;
        modalTitle.innerHTML = word;
      })
      .catch(error => {
        console.error('Error fetching word definition:', error);
        modalBody.textContent = `Error fetching definition for "${word}".`;
      });
  }
}
