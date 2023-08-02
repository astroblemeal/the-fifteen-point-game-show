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

    game_session = GameSession.new(game_name: game_name, questions: questions, answers: answers)

    if game_session.save
      game_session.save_with_players(waiting_list)

      clear_waiting_list

      render json: { sessionId: game_session.id, success: true }

      redis.set('game_session', game_session.id)
    else
      message = game_session.errors.full_messages.join(", ")
      puts "Error starting game session: #{message}"

      render json: { success: false }
    end
  end

  def poll_game_session_status
    game_session = get_game_session

    if game_session
      render json: { exists: true, url: game_session_url(game_session), success: true }
      clear_game_session
    else
      render json: { exists: false, success: false }
    end
  end

  private

  def retrieve_waiting_list
    waiting_list_ids = redis.lrange('waiting_list', 0, -1)
    User.where(id: waiting_list_ids).pluck(:id, :email)
  end

  def clear_waiting_list
    redis.del('waiting_list')
  end

  def clear_game_session
    redis.del('game_session')
  end

  def get_game_session
    redis.get('game_session')
  end

  def redis
    @redis ||= Redis.new
  end
end
