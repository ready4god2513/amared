class RController < ApplicationController

  def show
    @sub = Subreddit.new(params[:subreddit] || "pics")
    @output = @sub.links(params.dup)
  end
  
end
