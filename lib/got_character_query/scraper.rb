class Scraper
   
   def self.scrape_for_characters
    html = Nokogiri::HTML(open('https://en.wikipedia.org/wiki/List_of_Game_of_Thrones_characters'))
    main_characters = html.xpath('//h2[span[@id="Main_characters"]]/following-sibling::node()[following-sibling::h2[span[@id="Supporting_characters"]]]')
    
    main_characters.each_with_index do |item, index|
      unless item.css('.mw-headline').empty?
        name = item.css('.mw-headline').text
        link_to_bio = "https://en.wikipedia.org#{main_characters[index + 4].css('a').first['href']}"
        overview = main_characters[index + 6].text
        Character.new(name, link_to_bio, overview)
      end
    end
  end
  
  def self.scrape_character_properties(character, url)
    info_box = Nokogiri::HTML(open(url)).css('.infobox tbody tr')
    properties = {}
    
    info_box.each_with_index do |element, index|
      unless element.css('th[scope="row"]').empty?
        property = element.css('th[scope="row"]').text.downcase.gsub(/\s+/, "_").gsub("(", "").gsub(")", "").to_sym
        values = []
        info_box[index].css('td').xpath('..//descendant-or-self::li|a | ..//descendant-or-self::td[not(*)]').each {|value| values << value.text}
        
        property_array = []
        index_array = []

        if values.any? {|value| value.split("").last == ":"}
          values.each_with_index {|v, i| index_array << i if v.split("").last == ":"}
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
      character.class.send(:attr_accessor, k) unless character.class.instance_methods.include?(k)
      character.send("#{k}=", v)
    end
    
  end
  
end