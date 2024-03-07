import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"
export default class extends Controller {
  static targets = ["cacheId1", "cacheId2", "submit1", "submit2"]
  connect() {
    console.log(this.segmentIdValue)
    let completed = 0;
    this.channel = createConsumer().subscriptions.create(
      { channel: "SegmentChannel", id: this.segmentIdValue },
      { received: (data) =>
        {
          console.log(data)
          if (data.action === 'segment_ready') {
            if (data.user_choice === 1) {
              console.log("changing the value of the value of the cache_id form input...")
              this.cacheId1Target.value = data.cache_id;
              completed += 1;
            }
            if (data.user_choice === 2) {
              console.log("changing the value of the value of the cache_id form input...")
              this.cacheId2Target.value = data.cache_id;
              completed += 1;
            }
            if (completed === 2) {
              this.submit1Target.disabled = false;
              this.submit2Target.disabled = false;
            }
          }
        }
      }       // the data is what you got from the backend, if what you got was a hash (which is the most likely case) you can access the stuff inside the hash with .key  (you can use the . instead of [] becaues this is JS, not ruby, and JS allows this notation.)
    )
    console.log(`Subscribed to the segment with the id ${this.segmentIdValue}.`)
  }
}
