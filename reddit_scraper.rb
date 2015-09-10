class RedditScraper < Scraper

  #Returns an array of contact objects
  def parse_html_comments
    arr = []
    @nokogiri_doc.css('div.commentarea .entry').each do |element|
      next if element.css('time.live-timestamp').text == ''
      user = element.css('a:nth-child(2)').text  #=> username
      date = element.css('time.live-timestamp').text   #=> date
      message = element.css('div p').text #=> message
      arr << Comment.new(user, date, message)
    end
    return arr
  end

  #Returns a post object with full comment array
  def parse_html_post
    title = @nokogiri_doc.css('.title .may-blank').text
    url = @nokogiri_doc.css('.title .may-blank').attr('href').text  #=> post URL
    id =  @nokogiri_doc.css('#shortlink-text').attr('value').text.match(/t\/(.*)$/)[1] #=> ID
    points = @nokogiri_doc.css('div.score.unvoted').text #=> points
  
    Post.new(title, url, points, id, parse_html_comments)    
  end
end
