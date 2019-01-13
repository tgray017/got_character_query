require_relative './version'
require_relative './character'
require 'pry'
#Remove these requires before submitting


class GotCharacterQuery::CLI
  
  def call
    Character.scrape_for_characters
    greeting
    menu
    goodbye
  end
  
  def menu
    input = nil
    while input != 4
      puts "Choose from the following options to learn more about your favorite GoT characters:"
      puts <<-HEREDOC  
        1. List all characters
        2. List characters by house
        3. List characters by kingdom
        4. Exit
        
      HEREDOC
      puts "Enter 1, 2, 3 or 4."
      
      input = gets.strip.to_i
      case input
        when 1
          puts "Listing all characters..."
          list_all_characters
          instruction("character")
          input = gets.strip.to_i
          while !input.integer? || !input.between?(1, sort_characters.size)
            invalid_option
            instruction("character")
            input = gets.strip.to_i
          end
          char_name = sort_characters[input_to_index(input)]
          display_character_overview(char_name)
        when 2
          puts "Which house?"
          list_all_houses
          instruction("house")
          input = gets.strip.to_i
          while !input.integer? || !input.between?(1, sort_houses.size)
            invalid_option
            instruction("house")
            input = gets.strip.to_i
          end
          house_name = sort_houses[input_to_index(input)]
          list_characters_by_house(house_name)
          instruction("character")
          input = gets.strip.to_i
          while !input.integer? || !input.between?(1, sort_characters_by_house(house_name).size)
            invalid_option
            instruction("character")
            input = gets.strip.to_i
          end
          char_name = sort_characters_by_house(house_name)[input_to_index(input)]
          display_character_overview(char_name)
        when 3
          puts "Which kingdom?"
          list_all_kingdoms
          instruction("kingdom")
          input = gets.strip.to_i
          while !input.integer? || !input.between?(1, sort_kingdoms.size)
            invalid_option
            instruction("kingdom")
            input = gets.strip.to_i
          end
          kingdom_name = sort_kingdoms[input_to_index(input)]
          list_characters_by_kingdom(kingdom_name)
          instruction("character")
          input = gets.strip.to_i
          while !input.integer? || !input.between?(1, sort_characters_by_kingdom(kingdom_name).size)
            invalid_option
            instruction("character")
            input = gets.strip.to_i
          end
          char_name = sort_characters_by_kingdom(kingdom_name)[input_to_index(input)]
          display_character_overview(char_name)
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
  
  def sort_characters
    list = []
    Character.all.each {|char| list << char.name unless char.name.nil?}
    list.flatten.collect {|h| h.gsub("*", "")}.uniq.sort
  end
  
  def sort_houses
    list = []
    Character.all.each {|char| list << char.family unless char.family.nil?}
    list.flatten.collect {|h| h.gsub("*", "")}.uniq.sort
  end
  
  def sort_kingdoms
    list = []
    Character.all.each {|char| list << char.kingdom unless char.kingdom.nil?}
    list.flatten.collect {|h| h.gsub("*", "")}.uniq.sort
  end

  def list_all_characters
    c = 1
    sort_characters.each do |character| 
      puts "#{c}. #{character}"
      c += 1
    end
  end
  
  def list_all_houses
    c = 1
    sort_houses.each do |house| 
      puts "#{c}. #{house}"
      c += 1
    end
  end
  
  def list_all_kingdoms
    c = 1
    sort_kingdoms.each do |kingdom| 
      puts "#{c}. #{kingdom}"
      c += 1
    end
  end

  def input_to_index(input)
    input - 1
  end
  
  def display_character_overview(char_name)
    overview = []
    Character.all.each {|c| overview << c.overview if c.name == char_name}
    puts "#{overview[0]}"
  end
  
  def list_characters_by_house(house_name)
    c = 1
    sort_characters_by_house(house_name).each do |char_name| 
      puts "#{c}. #{char_name}"
      c += 1
    end
  end
  
  def sort_characters_by_house(house_name)
    characters = []
    Character.all.each do |char|
      unless char.family.nil? 
        characters << char.name if char.family.include? house_name
      end
    end
    characters.sort
  end
  
  def list_characters_by_kingdom(kingdom_name)
    c = 1
    sort_characters_by_kingdom(kingdom_name).each do |char_name| 
      puts "#{c}. #{char_name}"
      c += 1
    end
  end
  
  def sort_characters_by_kingdom(kingdom_name)
    characters = []
    Character.all.each do |char|
      unless char.kingdom.nil? 
        characters << char.name if char.kingdom.include? kingdom_name
      end
    end
    characters.sort
  end
  
end

#Remove the below (just used for testing)
something = GotCharacterQuery::CLI.new
something.call
#something.menu
