require 'net/http'
require 'open-uri'
require 'nokogiri'
class TwitterLookupPageController < ApplicationController
  
  def home
  end

  def search
      
      # Twitter configuration
      # TODO Hash these keys
      client = Twitter::REST::Client.new do |config|
          config.consumer_key    = "f12zrbEPuW4bpYlS4S1wQ"
          config.consumer_secret = "KW4r8j5A7sTQq25RG5d66zv5npcwrVMl3SxqtaPqY"
          config.access_token    = "27405615-bONkUcMgVTVt1co9Vodusp0M1KpFNHNfK0alWT99v"
          config.access_token_secret = "mlPgHrF2eeSsNODf5nbc0w6vtOQ7LbN3ni50sqZQEsqKS"
      end

      # Using Nokogiri as a web scraper, obtain the wiki page of
      # famous American actresses.
      page = Nokogiri::HTML(open(\
        "http://en.wikipedia.org/wiki/List_of_American_film_actresses"))
      # Obtain the div-class tag for each group of actresses from A to Z.
      all_actress_names = page.css('div.div-col.columns.column-width a')
      # For each actress, extract their name.
      for actress_name in all_actress_names
          puts actress_name["title"]
      end
      # TODO Perform a lookup on the name
      uri = URI.parse("https://api.twitter.com/1.1/users/search.json?q=Twitter")
      response = Net::HTTP.get_response(uri)
      puts Net::HTTP.get_print(uri)

      #response = Net::HTTP.get_response("https://api.twitter.com/1.1/users/search.json","?q=Twitter%20API&page=1&count=3")
      #puts json_reponse.body

          # client.search("to:davidbeckhamweb ",:result_type => "recent").take(3).each do |tweet|
          # puts tweet.text
      render "twitter_lookup_page/home"
  end

end
