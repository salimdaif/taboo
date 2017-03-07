class MatchesController < ApplicationController
  def index
    @scores_hash = current_user.calculate_scores
  end
end
