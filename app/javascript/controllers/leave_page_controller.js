import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    window.addEventListener("beforeunload", () => this.leaveWaitingList());
  }

  leaveWaitingList() {
    fetch("/waiting_room/exit_waiting_list", {
      method: "GET",
      headers: { "Content-Type": "application/json" },
    })
      .then((response) => response.json())
      .then((data) => {
        console.log(data);
      })
      .catch((error) => {
        console.error("Error:", error);
      });
  }

  disconnect() {
    window.removeEventListener("beforeunload", this.leaveWaitingList);
  }
}
