require_relative './version'
require_relative './character'
require 'pry'
#Remove these requires before submitting


class GotCharacterQuery::CLI
  attr_accessor :input, :house_name, :kingdom_name
  
  def call
    Character.scrape_for_characters
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
          char_name = sort_attribute("name")[input_to_index(input)]
          display_character_overview(char_name)
          self.input = nil
        when 2
          puts "Which family?"
          submenu_1("family")
          self.house_name = sort_attribute("family")[input_to_index(input)]
          submenu_2("family", house_name)
        when 3
          puts "Which kingdom?"
          submenu_1("kingdom")
          self.kingdom_name = sort_attribute("kingdom")[input_to_index(input)]
          submenu_2("kingdom", kingdom_name)
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
    puts "And now your watch is ended. Goodbye."
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
      puts "#{c}. #{a}"
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
    puts "#{overview[0]}"
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
      puts "#{c}. #{char_name}"
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
    char_name = sort_characters_by_attribute(attribute, selection)[input_to_index(input)]
    display_character_overview(char_name)
    self.input = nil
  end
  
end

#Remove the below (just used for testing)
something = GotCharacterQuery::CLI.new.call
#something.menu
