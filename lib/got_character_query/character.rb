require 'open-uri'
require 'pry'
require 'nokogiri'

class Character
  
  def initialize
    html = Nokogiri::HTML(open('https://en.wikipedia.org/wiki/List_of_Game_of_Thrones_characters'))
    adjusted_html3 = html.xpath('//h2[span[@id="Main_characters"]]/following-sibling::node()[following-sibling::h2[span[@id="Supporting_characters"]]]')
    
    #adjusted_html3.each {|thing| puts thing.text}
    binding.pry
  end
  
  def characters
    
  end
  
  def houses
    
  end
  
  def kingdoms
    
  end
  
  
  
  
end

Character.new