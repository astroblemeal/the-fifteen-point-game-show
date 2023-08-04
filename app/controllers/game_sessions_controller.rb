class GameSessionsController < ApplicationController
  def show
    @game_session = GameSession.find(params[:id])
    @game_session_id = @game_session.id
    @players = @game_session.players
    @game_name = @game_session.game_name
    @questions = JSON.parse(@game_session.questions)
    @answers = JSON.parse(@game_session.answers)
    @created_at = @game_session.created_at
    @current_user = User.find_by(id: session[:user_id])
  end

  def clear_game_session
    redis.del('game_session')
    render json: { message: "Cleared game session successfully" }
  end

  def questions_separator
    game_session = GameSession.find(params[:id])
    questions = JSON.parse(game_session.questions)

    question_number = params[:question_number].to_i
    return render json: { error: 'Invalid question number' }, status: :bad_request unless (1..questions.length).include?(question_number)

    question = questions[question_number - 1]
    separated_question = {
      "question_number" => question_number,
      "question" => question
    }

    render json: separated_question
  end

  private

  def redis
    @redis ||= Redis.new
  end
end
