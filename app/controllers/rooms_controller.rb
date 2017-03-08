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
  end

  def hello_world
    Pusher.trigger('my-channel', 'my-event', {
      message: 'hello world'
    })
  end

end
