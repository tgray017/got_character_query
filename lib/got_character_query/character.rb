require 'open-uri'
require 'pry'
require 'nokogiri'

class Character
  attr_reader :name, :link_to_bio, :overview
  
  @@all = []
  
  def self.all
    @@all
  end
  
  def self.scrape_for_characters
    html = Nokogiri::HTML(open('https://en.wikipedia.org/wiki/List_of_Game_of_Thrones_characters'))
    main_characters = html.xpath('//h2[span[@id="Main_characters"]]/following-sibling::node()[following-sibling::h2[span[@id="Supporting_characters"]]]')
    
    main_characters.each_with_index do |item, index|
      unless item.css('.mw-headline').empty?
        name = item.css('.mw-headline').text
        link_to_bio = "https://en.wikipedia.org#{main_characters[index + 4].css('a').first['href']}"
        overview = main_characters[index + 6].text
        self.new(name, link_to_bio, overview)
      end
    end
  end
  
  
  def initialize(name, link_to_bio = "N/A", overview)
    @name = name
    @link_to_bio = link_to_bio
    @overview = overview
    @@all << self
  end
  
  
  def characters
    
  end
  
  def houses
    
  end
  
  def kingdoms
    
  end
  
  
  
  
end

Character.scrape_for_characters
binding.pry
Character.all