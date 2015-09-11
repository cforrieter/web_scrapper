class RedditScraper < Scraper

  #Returns an array of comment objects
  def parse_html_comments
    @nokogiri_doc.css('div.commentarea .entry').select{ |element| element.css('time.live-timestamp').text != ''}.map do |element|
      user = element.css('a:nth-child(2)').text  #=> username
      date = element.css('time.live-timestamp').text   #=> date
      message = element.css('div p').text #=> message
      Comment.new(user, date, message)
    end
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
