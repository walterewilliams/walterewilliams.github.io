require "nokogiri"
require "open-uri"

@most_recent_date = File.open('recent_date.txt', 'rb') { |file| file.read }

doc = Nokogiri::HTML(open("http://www.creators.com/opinion/authors.html"))

tr:nth-child(27) :nth-child(6)
def format_date(date)
  date.strftime("%Y-%m-%d-")
end

def format_title(title)
  title.gsub(" ", "-").downcase
end

def markdown_title
  "#{@date}#{@title}.md"
end

@page_date = doc.at('.name:contains("Walter")').text.strip.gsub(/Walter E. WilliamsUpdated/, "")

if @most_recent_date != @page_date
  @date = format_date(Date.parse(@page_date))
  article = Nokogiri::HTML(open("http://www.creators.com/opinion/walter-williams.html"))
  @article_title = article.css("h1").text
  @title = format_title(article.css("h1").text)
  @body = article.css(".KonaBody").text
  @body = @body.gsub(/\n\n\n\n\nloadAdVals\(\"AD FEEDBACK\"\);\n/, "")
  @body = @body.gsub(/\n/, "\n\n")

  open("/home/sean/wewio/_posts/"+markdown_title, 'w') do |f|
    f.puts "---"
    f.puts "layout: post"
    f.puts "title:  #{@article_title}"
    f.puts "---"
    f.puts
    f.puts @body
  end

  open("recent_date.txt", 'w') do |f|
    f.print @page_date
  end
end