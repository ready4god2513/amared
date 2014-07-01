class RController < ApplicationController

  def show
    if params[:subreddit] == "all"
      RedditKit.sign_in 'morethanaprogrammer', 'losgatos'
      @links = RedditKit.links("all", params.dup)
      @output = @links.map { |l| Link.new(l) }
    else
      @sub = Subreddit.new(params[:subreddit] || "pics")
      @output = @sub.links(params.dup)
    end
  end
  
end
