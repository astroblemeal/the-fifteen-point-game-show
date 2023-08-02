import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["waitingListCount"];

  connect() {
    this.pollGameSessionStatus();
  }

  clearWaitingList() {
    fetch("/admin/game/clear_waiting_list")
      .then((response) => response.json())
      .then((data) => {
        this.waitingListCountTarget.innerText = data.waitingListCount;
        // window.location.reload();
      })
      .catch((error) => {
        console.error("Error:", error);
      });
  }

  pollGameSessionStatus() {
    setInterval(() => {
      console.log("poll")
      fetch("/admin/game/poll_game_session_status")
        .then((response) => response.json())
        .then((data) => {
          if (data.exists) {
            window.location.href = data.url
            clearInterval();
          } else {
            console.log("Game session doesn't exist yet");
          }
        })
        .catch((error) => {
          console.error("Error while polling game session status", error);
          clearInterval();
        });
    }, 5000);
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
      .then(response => response.json())
      .then(data => {
        const gameSessionPath = "/game_sessions/" + data.sessionId;
        window.location.href = gameSessionPath;
      })
      .catch(error => {
        console.error("Error:", error);
      })
  }
}
