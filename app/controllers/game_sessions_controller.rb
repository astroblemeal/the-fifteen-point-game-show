class GameSessionsController < ApplicationController
  def show
    @game_session = GameSession.find(params[:id])
    @player_ids = @game_session.player_ids
    @game_name = @game_session.game_name
    @questions = @game_session.questions
    @created_at = @game_session.created_at
  end
end
