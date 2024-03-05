import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="next-paragraph"
export default class extends Controller {
  static values = {currentIndex: Number};
  connect() {
    window.scrollTo({
      top: document.body.scrollHeight,
      behavior: 'smooth'
    });
    const toggleButton = document.getElementById('toggleButton');
    const divs = document.querySelectorAll('.toggle-div');
    const textContainer = document.querySelector('.text-container')
    const page = document.querySelector(".background-image");
    let currentIndex = this.currentIndexValue; // Keep track of the current div index

    // textContainer.style.display = "none";
    console.log(window.location.pathname);
    document.addEventListener('keyup', () => {

      Turbo.visit(`${window.location.pathname}?paragraph=${this.currentIndexValue + 1}`);

  //     window.scrollTo({
  //       top: document.body.scrollHeight,
  //       behavior: 'smooth'
  //     });
  //    textContainer.style.display = "block"
  //    if (currentIndex < divs.length) {
  //      const paragraph = divs[currentIndex]
  //      console.log(paragraph);
  //      paragraph.style.display = 'block'; // Show the current div
  //      currentIndex++; // Move to the next div for the next button press
  //    }
  //     if (currentIndex === divs.length) {
  //       toggleButton.style.display = "none";
  //     }
    });

    toggleButton.addEventListener('click', () => {
      textContainer.style.display = "block"
      if (currentIndex < divs.length) {
        const paragraph = divs[currentIndex]
        console.log(paragraph);
        paragraph.style.display = 'block'; // Show the current div
        currentIndex++; // Move to the next div for the next button press
      }
      if (currentIndex === divs.length) {
        toggleButton.style.display = "none";
      }
    });
  }
}
