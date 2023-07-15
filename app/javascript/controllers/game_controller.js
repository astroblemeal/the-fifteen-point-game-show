import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["waitingListCount"];

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
    event.preventDefault();

    const form = event.target;
    const formData = new FormData(form);

    const gameName = formData.get("game_name");
    const questions = formData.getAll("questions[]");
    const answers = formData.getAll("answers[]");

    fetch("/admin/game/start_game_session", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        game_name: gameName,
        questions: questions,
        answers: answers,
      }),
    })
      .then((response) => response.json())
      .catch((error) => {
        console.log("Error:", error);
      });
  }
}
