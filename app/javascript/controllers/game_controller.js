import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["waitingListCount"];

  connect() {
    console.log("Hello, Stimulus!", this.element);
  }

  clearWaitingList() {
    fetch("/admin/game/clear_waiting_list")
      .then((response) => response.json())
      .then((data) => {
        this.waitingListCountTarget.innerText = data.waitingListCount;
      })
      .catch((error) => {
        console.error("Error:", error);
      });
  }

  startGameSession(event) {
    console.log("START THE GAEMMMMEE")
  }
}
