require 'rubygems'
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome
driver.get "http://news.baidu.com"
driver.manage.add_cookie(:name => 'BAIDUPH', :value => 'tn=§rn=§ct=0')
element = driver.find_element :name => "ww"
element.send_keys "李晨"
element.submit

puts "Page title is #{driver.title}"

wait = Selenium::WebDriver::Wait.new(:timeout => 10)

puts "Page title is #{driver.title}"
#driver.quit
