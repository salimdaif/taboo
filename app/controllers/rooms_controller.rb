class RoomsController < ApplicationController
  def new
  end

  def create
  end

  def show
  end

  def hello_world
    Pusher.trigger('my-channel', 'my-event', {
      message: 'hello world'
    })
  end

end
