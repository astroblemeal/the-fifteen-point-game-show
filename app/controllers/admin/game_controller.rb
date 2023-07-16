class Admin::GameController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @waiting_list_count = redis.llen('waiting_list')
    @waiting_list = retrieve_waiting_list
  end

  def retrieve_waiting_list
    waiting_list_ids = redis.lrange('waiting_list', 0, -1)
    User.where(id: waiting_list_ids).pluck(:id, :email)
  end

  def clear_waiting_list
    redis.del('waiting_list')
  end

  def start_game_session
    waiting_list = retrieve_waiting_list

    game_name = params[:game_name]
    questions = params[:questions]
    answers = params[:answers]

    players = waiting_list.map { |user_id, email| Player.new(user_id: user_id, email: email) }

    @game_session = GameSession.new(game_name: game_name, questions: questions, answers: answers)

    if @game_session.save
      @game_session.players = players
      @game_session.save

      clear_waiting_list

      # TODO:  Redirect users to game session page
      # redirect_to game_session_path(@game_session)
    end
  end

  private

  def redis
    @redis ||= Redis.new
  end
end
