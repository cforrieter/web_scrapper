require 'nokogiri'
require 'open-uri'
require 'colorize'
require 'pry'

require_relative 'post'
require_relative 'comment'
require_relative 'scraper'
require_relative 'hacker_news_scraper'
require_relative 'reddit_scraper'

class Application

  def self.run
    url = ARGV[0]
    domain = url.match(/(?:http)?s?(?::\/\/)?(?:www\.)?([^\/]*)\/.*/)[1]
    puts domain
    case domain
    when 'reddit.com'
      RedditScraper.run(url)
    when 'news.ycombinator.com'
      HackerNewsScraper.run(url)
    end
  end

end

Application.run