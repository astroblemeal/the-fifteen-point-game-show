import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const userId = this.data.get("userId");

    window.addEventListener('beforeunload', () => this.leaveWaitingList(userId));
  }

  leaveWaitingList(userId) {
    fetch('/waiting_room_controller/exit_waiting_list', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ userId: userId })
    })
      .then(response => response.json())
      .then(data => {

        console.log(data);
      })
      .catch(error => {
        console.error(error);
      })
  }

  disconnect() {
    window.removeEventListener('beforeunload', this.leaveWaitingList);
  }
}
