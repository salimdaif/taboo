class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  skip_before_action :redirect_to_custom_path

  def home
  end

  def intro
  end
end
