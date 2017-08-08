require 'nokogiri'
require 'open-uri'
require 'pry'
require 'csv'

doc = Nokogiri::HTML(open("https://newyork.craigslist.org/search/pet"))

parsed = doc.css(".content").css(".result-row").each_with_index do |row, index|
  title = row.css(".hdrlnk").first.inner_text
  link = row.css("a").attribute("href").value
  posted_at = row.css("time").first.attributes["datetime"].value
  location = row.css(".result-hood").text.strip
  path = "http://newyork.craigslist.org"

  CSV.open("ny_pet_listings.csv", "a+") do |csv|
    csv << [title, path + location, link, posted_at]
  end

  delay_time = rand(10)
  sleep(delay_time)
  puts "#{index + 1}. #{title} #{location}"
  puts "URL:" + " " + path + "#{link}"
  puts "Posted at #{posted_at}"
  puts '-----------------------------------------------------'
end
