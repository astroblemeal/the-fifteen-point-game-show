import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['questionNumber'];

  connect () {
    const clearButton = document.querySelector("#clear-game-session");

    if (clearButton) {
      clearButton.addEventListener("click", () => {
        const gameSessionId = this.element.dataset.gameSessionId;

        fetch(`/game_sessions/${gameSessionId}/clear_game_session`)
          .catch(error => {
            console.error(error);
          });
      });
    }
  }

  fetchQuestion(event) {
    event.preventDefault();
    const gameSessionId = this.element.dataset.gameSessionId;
    const questionNumber = this.questionNumberTarget.value;

    fetch(`/game_sessions/${gameSessionId}/questions_separator?question_number=${questionNumber}`)
      .then((response) => response.json())
      .then((data) => {
        console.log(data)
      })
      .catch((error) => {
        console.error(error);
      });
  }
}
