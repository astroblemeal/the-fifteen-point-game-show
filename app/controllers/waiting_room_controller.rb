require 'redis'

class WaitingRoomController < ApplicationController

  def index
    @current_user = User.find_by(id: session[:user_id])
    @waiting_list = redis.lrange('waiting_list', 0, -1)
    @waiting_list_count = redis.llen('waiting_list')

    puts "WAITING LIST COUNT (index): #{@waiting_list_count}"

    if !@waiting_list.include?(@current_user.id.to_s)
      enter_waiting_list
    end

    waiting_list = redis.lrange('waiting_list', 0, -1)

    puts "WAITING LIST COUNT (index): #{waiting_list.count}"

    retrieve_waiting_list
  end

  def enter_waiting_list
    puts "Added to WAITING LIST (enter_waiting_list): #{@current_user.email}"
    redis.lpush('waiting_list', @current_user.id)

  end

  def exit_waiting_list

    userId = params[:userId].to_s

    if !redis.lrange('waiting_list', 0, -1).include?(userId)
      puts "Removed from WAITING LIST (enter_waiting_list): #{@current_user.email}"
      puts "WAITING LIST COUNT (exit_waiting_list): #{waiting_list.count}"
      redis.lrem('waiting_list', 0, userId)
    end
    waiting_list = redis.lrange('waiting_list', 0, -1)



    render json: { message: "Exited waiting list successfully" }
  end

  def clear_waiting_list
    redis.del('waiting_list')
    render json: { waitingListCount: @waiting_list_count }
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
