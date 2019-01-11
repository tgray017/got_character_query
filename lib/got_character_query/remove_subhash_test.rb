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
              subproperty = v.delete(':').downcase
              
              while c1 <= index_array.last
                while (!index_array[c1 + 1].nil? && (i+c) > index_array[c1] && (i + c) < index_array[c1 + 1]) || (i == index_array.last && i + c < values.size)
                  if subproperty == "novel" || subproperty == "novels"
                    subvalues << values[i+c].split("").push("*").join
                  elsif subproperty == "television"
                    subvalues << values[i+c].split("").push("**").join
                  elsif subproperty == "video game"
                    subvalues << values[i+c].split("").push("***").join
                  else
                    subvalues << values[i+c]
                  end
                  c += 1
                end
                c1 += 1
              end
              property_array << subvalues
            end
            properties[property] = property_array.flatten
          end
        else
          properties[property] = values
        end
      end
    end

    properties.each do |k, v|
      self.class.send(:attr_accessor, k) unless self.class.instance_methods.include?(k)
      self.send("#{k}=", v)
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
    character_list = []
    self.all.each {|char| character_list << char.name unless char.name.nil?}
    character_list = character_list.flatten.collect {|h| h.gsub("*", "")}
    character_list.uniq.sort.each do |character| 
      puts "#{c}. #{character}"
      c += 1
    end
  end
  
  
  ## Need to append anything under novel, novels, television, video game, video games with a *, **, and *** respectively so that there are no subhashes
  ## Should this be stored in the hash itself, so that there are no subhashes in the property array?
  ## Technically need to account for the following subhash values:
  # => [:novel,
  #  :television,
  #  :novels,
  #  :video_game,
  #  :with_jaime,
  #  :with_robert,
  #  :foster_family]
  
  def self.list_all_houses
    c = 1
    house_list = []
    self.all.each {|char| house_list << char.family unless char.family.nil?}
    house_list = house_list.flatten.collect {|h| h.gsub("*", "")}
    house_list.uniq.sort.each do |house| 
      puts "#{c}. #{house}"
      c += 1
    end
  end
  
  def self.list_all_kingdoms
    c = 1
    kingdom_list = []
    self.all.each {|char| kingdom_list << char.kingdom unless char.kingdom.nil?}
    kingdom_list = kingdom_list.flatten.collect {|h| h.gsub("*", "")}
    kingdom_list.uniq.sort.each do |kingdom| 
      puts "#{c}. #{kingdom}"
      c += 1
    end
  end

  def self.list_characters_by_house(house)
    
  end
  
  def self.list_characters_by_kingdom(kingdom)
    
  end
  
  
  
end

Character.scrape_for_characters
Character.list_all_characters
binding.pry