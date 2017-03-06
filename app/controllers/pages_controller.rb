class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  skip_before_action :redirect_to_questions, only: :home

  def home
  end
end
