#at_exit {Reviews.delete_all}

require 'nokogiri'
require 'open-uri'
require 'sinatra'

require './flipkart'
require './snapdeal'

require 'sinatra/activerecord'
require 'sqlite3'
require 'sentimentalizer'

set :database, {adapter: "sqlite3", database: "ReviewsDb"}

class Reviews<ActiveRecord::Base

end
Sentimentalizer.setup
#b = Reviews.create(title:"Sample Review", product_name:"iphone?", review_content:"This is a generic review for an iphone. Product was shit but Flipkart packaging and delivery was 10/10",stars:"4")
#Reviews.delete_all
$sum_of_sentiments = 0

get '/' do
	erb :index	#load index.erb
end

post '/' do
	product = params[:search]

	dataF = startFlipkart(product)
	nSize = dataF[1].length
	#insert_into_db( productName, stars, subject, content);
	for i in 0..nSize-1
		puts dataF[0].to_s
		insert_into_db(dataF[0],dataF[1][i],dataF[2][i],dataF[3][i])
	end

	dataS = startSnapdeal(product,dataF[0])
	nSize = dataS[1].length
	#insert_into_db( productName, stars, subject, content);
	for i in 0..nSize-1
		insert_into_db(dataS[0],dataS[1][i],dataS[2][i],dataS[3][i])
	end
	avg_sentiment =  Reviews.average(:sentiment_score)
	puts avg_sentiment.class
	puts avg_sentiment

	x123 = Reviews.where(stars: [1,2,3])
	avg_sentiment_below4 = x123.average(:sentiment_score)
	puts avg_sentiment_below4

	erb :index
end

def insert_into_db(name, stars, title, review_content)
  #Sentimentalizer.setup
	puts review_content.class

  a = Sentimentalizer.analyze(review_content, true)
  x = a.split(",\"probability\":") #use split function to split the resulting hash and obtain only probability
  x2 = x[1].split(",")             #use split function to exclude remaining part
  senti_score = (x2[0].to_f)*100         #access probability and convert to float
  #puts $sum_of_sentiments.class
  $sum_of_sentiments = $sum_of_sentiments + senti_score
  Reviews.create(title:title,product_name:name,review_content:review_content,stars:stars, sentiment_score:senti_score)
end
