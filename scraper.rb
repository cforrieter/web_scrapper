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

  def self.run(url)
    begin
      self.new(url)
    rescue EmptyFile => e
      puts e.message
      exit
    rescue OpenURI::HTTPError => e
      puts "404 error, page wasn't found!"
      exit
    rescue BadURL => e
      puts e.message
      exit
    end  
  end
end
