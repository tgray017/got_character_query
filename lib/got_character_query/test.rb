require 'pry'


values = 
["A Game of Thrones (1996)",
"Some other thing:",
"Television",
"Winter Is Coming (2011)",
"Another thing",
"One last thing",
"Video game:",
"The Lost Lords (2015)",
"The Lost Lords (2016)",
"The Lost Lords (2017)",
"The Lost Lords (2018)",
"asdf fdffdf",
"The Lost Lords (2019)",
"The Lost Lords (2020)",
"The Lost Lords (2021)",
"The Lost Lords (2022)"]

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
    subproperties = {}
    subvalues = []
    if i < index_array.first
      property_array << v
    elsif index_array.include?(i)
      c1 = 0
      subproperty = v.delete(':').downcase.gsub(/\s+/, "_").gsub("(", "").gsub(")", "").to_sym
      
      while c1 <= index_array.last
        while (!index_array[c1 + 1].nil? && (i+c) > index_array[c1] && (i + c) < index_array[c1 + 1]) || (i == index_array.last && i + c < values.size)
          subvalues << values[i + c]
          c += 1
        end
        c1 += 1
      end
      subproperties[subproperty] = subvalues
      property_array << subproperties
    end
    properties[property] = property_array
  end
  binding.pry
end