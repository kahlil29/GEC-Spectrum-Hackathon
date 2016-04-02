require 'nokogiri'
require 'open-uri'
require 'sinatra'

def startFlipkart(product)
  if product.include?" "
		product.gsub!(" ","+")#replace ' ' with '+'
	end

  stars = Array.new
  subject1 = Array.new
  review1 = Array.new

	#opens the flipkart query url
	url = "http://www.flipkart.com/search?q=" + product #product entered in textbox is added to url
	doc = Nokogiri::HTML(open(url))# url is executed/loaded
	# if the data is displayed in 4 per columns
	if(doc.at_css(".unit-4") != nil)
		#puts "unit 4"
		hideId = "1"
		link = "http://www.flipkart.com" + doc.at_css(".unit-4 .pu-visual-section a")["href"]#fetch the link to product details
		#@image = doc.at_css(".unit-4 .pu-visual-section .fk-product-thumb img")["data-src"]
		productName = doc.at_css(".unit-4 .pu-details .pu-title").text.strip
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

		doc2 = Nokogiri::HTML(open(url))#visit the link on product site - show all reviews
		reviewNo = doc2.css(".fk-review-page .gu12 .helpful-review-container .fk-navigation .nav_bar_result_count").text

		if reviewNo.include?" items found. Showing upto 10 items per page."
			reviewNo.gsub!(" items found. Showing upto 10 items per page.","")
		end

		pageCnt = reviewNo.to_i / 10

		if reviewNo.to_i % 10 != 0
			pageCnt += 1
		end

		puts "#{pageCnt}"

		initLoop = 0

		while initLoop < pageCnt do
			url = link3 + "&type=all&sort=most_helpful&start=" + (initLoop*10).to_s
			doc = Nokogiri::HTML(open(url))#visit the link on product site - show all reviews
			rating1 = doc.css(".fk-review-page .review-left .helpful-review-container .review-list .fk-position-relative")#["title"]
			#puts rating1.length
			#puts rating1.at_css(".section1 .line .fk-stars")["title"]
			puts "Loop begin"
      inLoop = 0
			rating1.map do |ratex|
				#ratex = rate1.xpath(".fk-position-relative .section1 .line .fk-stars")["title"]
				stars[inLoop] = ratex.at_css(".section1 .line .fk-stars")["title"]	#fetch the value - 'ratings/stars' from "<div title=<value> class=".fk-stars"></div>

				if stars[inLoop].include?" stars"
					stars[inLoop].gsub!(" stars","")#replace '<space>stars' with ''
				elsif stars[inLoop].include?" star"
					stars[inLoop].gsub!(" star","")#replace '<space>star' with ''
				end

				puts stars[inLoop].to_s
				subject1[inLoop] = ratex.at_css(".section2 .fk-font-normal").text # fetch the text from the sub section - Subject
				puts subject1[inLoop].to_s
				review1[inLoop] = ratex.at_css(".section2  .bmargin10").text # fetch the text from the sub section - Review
				puts review1[inLoop].to_s
        inLoop += 1
				#insert_into_db(@productName,@subject1,@review1,@stars);
			end
			initLoop += 1
		end
    return productName, stars, subject1, review1
	elsif(doc.at_css(".unit-4") == nil && doc.at_css(".unit-3") != nil)		# if the data is displayed in 3 per columns
		#puts "unit 3"
		hideId = "1"
		link = "http://www.flipkart.com" + doc.at_css(".unit-3 .pu-visual-section a")["href"]
		#@image = doc.at_css(".unit-4 .pu-visual-section .fk-product-thumb img")["data-src"]
		productName = doc.at_css(".unit-3 .pu-details .pu-title").text.strip
		puts doc.at_css(".unit-3 .pu-details .pu-title").text.strip
		price = doc.at_css(".unit-3 .pu-details .pu-price .pu-final").text.strip
		target2 = doc.at_css(".unit-3 .pu-details .pu-price .pu-final").text.strip
		url = link
		doc = Nokogiri::HTML(open(url))
		link2 = "http://www.flipkart.com" +  doc.at_css(".reviewSection .reviewsList .helpfulReviews .reviewListBottom a")["href"]
		url = link2
		puts url.to_s
		doc = Nokogiri::HTML(open(url))#visit the link on product site - top reviews
		link3 = "http://www.flipkart.com" + doc.at_css(".fk-review-page .review-left .helpful-review-container .pp-top-reviews-wiki .fk-color-title a")["href"]
		url = link3
		puts url.to_s
		doc2 = Nokogiri::HTML(open(url))#visit the link on product site - show all reviews
		reviewNo = doc2.css(".fk-review-page .gu12 .helpful-review-container .fk-navigation .nav_bar_result_count").text  #reads the string containing total no of reviews

		if reviewNo.include?" items found. Showing upto 10 items per page."
			reviewNo.gsub!(" items found. Showing upto 10 items per page.","") # eliminate the extra string to get the no of reviews
		end

		pageCnt = reviewNo.to_i / 10	# each page contains 10 reviews, so TotalNoReviews / 10

		if reviewNo.to_i % 10 != 0
			pageCnt += 1
		end

		puts "#{pageCnt}"

		initLoop = 0

		while initLoop < pageCnt do
			puts "#{initLoop+1}"
			url = link3 + "&type=all&sort=most_helpful&start=" + (initLoop*10).to_s
			doc = Nokogiri::HTML(open(url))#visit the link on product site - show all reviews
			rating1 = doc.css(".fk-review-page .review-left .helpful-review-container .review-list .fk-position-relative")#["title"]
			puts "Loop begin"
      inLoop = 0
			rating1.map do |ratex|
				stars[inLoop] = ratex.at_css(".section1 .line .fk-stars")["title"]	#fetch the value - 'ratings/stars' from "<div title=<value> class=".fk-stars"></div>

				if stars[inLoop].include?" stars"
					stars[inLoop].gsub!(" stars","")#replace '<space>stars' with ''
				elsif stars[inLoop].include?" star"
					stars[inLoop].gsub!(" star","")#replace '<space>star' with ''
				end

				puts stars[inLoop].to_s
				subject1[inLoop] = ratex.at_css(".section2 .fk-font-normal").text # fetch the text from the sub section - Subject
				puts subject1[inLoop].to_s
				review1[inLoop] = ratex.at_css(".section2  .bmargin10").text # fetch the text from the sub section - Review
				puts review1[inLoop].to_s
        inLoop += 1
				#insert_into_db(@productName,@subject1,@review1,@stars);
			end
			initLoop += 1
		end
    return productName, stars, subject1, review1
	else		# if data is not in 3||4 per columns
		hideId = "0"
		target2 = "0"
		puts "no units"
	end
end
