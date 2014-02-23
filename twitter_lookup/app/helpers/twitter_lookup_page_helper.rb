require 'twitter'
module TwitterLookupPageHelper

client = Twitter::REST::Client.new do |config|
    config.consumer_key    = "YOUR_CONSUMER_KEY"
    config.consumer_secret = "YOUR_CONSUMER_SECRET"
end
end
