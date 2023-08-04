class Admin::GameController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @waiting_list_count = redis.llen('waiting_list')
    @waiting_list = retrieve_waiting_list
  end

  def start_game_session
    waiting_list = retrieve_waiting_list

    game_name = params[:game_name]
    questions = params[:questions]
    answers = params[:answers]

    game_session = GameSession.create_with_players(waiting_list, game_name: game_name, questions: questions, answers: answers)

    if game_session.persisted?
      redis.del('waiting_list')
      redis.set('game_session', game_session.id)
    end

    render json: { success: true }
  end

  def poll_game_session_status
    game_session = redis.get('game_session')

    if game_session
      render json: { exists: true, url: game_session_url(game_session), success: true }
    else
      render json: { exists: false, success: false }
    end
  end

  def clear_game_session
    redis.del('game_session')
    render json: { message: "Cleared game session successfully" }
  end

  def clear_waiting_list
    redis.del('waiting_list')
    render json: { message: "Cleared waiting list successfully" }
  end

  private

  def retrieve_waiting_list
    waiting_list_ids = redis.lrange('waiting_list', 0, -1)
    User.where(id: waiting_list_ids).pluck(:id, :email)
  end

  def get_game_session
    redis.get('game_session')
  end

  def redis
    @redis ||= Redis.new
  end
end
