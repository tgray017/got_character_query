class GotCharacterQuery::CLI
  
  def call
    greeting
    menu
    goodbye
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
        when 2
          puts "Which house?"
          list_all_houses
        when 3
          puts "Which kingdom?"
          list_all_kingdoms
        when 4
        else
          puts "Invalid option. Enter 1, 2, 3 or 4."
      end
    end
  end
  
  def goodbye
    puts "And now your watch is ended. Goodbye."
  end
  
  
  def list_all_characters
    c = 1
    character_list = []
    Character.all.each {|char| character_list << char.name unless char.name.nil?}
    character_list = character_list.flatten.collect {|h| h.gsub("*", "")}
    character_list.uniq.sort.each do |character| 
      puts "#{c}. #{character}"
      c += 1
    end
  end
  
  def list_all_houses
    c = 1
    house_list = []
    Character.all.each {|char| house_list << char.family unless char.family.nil?}
    house_list = house_list.flatten.collect {|h| h.gsub("*", "")}
    house_list.uniq.sort.each do |house| 
      puts "#{c}. #{house}"
      c += 1
    end
  end
  
  def list_all_kingdoms
    c = 1
    kingdom_list = []
    Character.all.each {|char| kingdom_list << char.kingdom unless char.kingdom.nil?}
    kingdom_list = kingdom_list.flatten.collect {|h| h.gsub("*", "")}
    kingdom_list.uniq.sort.each do |kingdom| 
      puts "#{c}. #{kingdom}"
      c += 1
    end
  end
  
end