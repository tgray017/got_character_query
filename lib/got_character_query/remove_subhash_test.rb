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
  
  def scrape_character_properties(url)
    info_box = Nokogiri::HTML(open(url)).css('.infobox tbody tr')
    properties = {}
    
    info_box.each_with_index do |element, index|
      unless element.css('th[scope="row"]').empty?
        property = element.css('th[scope="row"]').text.downcase.gsub(/\s+/, "_").gsub("(", "").gsub(")", "").to_sym
        values = []
        testing = info_box[index].css('td').xpath('..//descendant-or-self::li|a | ..//descendant-or-self::td[not(*)]')
        testing.each do |value| 
          values << value.text
        end
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
    binding.pry

    properties.each do |k, v|
      self.class.send(:attr_accessor, k) unless self.class.instance_methods.include?(k)
      self.send("#{k}=", v)
      binding.pry
    end
    
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
  
  def self.list_all_characters
    c = 1
    char_list = self.all.sort_by {|char| char.name}
    char_list.each do |char| 
      puts "#{c}. #{char.name}"
      c += 1
    end
  end
  
  
  ## Need to append anything under novel, novels, television, video game, video games with a *, **, and *** respectively so that there are no subhashes
  ## Should this be stored in the hash itself, so that there are no subhashes in the property array?
  def self.list_all_houses
    c = 1
    house_list = []
    self.all.each {|char| house_list << char.family unless char.family.nil?}
    binding.pry
    house_list.sort.uniq.each do |house| 
      puts "#{c}. #{house}"
      c += 1
    end
  end
  
  def self.list_characters_by_kingdom(kingdom)
    
  end

  
  
  
  
end

Character.scrape_for_characters
# Character.list_all_houses
# binding.pry