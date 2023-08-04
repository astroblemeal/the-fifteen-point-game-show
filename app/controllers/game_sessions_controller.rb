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

  private

  def redis
    @redis ||= Redis.new
  end
end
