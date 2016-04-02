require 'sentimentalizer'
require 'sinatra/activerecord'
require 'sqlite3'
require 'sinatra'

set :database, {adapter: "sqlite3", database: "ReviewsDb"}

class Reviews<ActiveRecord::Base

end

def startSearch
  heating_count = 0
  camera_count = 0
  display_count = 0
  memory_count = 0

  Sentimentalizer.setup

  Reviews.all.each do |user|
    review_string = user.review_content
    #review_string = "This is a test string with  Heating is an issues. The camera on my phone is very good. The phones display also could not be better. The memory however is excellent"

    rev = review_string.downcase
    x = rev.split(" ")
    a = (x.index("heating") || x.index("heat") || x.index("heated") || x.index("overheating"))
    #puts a
    if a
  	   if(x[a-1] != "not" && x[a-1] != "no" && x[a-1] != "doesn't")
  		     heating_count += 1
         end
    end
  #puts heating_count
  			#Set up sentimentalizer

      rev_analyzed = review_string.downcase		#rev_analyzer contains the review string in lowercase
      split_string = rev_analyzed.split(".")					#Splits the review string ('.' as the splitting parameter)

  #camera module
  camera_substring = split_string.index{|s| s.include?("camera")}
  if camera_substring!=nil
  #puts "camera substring is #{camera_substring}"
  #puts "The camera substring index is #{split_string[camera_substring]}"

  camera_senti_analyzer = Sentimentalizer.analyze(split_string[camera_substring], true)
  x = camera_senti_analyzer.split(",\"probability\":") #use split function to split the resulting hash and obtain only probability
  x2 = x[1].split(",")             #use split function to exclude remaining part
  senti_score = (x2[0].to_f)*100        #access probability and convert to float
  #puts "Camera senti score is: #{senti_score}"

  if senti_score<50
  	camera_count +=1
  end
end
  #puts "Camera count is: #{camera_count}"






  #display module
  display_substring = split_string.index{|s| s.include?("display")}
  if display_substring != nil
  	#puts "display substring is: #{display_substring}"
  	#puts "display substring index is: #{split_string[display_substring]}"



  display_senti_analyzer = Sentimentalizer.analyze(split_string[display_substring], true)
  x = display_senti_analyzer.split(",\"probability\":")
  x2 = x[1].split(",")
  senti_score = (x2[0].to_f)*100
  #puts "Display senti score is: #{senti_score}"

  if senti_score<50
  	display_count += 1
  end
  end
  #puts "Display count is: #{display_count}"






  #memory module
  memory_substring = split_string.index{|s| s.include?("memory")}
  if memory_substring!=nil
  #puts "Memory substring is: #{memory_substring}"
  #puts "Memory substring index is: #{split_string[memory_substring]}"


  memory_senti_analyzer = Sentimentalizer.analyze(split_string[memory_substring], true)
  x = memory_senti_analyzer.split(",\"probability\":")
  x2 = x[1].split(",")
  senti_score = (x2[0].to_f)*100
  #puts "Memory senti score is #{senti_score}"

  if senti_score<50
  	memory_count += 1
  end
  end
  #puts "Memory count is: #{memory_count}"


  end

  puts "Heating count is: #{heating_count}"
  puts "Camera count is: #{camera_count}"
  puts "Display count is: #{display_count}"
  puts "Memory count is: #{memory_count}"

  return heating_count, camera_count, display_count, memory_count
end
