require 'open-uri'
require 'pry'
require 'nokogiri'

class Character
  
  def initialize
    html = Nokogiri::HTML(open('https://en.wikipedia.org/wiki/List_of_Game_of_Thrones_characters'))
    adjusted_html = html.xpath('//h2[1]/following-sibling::p') & html.xpath('//h2[2]/preceding-sibling::p')
    #adjusted_html = html.xpath('//h2/following-sibling::h2') & html.xpath('//h2[last]')
    #adjusted_html = html.xpath('//span[@id="Main_characters"]') & html.xpath('//span[@id="Main_characters"]/following-sibling::h2')
    #& html.xpath('//span[@id="Supporting_characters"]')
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