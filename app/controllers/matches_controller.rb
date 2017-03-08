class MatchesController < ApplicationController
  def index
    @scores_hash = current_user.add_scores
  end
end
