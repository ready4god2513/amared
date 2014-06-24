class CommentsController < ApplicationController

  def index
    RedditKit.sign_in 'morethanaprogrammer', 'losgatos'
    @sub = Subreddit.new(params[:subreddit] || "pics")
    @item = RedditKit.link "t3_#{params[:id]}"
    @comments = RedditKit.comments @item, sort: params[:sort] || "confidence"
  end

end