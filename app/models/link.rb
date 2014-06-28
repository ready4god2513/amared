class Link

  @@decoder = HTMLEntities.new
  attr_accessor :link

  def initialize(l)
    @link = l
  end

  def comments
    @comments ||= RedditKit.comments(@link)
  end

  def method_missing(method, *args, &block)
    @link.send(method, *args, &block)
  end

  def video?
    @link.media[:oembed][:type] == "video"
    rescue
      false
  end

  def picture?
    @link.url =~ /\.png|\.jpg|\.jpeg|\.gif/i
  end

  def thumbnail
    @link.media[:oembed][:thumbnail_url]
    rescue
      nil
  end

  def video_embed
    @@decoder.decode(@link.media[:oembed][:html])
  end

end