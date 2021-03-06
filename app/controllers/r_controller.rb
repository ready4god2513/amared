class RController < ApplicationController

  def show
    if params[:subreddit] == "all"
      RedditKit.sign_in ENV["REDDIT_USERNAME"], ENV["REDDIT_PASSWORD"]
      @links = RedditKit.links("all", params.dup)
      
      @sub = OpenStruct.new(name: "all", 
        attributes: { 
          subscribers: Random.new.rand(10000000)
        }, 
        options: params.merge({ after: @links.after })
      )

      @output = @links.map { |l| Link.new(l) }
    else
      @sub = Subreddit.new(params[:subreddit] || "pics")
      @output = @sub.links(params.dup)
    end

    filter_images if params[:images].present?

    respond_to do |format|
      format.html { render params[:stream].present? ? "stream" : "show" }
      format.json { render json: @output.to_json }
    end
  end

  private

  def filter_images
    @output.select!(&:picture?)
  end
  
end
