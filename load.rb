# encoding: UTF-8
#
# coding: UTF-8
#
# -*- coding: UTF-8 -*-
#
require 'faraday'
require "rest_client"
require "nokogiri"
require 'byebug'
require "open-uri"
require 'uri'
require 'fileutils'

def analysis_html html
  doc = Nokogiri::HTML(html)
  results = doc.search(".result")
  count = results.count 

  for i in (0...count)
    div = results[i]
    title = div.search(".c-title").text
    url =  div.search(".c-title a")[0].attributes["href"].value
    info = div.search(".c-author").text.split "  "

    from = info[0]
    time_chinese = info[1]
    if info.count < 2
      
      info << info[0]
    end
    time = Time.new(* info[1].split(/\p{han}/))

    
    
    time = Time.now if info[1].include?("前")
    
    #return false if time < Time.at(Time.now.to_i - 3600*24*1)
    if time < Time.at(Time.now.to_i - 3600*24*3)
      return false
     
    end


    puts "类型：新闻"
    puts "来源: #{from}"
    puts "标题: #{title}"
    puts "链接: #{url}"
    puts "HAHA时间: #{info[1]}"
    puts ""
  end
  true
end

items = %w(李晨 阮经天 孙红雷)

puts "脚本运行于#{Time.now}"

items.each do |item|
  current = 0
  puts "#{item}"
    name = URI.encode(item)
    html = RestClient.get "http://news.baidu.com/ns?word=#{name}&sr=0&cl=2&rn=20&tn=news&ct=0&clk=sortbytime"
    sleep 1
    doc = Nokogiri::HTML(html)
    page = doc.search("#page a")
    while analysis_html(html)
      puts "现在是#{current +1}!!!"
      uri = "http://news.baidu.com" + page[current].attributes["href"].value
      current = current + 1 
      html = RestClient.get uri
      
    end

  puts "--------------"

end

#urls = ["http://news.baidu.com/ns?word=%E6%9D%8E%E6%99%A8&pn=180&cl=2&ct=0&tn=news&rn=20&ie=utf-8&bt=0&et=0","http://news.baidu.com/ns?word=%E6%9D%8E%E6%99%A8&pn=200&cl=2&ct=0&tn=news&rn=20&ie=utf-8&bt=0&et=0","http://news.baidu.com/ns?word=%E6%9D%8E%E6%99%A8&pn=220&cl=2&ct=0&tn=news&rn=20&ie=utf-8&bt=0&et=0"]
#
#urls.each do |item|
#  html = RestClient.get item
#  sleep 1
#  analysis_html(html)
#end






