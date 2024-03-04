import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"
// Connects to data-controller="story-subscription"
export default class extends Controller {
  static values = { storyId: Number }
  connect() {
    console.log(this.storyIdValue)
    this.channel = createConsumer().subscriptions.create(
      { channel: "StoryChannel", id: this.storyIdValue },
      { received: (data) =>
        {
          console.log(data)
          if (data.action === 'redirect') {
            window.location.href = data.path;
          }
        }
      }       // the data is what you got from the backend, if what you got was a hash (which is the most likely case) you can access the stuff inside the hash with .key  (you can use the . instead of [] becaues this is JS, not ruby, and JS allows this notation.)
    )
    console.log(`Subscribed to the story with the id ${this.storyIdValue}.`)
  }
}
