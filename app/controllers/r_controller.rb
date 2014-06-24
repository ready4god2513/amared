class RController < ApplicationController

  def show
    @sub = Subreddit.new(params[:subreddit] || "pics")
    @subs = RedditKit.subreddits(limit: 50).sort_by { |r| r.name }.map { |s| Subreddit.new(s) }
    @output = @sub.links(params.dup)
  end
  
end
