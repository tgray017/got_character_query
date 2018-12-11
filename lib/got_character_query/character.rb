require 'open-uri'
require 'pry'
require 'nokogiri'

class Character
  attr_reader :name
  
  def scrape_for_characters
    html = Nokogiri::HTML(open('https://en.wikipedia.org/wiki/List_of_Game_of_Thrones_characters'))
    main_characters = html.xpath('//h2[span[@id="Main_characters"]]/following-sibling::node()[following-sibling::h2[span[@id="Supporting_characters"]]]')
    
    
    
    main_characters.each do |x|
      @name = x.css('.mw-headline').text
      @link_to_bio = x.css(".hatnote.navigation-not-searchable")
      
      binding.pry
    end
      
    
    
    #main_characters.each {|thing| puts thing.text}

  end
  
  
  def initialize
    
    

  end
  
  def characters
    
  end
  
  def houses
    
  end
  
  def kingdoms
    
  end
  
  
  
  
end

Character.new.scrape_for_characters