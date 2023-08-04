import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect () {
    console.log("Connected");
    const clearButton = document.querySelector("#clear-game-session");

    if (clearButton) {
      clearButton.addEventListener("click", () => {
        const gameSessionId = clearButton.dataset.gameSessionId;

        fetch(`/game_sessions/${gameSessionId}/clear_game_session`)
          .then(response => response.json())
          .then(data => {
            console.log(data);
          })
          .catch(error => {
            console.error(error);
          });
      });
    }
  }
}
