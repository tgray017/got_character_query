require 'open-uri'
require 'pry'
require 'nokogiri'

class Character
  attr_reader :name, :link_to_bio, :overview, :properties
  
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
  
  def scrape_character_properties(url)
    info_box = Nokogiri::HTML(open(url)).css('.infobox tbody tr')
    properties = {}
    
    info_box.each_with_index do |element, index|
      binding.pry
      unless element.xpath('.//th[@scope="row"]').empty?
        temp_property = element.xpath('.//th[@scope="row"]')
        temp_values = element.xpath('.//th[@scope="row"]//following-sibling::td')
        property = temp.text.downcase.gsub(/\s+/, "_").gsub("(", "").gsub(")", "").to_sym
        binding.pry
        values = []
        #binding.pry
        values = info_box[index].xpath('td').text.strip.split(/\n+/)
        #testing.each do |value| 
        #  values << value.text
        #end
        #changing from li to node() triples the values for some reason. Need to find a way for td's to be included for td's that are themselves the value. Not sure why the -or-self isn't accomplishing this
        #need to find a way to include some td values, (e.g. Successor > Robb Stark)
        
        property_array = []
        index_array = []

        if values.any? {|value| value.split("").last == ":"}
          values.each_with_index do |v, i| 
            index_array << i if v.split("").last == ":"
          end
          
          values.each_with_index do |v, i|
            c = 1
            subproperties = {}
            subvalues = []
            if i < index_array.first
              property_array << v
            elsif index_array.include?(i)
              c1 = 0
              subproperty = v.delete(':').downcase.gsub(/\s+/, "_").gsub("(", "").gsub(")", "").to_sym
              
              while c1 <= index_array.last
                while (!index_array[c1 + 1].nil? && (i+c) > index_array[c1] && (i + c) < index_array[c1 + 1]) || (i == index_array.last && i + c < values.size)
                  subvalues << values[i + c]
                  c += 1
                end
                c1 += 1
              end
              subproperties[subproperty] = subvalues
              property_array << subproperties
            end
            properties[property] = property_array
          end
        else
          properties[property] = values
        end
      end
    end
    #binding.pry
  end
  
  
  
  def initialize(name, link_to_bio = "N/A", overview)
    @name = name
    @link_to_bio = link_to_bio
    
    unless link_to_bio == "N/A"
      scrape_character_properties(link_to_bio)
    end
    
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
# binding.pry