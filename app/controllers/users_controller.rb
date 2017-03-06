class UsersController < ApplicationController
  skip_before_action :redirect_to_questions, only: :show

  def show
    @answer = Answer.new
    @user = current_user
    # @question = Question.find(params[:question_id])
    @question = current_user.unanswered_questions
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:avatar)
  end
end
