import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"
export default class extends Controller {
  static targets = ["cacheIdOne", "cacheIdTwo", "submitOne", "submitTwo"]
  static values = {segmentId: Number}
  connect() {
    console.log(this.segmentIdValue)
    console.log(this.cacheIdOneTarget)
    console.log(this.submitOneTarget)
    let completed = 0;
    this.channel = createConsumer().subscriptions.create(
      { channel: "SegmentChannel", id: this.segmentIdValue },
      { received: (data) =>
        {
          console.log(data)
          if (data.action === 'segment_ready') {
            if (data.user_choice === 1) {
              console.log("changing the value of the value of the cache_id form input...")
              this.cacheIdOneTarget.value = data.new_segment_hash;
              completed += 1;
            }
            if (data.user_choice === 2) {
              console.log("changing the value of the value of the cache_id form input...")
              this.cacheIdTwoTarget.value = data.new_segment_hash;
              completed += 1;
            }
            if (completed === 2) {
              console.log("Unlocking buttons")
              this.submitOneTarget.disabled = false;
              this.submitTwoTarget.disabled = false;
            }
          }
        }
      }       // the data is what you got from the backend, if what you got was a hash (which is the most likely case) you can access the stuff inside the hash with .key  (you can use the . instead of [] becaues this is JS, not ruby, and JS allows this notation.)
    )
    console.log(`Subscribed to the segment with the id ${this.segmentIdValue}.`)
  }
}
