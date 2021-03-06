class UsersController < ApplicationController
  skip_before_action :redirect_to_custom_path, only: :show

  def show
    if params[:seen_intro].present?
      User.find(current_user.id).update(seen_intro: true)
    end

    @answer = Answer.new
    # @user = current_user
    @user = User.find(params[:id])
    # @question = Question.find(params[:question_id])
    @question = current_user.unanswered_questions

    # @matches_hash = current_user.add_scores
    # @matches_hash = @matches_hash.sort_by { |id, score| score }.reverse
    @users = User.all
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

  def calculate_insight
    @user = User.find(params[:id])
    @user.get_insight
    redirect_to user_path(@user, tab: 'personality')
  end

  private

  def user_params
    params.require(:user).permit(:avatar)
  end
end
