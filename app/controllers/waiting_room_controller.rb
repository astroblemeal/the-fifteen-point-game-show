require 'redis'

class WaitingRoomController < ApplicationController

  def index
    @current_user = User.find_by(id: session[:user_id])
    @waiting_list = redis.lrange('waiting_list', 0, -1)

    if !@waiting_list.include?(@current_user.id.to_s)
      enter_waiting_list
    end

    retrieve_waiting_list
  end

  def enter_waiting_list
    redis.lpush('waiting_list', current_user.id)
  end

  def exit_waiting_list
    redis.lrem('waiting_list', 0, current_user.id)
    exit_waiting_list
  end

  def clear_waiting_list
    redis.del('waiting_list')
  end

  def retrieve_waiting_list
    waiting_list = redis.lrange('waiting_list', 0, -1)

    waiting_list.each do |user_id|
    user = User.find(user_id)
    end
  end

  private

  def redis
    @redis ||= Redis.new
  end
end
