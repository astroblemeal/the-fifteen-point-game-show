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
    render json: { waitingListCount: @waiting_list_count }
  end

  def start_game_session
    waiting_list = retrieve_waiting_list

    game_name = params[:game_name]
    questions = params[:questions]
    answers = params[:answers]
    player_ids = retrieve_waiting_list

    @game_session = @game_session = GameSession.new(game_name: game_name, questions: questions, answers: answers, player_ids: player_ids)

    if @game_session.save
      puts "GAME SESSION SAVED!"
      # clear_waiting_list

      # Redirect users to game session page
      # redirect_to game_session_path(@game_session)
    else
      puts "GAME SESSION DIDN'T SAVE!"
    end

  end

  private

  def redis
    @redis ||= Redis.new
  end
end
