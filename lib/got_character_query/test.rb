require 'pry'


values = 
["A Game of Thrones (1996)",
"Some other thing",
"Television",
"Winter Is Coming (2011):",
"Another thing",
"One last thing",
"Video game:",
"The Lost Lords (2015)",
"The Lost Lords (2016)",
"The Lost Lords (2017)",
"The Lost Lords (2018)",
"asdf fdffdf:",
"The Lost Lords (2015)",
"The Lost Lords (2016)",
"The Lost Lords (2017)",
"The Lost Lords (2018)"]

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
        if index_array.include?(i)
          c1 = 0
          subproperty = v.delete(':').downcase.gsub(/\s+/, "_").gsub("(", "").gsub(")", "").to_sym
          
          while c1 <= index_array.last
            while (!index_array[c1+1].nil? && (i+c) > index_array[c1] && (i+c) < index_array[c1+1]) || (i == index_array.last && i + c < values.size)
              subvalues << values[i+c]
              c += 1
            end
            c1 += 1
          end
          subproperties[subproperty] = subvalues
          property_array << subproperties
        end
        properties[property] = property_array
        binding.pry
        
      when index_array.size >1 && !index_array.include?(0)
        subproperties = {}
        subvalues = []
        if i < index_array.first
          property_array << v
        elsif index_array.include?(i)
          c1 = 0
          subproperty = v.delete(':').downcase.gsub(/\s+/, "_").gsub("(", "").gsub(")", "").to_sym
          
          while c1 <= index_array.last
            while (!index_array[c1+1].nil? && (i+c) > index_array[c1] && (i+c) < index_array[c1+1]) || (i == index_array.last && i + c < values.size)
              subvalues << values[i+c]
              c += 1
            end
            c1 += 1
          end
          subproperties[subproperty] = subvalues
          property_array << subproperties
        end
        properties[property] = property_array
        binding.pry
      end
    end
  end