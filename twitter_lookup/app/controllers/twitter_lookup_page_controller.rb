require 'net/http'
require 'open-uri'
require 'nokogiri'
require 'mysql2'

class Lookup_Table < ActiveRecord::Base
    # Empty Class, represents model for
    # actress_lookup database,
    # lookup_tables table (plural for
    # RoR style)
end

class TwitterLookupPageController < ApplicationController
  
  def home
  end

  def load_db
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
      all_actress = page.css('div.div-col.columns.column-width a')
      
      # For each actress, extract their name.
      for actress in all_actress
          actress_name = actress["title"]
          puts actress_name
          # Search for accounts until twitter responses with
          # a 'TooManyRequests' exception then 15 minutes
          # Perform a user search on the name, limit to 10
          if not Lookup_Table.find_by actress_name: actress_name
              begin
                  accounts = client.user_search(actress_name, :count=>10)
              rescue Twitter::Error::TooManyRequests => error
                  puts "Waiting 15 minutes to access accounts from Twitter"
                  sleep(15*60)
                  retry
              end
              # Check if the query pulled results
              if accounts
                  found = false
                  for account in accounts
                      # Check if matching name and verified
                      if not found and \
                          account.verified and\
                          account.name == actress_name
                          # We found an account, save onto DB
                          puts "Found verified account: " + account.url
                          Lookup_Table.create(\
                                :actress_name => actress_name,\
                                :actress_twitter_url => account.url.to_s())
                          found = true
                      # Else, Check if matching name and
                      # has more than 10k followers
                      elsif not found and \
                          account.followers_count >= 10000 and \
                          account.name == actress_name
                          # We found an account, save onto DB
                          puts "Found over 10k followers account: " + account.url
                          Lookup_Table.create(\
                                :actress_name => actress_name,\
                                :actress_twitter_url => account.url.to_s())
                          found = true

                      end
                  end  
              end
          end
      end
      render "twitter_lookup_page/home"
  end

  def result
      # This helper function expects
      # an actress name to be sent through
      # the post request
      
      # Check if the user sent an input, just reload page.
      actress_name = params[:actress_name]
      if actress_name == "Enter actress name..." or \
          actress_name == ""
          render "twitter_lookup_page/home"
          return
      # Else, query for the actress name on the database
      else
          actress_details = Lookup_Table.find_by actress_name: actress_name
          if actress_details
              puts "Found '%s'" % actress_details.actress_name
              puts "Found twitter URL: %s" % actress_details.actress_twitter_url
              # Send the actress details to the result page
              @actress_name = actress_details.actress_name
              @actress_twitter_url = actress_details.actress_twitter_url
              render "twitter_lookup_page/result"
              return
          end
          puts "Did not find '%s'" % actress_name
      end
      render "twitter_lookup_page/home"
  end
end
