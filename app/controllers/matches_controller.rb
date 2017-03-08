class MatchesController < ApplicationController
  def index
    # @scores_hash = current_user.add_scores
    @user = User.all
  end
end
