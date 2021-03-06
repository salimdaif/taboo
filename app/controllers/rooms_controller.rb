class RoomsController < ApplicationController
  def new
  end

  def create
    if @user = User.find(params[:recipient])

      @room = Room.new(sender_id: current_user.id, recipient_id: @user.id)
      @sender = current_user

      if @room.save
        notify(@user, @room, @sender)
        redirect_to room_path(@room)
      end
    end
  end


  def notify(user, room, sender)
    begin
      Pusher.trigger('online-channel', 'notify_user', :user_id => user.id, :room_id => room.id, :sender_username => sender.username)
    rescue Pusher::Error => e
      # (Pusher::AuthenticationError, Pusher::HTTPError, or Pusher::Error)
    end

  end

  def show
    @room = Room.find(params[:id])

    if @room.recipient_id == current_user.id
      @user = User.find(@room.recipient_id)
      @target = User.find(@room.sender_id)
    else
      @user = User.find(@room.sender_id)
      @target = User.find(@room.recipient_id)
    end


    @matches_hash = current_user.add_scores
    @matches_hash = @matches_hash.sort_by { |id, score| score }.reverse
  end



end
