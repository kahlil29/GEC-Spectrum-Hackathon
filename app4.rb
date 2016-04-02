at_exit {Reviews.delete_all}

require 'nokogiri'
require 'open-uri'
require 'sinatra'

require './amazon'

@@a = 0
@@below = 0
get '/' do
	erb :index	#load index.erb
end

post '/' do
	product = params[:search]
	dataF = startAmazon(product)
	puts "link: #{dataF}"
	erb :index
end
