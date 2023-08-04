import { Controller } from "@hotwired/stimulus";
import consumer from '../channels/consumer';

export default class extends Controller {
  static targets = ['questionNumber'];

  connect() {
    const gameSessionId = this.element.dataset.gameSessionId;
    this.subscribeToGameSessionChannel(gameSessionId);
  }

  stopGameSession() {
    const gameSessionId = this.element.dataset.gameSessionId;

    fetch(`/game_sessions/${gameSessionId}/clear_game_session`)
      .catch(error => {
        console.error(error);
      });
  }

  subscribeToGameSessionChannel(gameSessionId) {
    const channel = consumer.subscriptions.create(
      { channel: "GameSessionChannel", game_session_id: gameSessionId },
      {
        received: (data) => {
          const questionElement = document.querySelector("#current-question");
          const questionNumberElement = document.querySelector("#current-question-number");
          if (questionElement && questionNumberElement) {
            questionElement.textContent = data.question;
            questionNumberElement.textContent = data.question_number;
          }
        },
      }
    );
  }

  fetchQuestion(event) {
    event.preventDefault();
    const gameSessionId = this.element.dataset.gameSessionId;
    const questionNumber = this.questionNumberTarget.value;

    fetch(`/game_sessions/${gameSessionId}/questions_separator?question_number=${questionNumber}`)
      .then((response) => response.json())
      .then((data) => {
        consumer.subscriptions.notify(
          {
            channel: "GameSessionChannel",
            game_session_id: gameSessionId,
            ...data,
          }
        );
      })
      .catch((error) => {
        console.error(error);
      });
  }
}
