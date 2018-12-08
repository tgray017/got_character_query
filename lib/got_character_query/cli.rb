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
          list_characters
        when 2
          puts "Which house?"
          list_houses
        when 3
          puts "Which kingdom?"
          list_kingdoms
        when 4
        else
          puts "Invalid option. Enter 1, 2, 3 or 4."
      end
    end
  end
  
  def goodbye
    puts "And now your watch is ended. Goodbye."
  end
  
  def list_characters

  end
  
  def list_houses
    
  end
  
  def list_kingdoms
    
  end
  
end