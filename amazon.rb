require 'nokogiri'
require 'open-uri'
require 'sinatra'

def startAmazon(product)
  if product.include?" " # product name
		product.gsub!(" ","+")#replace ' ' with '+'
	end

  stars = Array.new
  subject1 = Array.new
  review1 = Array.new

  #opens the amazon query url
	url = "http://www.amazon.in/s/ref=sr_st_relevanceblender?keywords=" + product + "&rh=i%3Aaps%2Ck%3A" + product+"&qid=1459533005&sort=relevanceblender"	#product entered in textbox is added to url
	doc = Nokogiri::HTML(open(url))# url is executed/loaded
	if(doc.css(".s-result-list-parent-container") != nil)
		link = doc.at_css(".s-result-list-parent-container .s-result-list .s-result-item .s-item-container .a-fixed-left-grid div .a-col-right .a-spacing-small a")["href"]
		link2 = doc.at_css(".s-result-list-parent-container .s-result-list .s-result-item .s-item-container .a-fixed-left-grid div .a-col-right div[3] .a-span7 .a-row a span").text.strip

    puts link
    if link2.include?" "
      link2.gsub!(" ","")
    end

    if link2.include?","
      link2.gsub!(",","")
    end

    if link2.include?"&nbsp;"
      link2.gsub!("&nbsp;","")
    end

    linkSite = link # link to product site

    puts link2 # cost

    cost  = link2 # cost of the product
    doc2 = Nokogiri::HTML(open(link))# url is executed/loaded
    if doc2.at_css(".a-container #customer-reviews_feature_div") != nil
      puts "page 2"
      link3 = doc2.at_css(".a-container #customer-reviews_feature_div #cm_cr_dpwidget #revMHLContainer #revF .a-spacing-large a")["href"]
      sent3 = doc2.at_css(".a-container #customer-reviews_feature_div #cm_cr_dpwidget #revMHLContainer #revF .a-spacing-large a").text.strip
      #puts "Link 3 : #{link3} ->>>>> #{sent3}...."

      if sent3.include? "customer reviews (newest first)"
        sent3.gsub("customer reviews (newest first)","")
      end

      if sent3.include? "See all "
        sent3.gsub!("See all ","")
      end

      if sent3.include? ','
        sent3.gsub!(',','')
      end

      pageCnt = sent3.to_i / 10

      #puts "#{sent3} ->>> #{pageCnt}"

      if sent3.to_i % 10 != 0
  			pageCnt += 1
  		end

      initLoop = 1

  		while initLoop < 3  do                            #supposed to be PageCnt
        puts "url page #{initLoop}"

        url = link3 + "/ref=cm_cr_arp_d_paging_btm_2?ie=UTF8&showViewpoints=1&sortBy=helpful&pageNumber=" + initLoop.to_s
        doc = Nokogiri::HTML(open(url))#visit the link on product site - show all reviews

        puts url
        if doc.at_css("#a-page") != nil
          rating1 = doc.css("#a-page .a-spacing-small .a-fixed-right-grid .a-fixed-right-grid-inner .a-col-left .reviews-content #cm_cr-review_list .a-section")#.text.strip
          inLoop = 0
          rating1.map do |ratex|
            stars[inLoop] = ratex.css(".a-row .a-link-normal i span").text   # star rate of the review
            subject1[inLoop] = ratex.css(".a-row .a-size-base").text      # Title of the review
            review1[inLoop] = ratex.css(".review-data span").text           # content of the review

            if stars[inLoop].include? "out of 5 stars|"
              stars[inLoop].gsub!("out of 5 stars|","")
            end

            if review1[inLoop].include? '\n'
              review1[inLoop].gsub!('\n','')
            end

            if review1[inLoop].include? "<br>"
              review1[inLoop].gsub!("<br>","")
            end

            puts stars[inLoop].to_s
            puts subject1[inLoop].to_s
            puts review1[inLoop].to_s
            #puts "#{star}"
            inLoop += 1
          end
          #puts rating1
        end

        initLoop +=  1
      #doc2 = Nokogiri::HTML(open(link4))# url is executed/loaded
    end
    end
	end
  return product, stars, subject1, review1, linkSite, cost
end
