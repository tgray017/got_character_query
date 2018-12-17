require 'pry'

values = 
["Novel:",
"A Game of Thrones (1996)",
"Some other thing",
"Television:",
"Winter Is Coming (2011)",
"Another thing",
"One last thing",
"Video game:",
"The Lost Lords (2015)"]


values.each_with_index do |value, index|
  if value.split('').last == ':'
    subproperties = {}
    subproperty = value.delete(':').downcase.gsub(/\s+/, "_").to_sym
    subvalues = []
    
    counter = 1
    while counter + index < values.size && values[index + counter].split('').last != ':'
      subvalues << values[index + counter]
      counter += 1
    end
    subproperties[subproperty] = subvalues
  end
  binding.pry
end