class MatchesController < ApplicationController
  def index
    @matches_hash = current_user.add_scores
    @matches_hash = @matches_hash.sort_by { |id, score| score }.reverse
    @user = User.all
  end
end
