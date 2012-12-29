helpers do

  def markdown(text)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(text)
  end

  def seo_title(text)
    text.downcase.gsub(/[^a-z0-9]+/i, '-')
  end

  def truncate(text, post_url, max_length)
    address = "...<a href='/show/#{post_url}'>[show full post]</a>"
    text.length > max_length ? text[0..max_length] + address : text
  end

end