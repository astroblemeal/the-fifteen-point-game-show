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

    puts "Game Name: #{params[:game_name]}"
    puts "Questions: #{params[:questions]}"
    puts "Answers: #{params[:answers]}"

    clear_waiting_list
  end

  private

  def redis
    @redis ||= Redis.new
  end
end
