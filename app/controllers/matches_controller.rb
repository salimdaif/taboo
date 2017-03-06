class MatchesController < ApplicationController
  def index
    @matches = User.all #for testing purposes
  end
end
