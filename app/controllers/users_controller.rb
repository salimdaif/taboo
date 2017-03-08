class UsersController < ApplicationController
  skip_before_action :redirect_to_questions, only: :show


require 'typhoeus'
require 'json'

  def show
    @answer = Answer.new
    # @user = current_user
    @user = User.find(params[:id])
    # @question = Question.find(params[:question_id])
    @question = current_user.unanswered_questions
  end

  def edit
    @user = User.find(params[:id])
    authorize @user, :update?
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def deactivate
    @user = User.find(params[:id])
    authorize @user
    @user.deactivate
    if @user.save
      redirect_to destroy_user_session_path
    else
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:avatar)
  end
end
