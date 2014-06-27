class SearchController < ApplicationController

  def index
    @query = params[:s]
    @links = RedditKit.search(@query, params.dup.merge({
      restrict_to_subreddit: false
    }))

    @output = @links.map { |i| Link.new(i) }
  end

  def domain
    @query = params[:d]
    @links = RedditKit.links_with_domain(@query, params[:sort], params.dup)
    @output = @links.map { |i| Link.new(i) }
  end

  def subs
    @output = (RedditKit.search_subreddits_by_name(params[:s]).map { |s| s } + RedditKit.subreddits_by_topic(params[:s]).map { |s| OpenStruct.new(name: s) }).sort_by { |s| s.name.titleize }
  end

end