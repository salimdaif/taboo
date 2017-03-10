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
    @matches_hash = current_user.add_scores
    @matches_hash = @matches_hash.sort_by { |id, score| score }.reverse
  end



end
