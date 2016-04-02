require 'nokogiri'
require 'open-uri'
require 'sinatra'

get '/' do
	erb :index	#load index.erb
end

post '/' do
	product = params[:search]

	if product.include?" "
		product.gsub!(" ","+")#replace ' ' with '+'
	end

	#opens the flipkart query url
	url = "http://www.flipkart.com/search?q=" + product #product entered in textbox is added to url
	doc = Nokogiri::HTML(open(url))# url is executed/loaded
	# if the data is displayed in 4 per columns
	if(doc.at_css(".unit-4") != nil)
		#puts "unit 4"
		hideId = "1"
		link = "http://www.flipkart.com" + doc.at_css(".unit-4 .pu-visual-section a")["href"]#fetch the link to product details
		#@image = doc.at_css(".unit-4 .pu-visual-section .fk-product-thumb img")["data-src"]
		@productName = doc.at_css(".unit-4 .pu-details .pu-title").text.strip
		puts doc.at_css(".unit-4 .pu-details .pu-title").text.strip
		price = doc.at_css(".unit-4 .pu-details .pu-price .pu-final").text.strip
		target2 = doc.at_css(".unit-4 .pu-details .pu-price .pu-final").text.strip
		url = link
		puts url.to_s
		doc = Nokogiri::HTML(open(url))#visit the 1st product's site
		link2 = "http://www.flipkart.com" +  doc.at_css(".reviewSection .reviewsList .helpfulReviews .reviewListBottom a")["href"]
		url = link2
		puts url.to_s
		doc = Nokogiri::HTML(open(url))#visit the link on product site - top reviews
		link3 = "http://www.flipkart.com" + doc.at_css(".fk-review-page .review-left .helpful-review-container .pp-top-reviews-wiki .fk-color-title a")["href"]
		url = link3
		puts url.to_s
		doc = Nokogiri::HTML(open(url))#visit the link on product site - show all reviews
		rating1 = doc.css(".fk-review-page .review-left .helpful-review-container .review-list .fk-position-relative")#["title"]
		#puts rating1.length
		#puts rating1.at_css(".section1 .line .fk-stars")["title"]
		rating1.map do |ratex|
			#ratex = rate1.xpath(".fk-position-relative .section1 .line .fk-stars")["title"]
			@stars = ratex.at_css(".section1 .line .fk-stars")["title"]	#fetch the value - 'ratings/stars' from "<div title=<value> class=".fk-stars"></div>

			if @stars.include?" stars"
				@stars.gsub!(" stars","")#replace '<space>stars' with ''
			elsif @stars.include?" star"
				@stars.gsub!(" star","")#replace '<space>star' with ''
			end

			puts @stars.to_s
			@subject1 = ratex.at_css(".section2 .fk-font-normal").text # fetch the text from the sub section - Subject
			puts @subject1.to_s
			@review1 = ratex.at_css(".section2  .bmargin10").text # fetch the text from the sub section - Review
			puts @review1.to_s
		end
		#heading1 = doc.at_css(".fk-review-page .review-left .helpful-review-container .review-list .fk-position-relative .section2 .fk-font-normal").text
		#puts heading1.to_s
		#content1 = doc.at_css(".fk-review-page .review-left .helpful-review-container .review-list .fk-position-relative .section2 .bmargin10").text
		#puts content1.to_s



	elsif(doc.at_css(".unit-4") == nil && doc.at_css(".unit-3") != nil)		# if the data is displayed in 3 per columns
		#puts "unit 3"
		hideId = "1"
		link = "http://www.flipkart.com" + doc.at_css(".unit-3 .pu-visual-section a")["href"]
		#@image = doc.at_css(".unit-4 .pu-visual-section .fk-product-thumb img")["data-src"]
		@productName = doc.at_css(".unit-3 .pu-details .pu-title").text.strip
		puts doc.at_css(".unit-3 .pu-details .pu-title").text.strip
		price = doc.at_css(".unit-3 .pu-details .pu-price .pu-final").text.strip
		target2 = doc.at_css(".unit-3 .pu-details .pu-price .pu-final").text.strip
		url = link
		doc = Nokogiri::HTML(open(url)) # visit product detail info page
		link2 = "http://www.flipkart.com" +  doc.at_css(".reviewSection .reviewsList .helpfulReviews .reviewListBottom a")["href"]
		url = link2
		puts url.to_s
		doc = Nokogiri::HTML(open(url))#visit the link on product site - top reviews
		link3 = "http://www.flipkart.com" + doc.at_css(".fk-review-page .review-left .helpful-review-container .pp-top-reviews-wiki .fk-color-title a")["href"]
		url = link3
		puts url.to_s
		doc = Nokogiri::HTML(open(url))#visit the link on product site - show all reviews
		rating1 = doc.css(".fk-review-page .review-left .helpful-review-container .review-list .fk-position-relative")#["title"]
		#puts rating1.length
		#puts rating1.at_css(".section1 .line .fk-stars")["title"]
		rating1.map do |ratex|
			#ratex = rate1.xpath(".fk-position-relative .section1 .line .fk-stars")["title"]
			@stars = ratex.at_css(".section1 .line .fk-stars")["title"]	#fetch the value - 'ratings/stars' from "<div title=<value> class=".fk-stars"></div>

			if @stars.include?" stars"
				@stars.gsub!(" stars","")#replace '<space>stars' with ''
			elsif @stars.include?" star"
				@stars.gsub!(" star","")#replace '<space>star' with ''
			end

			puts @stars.to_s
			@subject1 = ratex.at_css(".section2 .fk-font-normal").text # fetch the text from the sub section - Subject
			puts @subject1.to_s
			@review1 = ratex.at_css(".section2  .bmargin10").text # fetch the text from the sub section - Review
			puts @review1.to_s
		end

	else		# if data is not in 3||4 per columns
		hideId = "0"
		target2 = "0"
		puts "no units"
	end
	erb :index
end
