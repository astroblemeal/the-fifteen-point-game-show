import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    window.addEventListener('beforeunload', () => this.leaveWaitingList());
  }

  leaveWaitingList() {
    fetch("/waiting_room_controller/exit_waiting_list")
      .then((response) => response.json())
      .then((data) => {
        this.waitingListCountTarget.innerText = data.waitingListCount;
      })
      .catch((error) => {
        console.error("Error:", error);
      });
  }

  disconnect() {
    window.removeEventListener("beforeunload", this.leaveWaitingList);
  }
}
