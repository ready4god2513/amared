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

  def gfycat?
    @link.url =~ /gfycat\.com/i
  end

  def gfycat_embed
    "<iframe src='http://gfycat.com/ifr/#{@link.url.split("/").last}' frameborder='0' scrolling='no' width='100%' height='314' ></iframe>"
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