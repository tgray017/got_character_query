require_relative './version'
require_relative './character'
require 'pry'
#Remove these requires before submitting


class GotCharacterQuery::CLI
  
  def call
    Character.scrape_for_characters
    #greeting
    #menu
    #goodbye
  end
  
  def greeting
    puts "Welcome to GoT Character Query!"
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
          puts "Enter the number associated with the character that you're interested in."
          input = gets.strip.to_i
          character_name = sort_characters[input_to_index(input)]
          binding.pry
        when 2
          puts "Which house?"
          list_all_houses
          puts "Enter the number associated with the house that you're interested in."
        when 3
          puts "Which kingdom?"
          list_all_kingdoms
          puts "Enter the number associated with the kingdom that you're interested in."
        when 4
        else
          puts "Invalid option. Enter 1, 2, 3 or 4."
      end
    end
  end
  
  def goodbye
    puts "And now your watch is ended. Goodbye."
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
  
  
end

#Remove the below (just used for testing)
something = GotCharacterQuery::CLI.new
something.call
something.menu
