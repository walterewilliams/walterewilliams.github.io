# doc.css("#title").each do |title|
#  process_page(title.attributes['href'].value)
# end
# # /columnists/walterewilliams/2007/01/31/property_rights

# http://townhall.com/columnists/walterewilliams/2006/11/29/why_we_love_government/page/full

# title = doc.css("h1").text

# date = doc.css("span:nth-child(4)").text.gsub("1.6K671","")

# doc

require "nokogiri"
require "open-uri"

def format_date(date)
  date.strftime("%Y-%m-%d-")
end

def format_title(title)
  title.gsub(" ", "-").downcase
end

def markdown_title
  "#{@date}#{@title}.md"
end

def process_page(page)
  page.css("#title").each do |title|
    make_markdown(title.attributes['href'].value)
  end
end

def make_markdown(article_id)

  article = Nokogiri::HTML(open("http://townhall.com#{article_id}/page/full"))
  @page_date = article.css("span:nth-child(4)").text.gsub("1.6K671","")
  @date = format_date(Date.parse(@page_date))
  @article_title = article.css("h1").text.gsub(":","&#58;")
  @title = format_title(article.css("h1").text)
  @body = article.css(".article").text.gsub("googletag.cmd.push(function () { googletag.display('div-gpt-1415411598-1'); });\r\n","")
  @body = @body.gsub(/\r\n/, "\n\n")

  open("/Users/sean/wewio/_posts/"+markdown_title, 'w') do |f|
    f.puts "---"
    f.puts "layout: post"
    f.puts "title:  #{@article_title}"
    f.puts "excerpt:"
    f.puts "---"
    f.puts
    f.puts @body
  end
end

24.upto(40) do |page|
  current_page = Nokogiri::HTML(open("http://townhall.com/columnists/walterewilliams/page/#{page}"))
  process_page(current_page)
end