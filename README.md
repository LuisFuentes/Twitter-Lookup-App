Famous Actress Twitter Lookup Application
=========================================

Description
-----------------------------------------

This Ruby on Rails application shall allow the user
to look up any famous actress's first name and last
name, checking if there a vertified twitter account
for the actress.


How to use app
==========================================

The URL for the application is `localhost:3000/twitter_lookup_page`.  

To visit the home page, go to `localhost:3000/twitter_lookup_page/home`.  
To query the database for a famous actress, enter the actresses name and hit `Search`.  
If a actress is found, the app shall direct you to the results page.  
To load the database with all actresses from Wikipedia's Famous American Actresses page,
go to `localhost:3000/twitter_lookup_page/load_db`. Please note, this load may take a while
due to twitter's restriction on the number of queries executed in a fixed amount of time.
