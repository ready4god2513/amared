class CommentsController < ApplicationController

  def index
    RedditKit.sign_in ENV["REDDIT_USERNAME"], ENV["REDDIT_PASSWORD"]
    @sub = Subreddit.new(params[:subreddit] || "pics")
    @item = Link.new(RedditKit.link "t3_#{params[:id].gsub(/t3_/, "")}")
    @comments = RedditKit.comments @item.link, sort: params[:sort] || "confidence"
  end

  def stream
    RedditKit.sign_in ENV["REDDIT_USERNAME"], ENV["REDDIT_PASSWORD"]
    @sub = Subreddit.new(params[:subreddit] || "pics") unless params[:subreddit] == "all"
    @comments = RedditKit.recent_comments(params[:subreddit], params.dup)

    respond_to do |format|
      format.html { }
      format.json { render json: @comments.to_json }
    end
  end

end