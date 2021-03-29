require "selenium-webdriver"
require "nokogiri"
require "faraday"
require 'rest-client' 
require 'byebug'
require 'set'
driver = Selenium::WebDriver.for:firefox
driver.get "https://www.squet.ne.jp/mufg/s/login/"
element = driver.find_element(:xpath,'//*[@id="str_header"]/div/div/div/div/div/form/p[1]/label/input')
element.send_keys "s180851473-2"
element = driver.find_element(:xpath,'//*[@id="str_header"]/div/div/div/div/div/form/p[2]/label/input')
element.send_keys "m180851473"
element.submit
sleep 5
driver.execute_script( "window.open('https://www.squet.ne.jp/mufg/s/Z1CC10-020?id=joseikin')" )
sleep 5   
window = driver.window_handles[-1]
p window
driver.switch_to.window(window)
sleep 5
element = driver.find_element(:xpath,'/html/body/form/main/article/section[2]/div/div/ul/li[1]/a').click
condition_form = driver.find_element(:id,'condition');
industry_list = condition_form.find_element(:name,'IndustoryCode');
industry_options = industry_list.find_elements(:tag_name,'option')
industry_options[2].click

condition_types = condition_form.find_elements(:tag_name,'ul');

capital_codes = condition_types[0].find_elements(:tag_name,'li');
capital_codes[0].click

num_of_emp_codes= condition_types[1].find_elements(:tag_name,'li');
num_of_emp_codes[0].click

business_type_codes = condition_types[2].find_elements(:tag_name,'li');
business_type_codes[0].click

invest_ratio_codes = condition_types[3].find_elements(:tag_name,'li');
invest_ratio_codes[0].click

extablished_codes = condition_types[4].find_elements(:tag_name,'li');
extablished_codes[0].click

head_office_location = condition_form.find_element(:name,'AddressPrefCode');
cities = head_office_location.find_elements(:tag_name,'option')
cities[3].click

submit_button = driver.find_element(:xpath,'//*[@id="condition"]/p[2]/input');
submit_button.click
sleep 5
while true
    sleep 1
    element = driver.find_element(:tag_name,'body')
    html_doc = html_doc = Nokogiri::HTML(element.attribute("outerHTML")) 
    next_page_btn = html_doc.css('input.btn')
    p next_page_btn.length()
    if next_page_btn.length() > 0
        driver.find_element(:xpath,'//*[@id="condition"]/div[2]/div[1]/ul/li[2]/input').click
    else
        break
    end
    byebug
end

# list = html_doc.css('ul.list_detail').children.css('li')
# byebug
# list.each do |list_item|
#     p list_item.children.css('a').first['href']
#     p list_item.children.css('a').first.children.first.text
#     puts '\n'
# end 
$stdin.gets
