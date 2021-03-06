class RatingsController < ApplicationController
  def new
    @rating = Rating.new
  end

  def create
    @rating = Rating.new(ratings_params)
    @rating.sender_id = current_user.id

    # BEWARE
    # THIS IS TEMPORARY
    @rating.recipient_id = User.find_by(username: "mcpenchel").id
    # THIS IS TEMPORARY

    if @rating.save
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  private
  def ratings_params
    params.require(:rating).permit(:helpfulness, :empathy, :response_time, :review, :recipient_id)
  end

end
