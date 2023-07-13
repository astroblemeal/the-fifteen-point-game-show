require 'redis'

class WaitingRoomController < ApplicationController

  def index
    @current_user = User.find_by(id: session[:user_id])
    @waiting_list = redis.lrange('waiting_list', 0, -1)
    @waiting_list_count = redis.llen('waiting_list') + 1

    if !@waiting_list.include?(@current_user.id.to_s)
      enter_waiting_list
    end
  end

  def enter_waiting_list
    redis.lpush('waiting_list', @current_user.id)
  end

  def exit_waiting_list
    userId = params[:userId].to_s
    redis.lrem('waiting_list', 0, userId)

    render json: { message: "Exited waiting list successfully" }
  end

  private

  def redis
    @redis ||= Redis.new
  end
end
