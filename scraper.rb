class Scraper
  attr_accessor :post

  class EmptyFile < StandardError; end
  class BadURL < StandardError; end

  def initialize(file)
    raise EmptyFile, "You need to enter a URL!" unless file
    @file = file
    @nokogiri_doc = get_html
    @post = parse_html_post
    print_statistics
  end

  def get_html
    html_scrape = Nokogiri::HTML(open(@file))
    raise BadURL, 'Page not found!' if html_scrape.text == 'No such item.' 
    return html_scrape
  end

  #Returns an array of contact objects
  def parse_html_comments
    arr = []
    @nokogiri_doc.css('.default') .each do |element|
      next if element.css('.comhead a:nth-child(2)').text == ''
      user = element.css('.comhead a:first-child').text  #=> username
      date = element.css('.comhead a:nth-child(2)').text   #=> date
      message = element.css('.comment').text.strip.gsub(/reply$/, '').gsub(/[\n -]*$/, '') #=> message
      arr << Comment.new(user, date, message)
    end
    return arr
  end

  def print_statistics
    puts "Name of post: #{@post.title}".colorize(:blue)
    puts "Post URL: #{@post.url}".colorize(:light_blue)
    puts "Number of comments: #{@post.num_of_comments}".colorize(:red)
    puts "User with most comments: #{@post.user_with_most_comments}".colorize(:cyan)
    puts "Longest comment: #{@post.longest_comment}".colorize(:magenta)
    puts "First 5 comments:"
    puts "#{@post.first_five_comments}"
    puts "Most recent 5 comments:"
    puts "#{@post.most_recent_comments}"
  end

  #Returns a post object with full comment array
  def parse_html_post  
  end

  def self.run(url)
    begin
      self.new(url)
    rescue EmptyFile => e
      puts e.message
      exit
    rescue BadURL => e
      puts e.message
      exit
    end  
  end
end
