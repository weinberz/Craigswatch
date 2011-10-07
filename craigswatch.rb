require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'
require 'rubygems'
require 'ruby-growl'

content = ""
open("http://portland.craigslist.org/ele/index.rss") do |s| content = s.read end
rss = RSS::Parser.parse(content, false)

results = []
resultsFile = File.open("/Users/exark/Code/clresults.txt", "r+")

n = Growl.new "127.0.0.1", "CLWatch", ["Craigslist"]

write = true

terms = /sansui|marantz|dahlquist|pioneer|klh|advent/i

rss.items.each {|entry|
  if entry.title =~ terms || entry.description =~ terms
    results << [entry.title, entry.link]
  end
}

results.each {|title, link|
 resultsFile.each {|line|
   if line.include?(link)
     results.delete([title, link])
   end
 } 
}

resultsFile.rewind
results.each {|title, link|
  resultsFile.puts(title + ": " + link)
  n.notify "Craigslist", title, link
}

resultsFile.close