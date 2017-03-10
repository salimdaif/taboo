class RoomsController < ApplicationController
  def new
  end

  def create
    if @user = User.find(params[:recipient])

      @room = Room.new(sender_id: current_user.id, recipient_id: params[:recipient])

      redirect_to room_path(@room) if @room.save
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
