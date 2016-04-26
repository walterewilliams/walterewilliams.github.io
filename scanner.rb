require "nokogiri"
require "open-uri"

@most_recent_date = File.open('recent_date.txt', 'rb') { |file| file.read }

doc = Nokogiri::HTML(open("http://www.creators.com/read/walter-williams"))

def format_date(date)
  date.strftime("%Y-%m-%d-")
end

def format_title(title)
  title.gsub(" ", "-").downcase
end

def markdown_title
  if @title[-4,4] == "?.md"
    @title = @title.gsub("?.md",".md")
  end
  "#{@date}#{@title}.md"
end

@page_date = doc.css(".top").text
#.at('.name:contains("Walter")').text.strip.gsub(/Walter E. WilliamsUpdated/, "")

if @most_recent_date != @page_date
  @date = format_date(Date.parse(@page_date))
  article = Nokogiri::HTML(open("http://www.creators.com/read/walter-williams"))
  @article_title = article.css("h1").text
  @title = format_title(article.css("h1").text)
  @body = article.css("#article-content").text
  @body = @body.gsub("  ", "")
  @body = @body.gsub(/\n\n\n\n\n/, "\n")
  @body = @body.gsub(/\n/, "\n\n")

  @body = @body.slice(0..(@body.index(' visit the Creators Syndicate Web page at www.creators.com.')))
  @body = @body + "visit the Creators Syndicate Web page at www.creators.com."

  open("/home/sean/wewio/_posts/"+markdown_title, 'w') do |f|
    f.puts "---"
    f.puts "layout: post"
    f.puts "title:  #{@article_title}"
    f.puts "excerpt:"
    f.puts "---"
    f.puts
    f.puts @body
  end

  open("recent_date.txt", 'w') do |f|
    f.print @page_date
  end
end
