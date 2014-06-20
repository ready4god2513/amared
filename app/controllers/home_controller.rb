class HomeController < ApplicationController

  def index
    @sub = RedditKit.subreddit params[:subreddit] || "pics"
    @subs = RedditKit.subreddits(limit: 50).sort_by { |r| r.name }
    @output = RedditKit.links(@sub, category: params[:sort] || "hot", limit: params[:limit] || 20, time: params[:time] || "all")
  end

end