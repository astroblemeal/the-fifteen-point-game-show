class Admin::GameController < ApplicationController
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

    #TODOs

    # Redirect users to game path and start game session

    # Ceate a new game session

    clear_waiting_list
  end

  private

  def redis
    @redis ||= Redis.new
  end
end
