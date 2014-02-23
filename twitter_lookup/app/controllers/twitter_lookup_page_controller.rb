require 'open-uri'
require 'nokogiri'
class TwitterLookupPageController < ApplicationController
  
  def home
  end

  def search
      # Using Nokogiri as a web scraper, obtain the wiki page of
      # famous American actresses.
      page = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/List_of_American_film_actresses"))
      # Obtain the div-class tag for each group of actresses from A to Z.
      all_actress_names = page.css('div.div-col.columns.column-width a')
      # For each actress, extract their name.
      for actress_name in all_actress_names
          puts actress_name["title"]
      end
      # Twitter configuration
      # TODO Hash these keys
      client = Twitter::REST::Client.new do |config|
          config.consumer_key    = "f12zrbEPuW4bpYlS4S1wQ"
          config.consumer_secret = "KW4r8j5A7sTQq25RG5d66zv5npcwrVMl3SxqtaPqY"
      end
      # Twitter query for the last three tweets to @davidbeckhamweb
      client.search("to:davidbeckhamweb ",:result_type => "recent").take(3).each do |tweet|
          puts tweet.text
      end
      render "twitter_lookup_page/home"
  end

end
