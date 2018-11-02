require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    site = Nokogiri::HTML(html)
    student = site.css(".student-card")
    
    array = []
      
    student.each do |human|
      name = human.css(".card-text-container .student-name").text
      location = human.css(".card-text-container .student-location").text
      url = human.at("a")['href']
      
      collection = {}
      
      collection[:name] = name
      collection[:location] = location
      collection[:profile_url] = url
      
      array.push(collection)
    end
    
    array
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    site = Nokogiri::HTML(html)
    profile_links = site.css(".social-icon-container a")

    collection = {}

    profile_links.each do |social|
      url = social.attr('href')
      
      if url.include?("twitter")
        collection[:twitter] = url
      elsif url.include?("linkedin")
        collection[:linkedin] = url
      elsif url.include?("github")
        collection[:github] = url
      else
        collection[:blog] = url
      end
    end

    collection[:profile_quote] = site.css(".profile-quote").text
    collection[:bio] = site.css(".bio-block .description-holder p").text
  
    collection
  end

end

