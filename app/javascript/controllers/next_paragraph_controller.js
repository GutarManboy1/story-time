import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="next-paragraph"
export default class extends Controller {
  connect() {
    const toggleButton = document.getElementById('toggleButton');
    const divs = document.querySelectorAll('.toggle-div');
    let currentIndex = 0; // Keep track of the current div index

    toggleButton.addEventListener('click', () => {
      if (currentIndex < divs.length) {
        divs[currentIndex].style.display = 'block'; // Show the current div
        currentIndex++; // Move to the next div for the next button press
        window.scrollTo({
          top: document.body.scrollHeight,
          behavior: 'smooth' // Optional: for smooth scrolling
        });
      }
    });
  }
}
