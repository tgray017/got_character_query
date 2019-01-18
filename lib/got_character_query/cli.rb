class GotCharacterQuery::CLI
  attr_accessor :input, :house_name, :kingdom_name, :char_name
  
  def call
    Scraper.scrape_for_characters
    greeting
    menu
    goodbye
  end
  
  def menu
    self.input = nil
    while input != 4
      puts "Choose from the following options to learn more about your favorite GoT characters:"
      puts <<-HEREDOC
        1. List all characters
        2. List characters by house
        3. List characters by kingdom
        4. Exit
        
      HEREDOC
      puts "Enter 1, 2, 3 or 4."
      
      self.input = gets.strip.to_i
      case input
        when 1
          puts "Listing all characters..."
          submenu_1("name")
          display_character_overview(char_name)
          display_character_properties(char_name)
          self.input = nil
        when 2
          puts "Which family?"
          submenu_1("family")
          self.house_name = sort_attribute("family")[input_to_index(input)]
          submenu_2("family", house_name)
          display_character_overview(char_name)
          display_character_properties(char_name)
          self.input = nil
        when 3
          puts "Which kingdom?"
          submenu_1("kingdom")
          self.kingdom_name = sort_attribute("kingdom")[input_to_index(input)]
          submenu_2("kingdom", kingdom_name)
          display_character_overview(char_name)
          display_character_properties(char_name)
          self.input = nil
        when 4
        else
          invalid_option
          puts "Enter 1, 2, 3 or 4."
      end
    end
  end
  
  def greeting
    puts "Welcome to GoT Character Query!"
  end
  
  def goodbye
    puts "And now your watch is ended. Goodbye.".light_blue
  end
  
  def instruction(selection)
    puts "Enter the number associated with the #{selection} that you're interested in."
  end
  
  def invalid_option
    puts "Invalid option."
  end

  def input_to_index(input)
    input - 1
  end

  def list_all_attributes(attribute)
    c = 1
    sort_attribute(attribute).each do |a| 
      puts "#{c}. #{a}".green
      c += 1
    end
  end
  
  def sort_attribute(attribute)
    list = []
    Character.all.each {|char| list << char.send(attribute) unless char.send(attribute).nil?}
    list.flatten.collect {|h| h.gsub("*", "")}.uniq.sort
  end
  
  def display_character_overview(char_name)
    overview = []
    Character.all.each {|c| overview << c.overview if c.name == char_name}
    puts "Overview:".red
    puts "#{overview[0]}".light_blue
  end
  
  def sort_characters_by_attribute(attribute, selection)
    characters = []
    Character.all.each do |char|
      unless char.send(attribute).nil? 
        characters << char.name if char.send(attribute).include? selection
      end
    end
    characters.sort
  end
  
  def list_characters_by_attribute(attribute, selection)
    c = 1
    sort_characters_by_attribute(attribute, selection).each do |char_name| 
      puts "#{c}. #{char_name}".green
      c += 1
    end
  end
  
  def submenu_1(selection)
    list_all_attributes(selection)
    instruction(selection)
    self.input = gets.strip.to_i
    while !input.between?(1, sort_attribute(selection).size)
      invalid_option
      instruction(selection)
      self.input = gets.strip.to_i
    end
    self.char_name = sort_attribute("name")[input_to_index(input)]
  end
  
  def submenu_2(attribute, selection)
    list_characters_by_attribute(attribute, selection)
    instruction("character")
    self.input = gets.strip.to_i
    while !input.between?(1, sort_characters_by_attribute(attribute, selection).size)
      invalid_option
      instruction("character")
      self.input = gets.strip.to_i
    end
    self.char_name = sort_characters_by_attribute(attribute, selection)[input_to_index(input)]
  end
  
  def display_character_properties(char_name)
    Character.all.each do |char|
      if char.name == char_name
        puts "Additional information:".red
        asterisk_legend = []
        char.class.instance_methods(false).each do |meth|
          unless meth == "link_to_bio".to_sym || meth == "overview".to_sym || meth == "name".to_sym || meth == "scrape_character_properties".to_sym || meth.to_s[-1] == "=" || char.send("#{meth}").nil?
            puts "#{meth.to_s.gsub("_", " ").capitalize}:".light_blue
            char.send("#{meth}").each do |val|
              puts "   #{val}".light_blue
              if val[-3..-1] == "***"
                message = "*** Indicates this property only applies to the video game."
                asterisk_legend << message unless asterisk_legend.include? message
              elsif val[-2..-1] == "**"
                message = "** Indicates this property only applies to the TV show."
                asterisk_legend << message unless asterisk_legend.include? message
              elsif val[-1] == "*"
                message = "* Indicates this property only applies to the novels."
                asterisk_legend << message unless asterisk_legend.include? message
              else
              end
            end
          end
        end
        unless asterisk_legend.empty?
          puts "\n"
          asterisk_legend.sort.each {|m| puts "#{m}".light_blue}
        end
        puts "\nMore information available at: #{char.link_to_bio}.\n".yellow
      end
    end
  end 
  
end