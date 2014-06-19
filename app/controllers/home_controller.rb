class HomeController < ApplicationController

  def index
    @account = RedditKit::Client.new 'morethanaprogrammer', 'losgatos'
    @sub = @account.subreddit params[:subreddit] || "pics"
    @output = @account.links(@sub, category: params[:sort] || "hot", limit: params[:limit] || 20, time: params[:time] || "all")
  end

end