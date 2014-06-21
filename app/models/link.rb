class Link

  def initialize(l)
    @link = l
  end

  def comments
    @comments ||= RedditKit.comments(@link)
  end

  def method_missing(method, *args, &block)
    @link.send(method, *args, &block)
  end

end