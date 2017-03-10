class PusherController < ApplicationController
  skip_before_action :verify_authenticity_token


   def auth
    if current_user
      auth = Pusher.authenticate(params[:channel_name], params[:socket_id],
        user_id: current_user.id # => required
      )
      render json: auth
    else
      render text: "Not authorized", status: '403'
    end
  end
end
