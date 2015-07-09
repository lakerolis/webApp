require 'open-uri'
require 'nokogiri'

doc  = Nokogiri::HTML(open('http://www.tubegalore.com/Amateur%257CAmatuer%257CAmature-tube/5457-1/page0/rating/'))
link = doc.css("div.imgContainer a").map{|link| link['href']}
final_link_list = Array.new
link.each{|link|
  temp = "http://" <<link.split("http://")[1]
  unless link.include?("pornxs") || link.include?("pornhub")
    final_link_list.push (temp.split("?")[0])
  else
    final_link_list.push (temp.split("&")[0])
    end
}

puts final_link_list
puts final_link_list.size


