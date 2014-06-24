require "addressable/uri"

module ApplicationHelper

  def next_page_link(options)
    subreddit_path(options)
  end

  def domain_name(str)
    Addressable::URI.parse(str).host
  end

  def subs
    Rails.cache.fetch(:front_page_subs) do
      RedditKit.subreddits(limit: 10).sort_by { |r| r.name }.map { |s| Subreddit.new(s) }
    end
  end

  def title(page_title, meta_title = page_title, options = {})
    meta_title = meta_title.blank? ? page_title : meta_title
    content_for(:title, truncate(meta_title.gsub(/[^0-9A-Za-z--\/'\. ]/, ''), length: 75) + " on amared | reddit through a different lens")
    content_tag(:h1, page_title, options.merge!(class: "page-header"))
  end

  def markdownify(str)
    @markdown ||= markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    @markdown.render(str)
  end

end