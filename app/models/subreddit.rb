class Subreddit

  attr_reader :options

  def initialize(sub)
    if sub.is_a? String
      @sub = RedditKit.subreddit(sub)
    else
      @sub = sub
    end
  end

  def links(options = {})
    @options = options
    @links ||= RedditKit.links(@sub, options.dup)
    options.merge!({ after: @links.after })
    @links.map { |l| Link.new(l) }
  end

  def method_missing(method, *args, &block)
    @sub.send(method, *args, &block)
  end

end