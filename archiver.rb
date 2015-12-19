require "nokogiri"
require "open-uri"

@most_recent_date = File.open('recent_date.txt', 'rb') { |file| file.read }

doc = Nokogiri::HTML(open("http://www.creators.com/opinion/walter-williams/archive.html"))

links = doc.css(".KonaBody a")
date = doc.css("b")

def format_date(date)
  nums = date.split("/")
  "#{nums[2]}-#{nums[0]}-#{nums[1]}-"
end

def format_title(title)
  title.gsub(" ", "-").downcase
end

def markdown_title
  "#{@date}#{@title}.md"
end



15.upto(467) do |number|
  @date = format_date(date[number].text)
  article = Nokogiri::HTML(open("http://www.creators.com/opinion/walter-williams/#{links[number].attributes['href'].value}"))
  @article_title = article.css("h1").text
  @title = format_title(article.css("h1").text)
  @body = article.css(".KonaBody").text
  @body = @body.gsub(/\n\n\n\n\nloadAdVals\(\"AD FEEDBACK\"\);\n/, "")
  @body = @body.gsub(/\n/, "\n\n")

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
