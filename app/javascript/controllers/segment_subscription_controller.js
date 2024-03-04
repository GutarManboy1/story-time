import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"
export default class extends Controller {
  static values = { segmentId: Number }
  connect() {
    console.log(this.segmentIdValue)
    this.channel = createConsumer().subscriptions.create(
      { channel: "SegmentChannel", id: this.segmentIdValue },
      { received: (data) =>
        {
          console.log(data)
          if (data.action === 'redirect') {
            window.location.href = data.path;
          }
        }
      }       // the data is what you got from the backend, if what you got was a hash (which is the most likely case) you can access the stuff inside the hash with .key  (you can use the . instead of [] becaues this is JS, not ruby, and JS allows this notation.)
    )
    console.log(`Subscribed to the segment with the id ${this.segmentIdValue}.`)
  }
}
