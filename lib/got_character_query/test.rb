require 'pry'


values = 
["A Game of Thrones (1996):",
"Some other thing",
"Television",
"Winter Is Coming (2011):",
"Another thing",
"One last thing",
"Video game",
"The Lost Lords (2015)"]

properties = {}
property = :first_appearance
property_array = []
index_array = []

if values.any? {|value| value.split("").last == ":"}
  values.each_with_index do |v, i| 
    index_array << i if v.split("").last == ":"
  end
  
  values.each_with_index do |v, i|
    c = 1
    case
      # when there is 1 subproperty and its the first one in the values array (index == 0), add it as a subproperty and add everything below it as subvalues 
      # when there is 1 subproperty and it's not the first one in the values array (index == n), add everything above it as values to the property array, and add all values where the index is between n + 1 and values.size as subvalues to the subproperty where index == n
      # when there is > 1 subproperty, take the values between the indexes where v.split("").last == ":" evaluates to true and add them as subvalues to the previous index's value until you reach values.size for the last one
        # if the first index is not at position 0, add everything above it as a value to the property_array
      when index_array.size == 1 && index_array.include?(0)
        subproperties = {}
        subproperty = values[0].delete(':').downcase.gsub(/\s+/, "_").gsub("(", "").gsub(")", "").to_sym
        subvalues = []
        
        while i + c < values.size
          subvalues << values[i + c]
          c += 1
        end
        
        subproperties[subproperty] = subvalues
        property_array << subproperties
        properties[property] = property_array
      when index_array.size == 1 && !index_array.include?(0)
        subproperties = {}
        subvalues = []
        c2 = 0 
        while c2 < index_array.first
          property_array << values[c2]
          c2 += 1
        end
        index_array.each do |index|
          subproperty = values[index].delete(':').downcase.gsub(/\s+/, "_").gsub("(", "").gsub(")", "").to_sym
          while index + c < values.size
            subvalues << values[index + c]
            c += 1
          end
          subproperties[subproperty] = subvalues
          property_array << subproperties
        end
        properties[property] = property_array
        binding.pry

      when index_array.size >1 && index_array.include?(0)
        subproperties = {}
        subvalues = []
        
        #if the current value's index is included in the index array...
        if index_array.include?(i)
          c2 = 1
          
          #then the subproperty is the current value as a symbol...
          subproperty = v.delete(':').downcase.gsub(/\s+/, "_").gsub("(", "").gsub(")", "").to_sym
          
          #and while the next value's index is less than the next index in the index_array
          while (!index_array[i + 1].nil? && i + c2 < index_array[i + 1]) || (i == index_array.last && i + c2 < values.size)
            subvalues << values[i + c2]
            c2 += 1
          end
          subproperties[subproperty] = subvalues
          property_array << subproperties
        end
        properties[property] = property_array
        binding.pry
        
      when index_array.size >1 && !index_array.include?(0)
      
      end
    end
  end

  
  
  
  
  
#  values.each_with_index do |value, index|
#    if value.split('').last == ':'
#      subproperties = {}
#      subproperty = value.delete(':').downcase.gsub(/\s+/, "_").gsub("(", "").gsub(")", "").to_sym
#      subvalues = []
#      
#      counter = 1
#      while counter + index < values.size && values[index + counter].split('').last != ':'
#        subvalues << values[index + counter]
#        counter += 1
#      end
#      subproperties[subproperty] = subvalues
#      property_array << subproperties
#      properties[property] = property_array
#    elsif properties.values.last.instance_of?(Array) && properties.values.last.any? {|e| e.is_a?(Hash)} && properties.values.last.collect {|hash| hash.values}.flatten.include?(value)
#      # If the previous entry in the properties hash is an array of hashes and one of the hashes includes a value equal to the current value, do nothing so that the subproperty values aren't included as values in the level above
#    else
#      if values.size > 1
#        value_array = []
#        values.each {|value| value_array << value}
#        properties[property] = value_array
#      else
#        properties[property] = value
#      end
#    end
#    
#    binding.pry
#  end
#end