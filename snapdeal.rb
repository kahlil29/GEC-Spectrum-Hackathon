require 'nokogiri'
require 'open-uri'
require 'sinatra'

def startSnapdeal(product, productName)

  if product.include?" "
		product.gsub!(" ","+")#replace ' ' with '+'
	end

  stars = Array.new
  subject1 = Array.new
  content1 = Array.new

  #for snapDeal products
	url = "http://www.snapdeal.com/search?keyword=" + product + "&sort=plrty" #product entered in textbox is added to url search by popularity
	doc = Nokogiri::HTML(open(url))# url is executed/loaded

	link1 = doc.at_css(".comp-right-wrapper .product-row .js-section .col-xs-6 .product-tuple-image a")["href"]
	url = link1
	doc = Nokogiri::HTML(open(url))

	reviewNo = doc.at_css("#defaultReviewsCard .sort span").text

	if reviewNo.include? "Displaying Reviews 1-10 of "
		reviewNo.gsub!("Displaying Reviews 1-10 of ", "")
	end

	pageCnt = reviewNo.to_i / 10

	if reviewNo.to_i % 10 != 0
		pageCnt += 1
	end

	#puts "#{pageCnt}"
	rating1 = doc.css("#defaultReviewsCard .reviewareain .commentreview .commentlist")
  inLoop = 0
	# for page-1
	rating1.map do |rates|
		stars[inLoop] = rates.css(".text .user-review .rating .active").length.to_s
		#puts "#{stars}"
		subject1[inLoop] = rates.at_css(".text .user-review .head").text
		#puts subject1.to_s
		content1[inLoop] = rates.at_css(".text .user-review p").text
		#puts content1.to_s
		#insert_into_db(@productName,subject1,content1,stars);
	end

	reviewLink = doc.css("#ReviewHeader .whitebx .reviewareain a").text
	initLoop = 2

	#from page 2 to n
	while initLoop < pageCnt do
		puts "page #{initLoop}"
		if reviewLink.include?"page=2&vsrc=rcnt"
			url = reviewLink.gsub("page=2&vsrc=rcnt","page="+initLoop.to_s+"&sortBy=HELPFUL") #replace the url temporary, & store in URL
		end

		doc = Nokogiri::HTML(open(url))
		rating2 = doc.css("#defaultReviewsCard .reviewareain .commentreview  .commentlist")

		rating2.map do |rates| #reads the reviews individually
      inLoop += 1
			stars[inLoop] = rates.css(".text .user-review .rating .active").length.to_s
			#puts "#{stars}"
			subject1[inLoop] = rates.at_css(".text .user-review .head").text
			#puts subject2.to_s

			content1[inLoop] = rates.at_css(".text .user-review p").text
			#puts content2.to_s
			#insert_into_db(@productName,subject2,content2,stars);
		end
		initLoop += 1
	end
  return productName, stars, subject1 ,content1
end
