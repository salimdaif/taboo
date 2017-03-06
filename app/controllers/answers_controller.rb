class AnswersController < ApplicationController
  skip_before_action :redirect_to_questions, only: :create

  def new
  end

  def create
    @answer = Answer.new(answer_params)
    question = Question.find(params[:question_id])
    @answer.user = current_user


    if @answer.save
      @question = current_user.unanswered_questions

      respond_to do |format|
        format.html { redirect_to user_path(current_user) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'users/show' }
        format.js
      end
    end
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.update(answer_params)
      redirect_to answers_path
    else
      render :edit
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:content, :question_id)
  end
end
