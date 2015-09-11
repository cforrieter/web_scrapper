class HackerNewsScraper < Scraper

  #Returns an array of contact objects
  def parse_html_comments
    @nokogiri_doc.css('.default').select{ |element| element.css('.comhead a:nth-child(2)').text != '' }.map do |element|
      user = element.css('.comhead a:first-child').text  #=> username
      date = element.css('.comhead a:nth-child(2)').text   #=> date
      message = element.css('.comment').text.strip.gsub(/reply$/, '').gsub(/[\n -]*$/, '') #=> message
      Comment.new(user, date, message)
    end
  end

  #Returns a post object with full comment array
  def parse_html_post
    title = @nokogiri_doc.css('.title a').text
    url = @nokogiri_doc.css('.title a').attr('href').text  #=> post URL
    id =  @nokogiri_doc.css('.subtext a:nth-child(4)').attr('href').text.gsub(/\D*/, '') #=> ID
    points = @nokogiri_doc.css('.subtext .score').text #=> points
  
    Post.new(title, url, points, id, parse_html_comments)    
  end

end
