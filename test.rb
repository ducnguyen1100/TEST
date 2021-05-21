require "selenium-webdriver"
require "nokogiri"
require 'byebug'
require 'mysql2'
require 'digest'
require 'redis'

@db_host  = "localhost"
@db_user  = "root"
@db_pass  = "duc123456"
@db_name = "hojokin"

client = Mysql2::Client.new(:host => @db_host, :username => @db_user, :password => @db_pass, :database => @db_name)
redis = Redis.new(host: "localhost")
Redis.exists_returns_integer = false
md5 = Digest::MD5.new  
# redis.flushall
hiragana_alphabet = 'そういあえおかきくけこさしすせたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽ'
# client.query("Delete from features")
# client.query("Delete from package_features")
# redis.set("a", 1)
# "OK"
# p redis.keys('*')

# md5 << "nguyenhoaiduc" 
# md5.reset
# md5 << 'c'
# p md5.hexdigest
# byebug
# @cdr_result = client.query("insert into features(name) values ('haha')")
# p client.last_id
# @cdr_result.each do |row|
#     p row
# end
# byebug




driver = Selenium::WebDriver.for:firefox
# driver.get "https://www.squet.ne.jp/mufg/s/login/"
# element = driver.find_element(:xpath,'//*[@id="str_header"]/div/div/div/div/div/form/p[1]/label/input')
# element.send_keys "s180851473-2"
# element = driver.find_element(:xpath,'//*[@id="str_header"]/div/div/div/div/div/form/p[2]/label/input')
# element.send_keys "m180851473"
# element.submit
# sleep 2
# driver.execute_script( "window.open('https://www.squet.ne.jp/mufg/s/Z1CC10-020?id=joseikin')" )
# sleep 10
# window = driver.window_handles[-1]
# driver.switch_to.window(window)
# hiragana_alphabet = hiragana_alphabet.split('')
# index = 0;
# hiragana_alphabet.each do |word|
#     driver.execute_script( "window.open('https://ww2.soudan-shikin.jp/DBC/index.aspx')" )
#     window = driver.window_handles[-1]
#     driver.switch_to.window(window)
#     sleep 3
#     element = driver.find_element(:xpath,'/html/body/form/main/article/section[3]/div/div/input')
#     element.send_keys word
#     element = driver.find_element(:xpath,'/html/body/form/main/article/section[3]/div/div/p/a').click
#     while true
#         sleep 0.5
#         element = driver.find_element(:tag_name,'body')
#         html_doc = html_doc = Nokogiri::HTML(element.attribute("outerHTML")) 
#         next_page_btn = html_doc.css('input.btn')
#         list = html_doc.css('ul.list_detail').children.css('li')
#         packages = []
#         list.each do |list_item|
#             link = list_item.children.css('a').first['href']
#             subsidy_id = link[23..40]
#             packages.push(subsidy_id)
#         end 
#         packages.each_with_index do |package,index|
#             if(redis.exists(package)==false)
#                 redis.set(package,1)
#                 driver.find_element(:xpath,"//*[@id='SubsidyID#{index}']").click
#                 driver.find_element(:xpath,"//*[@id='condition']/ul/li[2]/input").click
#                 sleep 0.1
#                 check_list = driver.find_elements(:tag_name,'label')
#                 check_list.each_with_index do |item,index|
#                     md5.reset
#                     md5 << check_list[index].text
#                     encodeId = md5.hexdigest
#                     if(redis.exists(encodeId)==false)
#                         client.query("insert into features(name) values ('#{check_list[index].text}')")
#                         redis.set(encodeId,client.last_id)
#                     end
#                     client.query("insert into package_features(package_id,feature_id) values ('#{package}','#{redis.get(encodeId)}')")
#                 end
#                 driver.execute_script("window.history.go(-1)")
#                 sleep 0.7
#             end
#         end
#         if next_page_btn.length() == 0
#             break
#         else 
#             driver.find_element(:xpath,'//*[@id="condition"]/div[2]/div[1]/ul/li[2]/input').click
#         end
#     end
#     index+=1;
#     if index == 1
#         break
#     end
# end
# package_ids = redis.keys('subsidy*')
# package_ids.each do |package|
#     driver.get "https://ww2.soudan-shikin.jp/detail/#{package}.html"
#     titleTemp = driver.find_element(:xpath,'/html/body/main/section/h2').text
    
#     index = 0
#     res = ''
#     while(index < titleTemp.length)
#         res+=titleTemp[index]
#         if titleTemp[index] == '】'
#             break;
#         end
#         index+=1
#     end
#     title = res
#     rating = driver.find_element(:xpath,'/html/body/main/section/h2/span/span').text.length
#     des = driver.find_element(:xpath,'/html/body/main/section/h3').text
#     extra_link = driver.find_element(:xpath,'/html/body/main/section/dl/dd/a').attribute('href')
#     status = 0
#     key1 = driver.find_element(:xpath,'/html/body/main/section/div[1]/h4').text
#     val1 = driver.find_element(:xpath,'/html/body/main/section/div[1]/p').attribute('innerHTML')
#     key2 = driver.find_element(:xpath,'/html/body/main/section/div[2]/h4').text
#     val2 = driver.find_element(:xpath,'/html/body/main/section/div[2]/p').attribute('innerHTML')
#     key3 = driver.find_element(:xpath,'/html/body/main/section/div[3]/h4').text
#     val3 = driver.find_element(:xpath,'/html/body/main/section/div[3]/p').attribute('innerHTML')
#     key4 = driver.find_element(:xpath,'/html/body/main/section/div[4]/h4').text
#     val4 = driver.find_element(:xpath,'/html/body/main/section/div[4]/p').attribute('innerHTML')
#     key5 = driver.find_element(:xpath,'/html/body/main/section/div[5]/h4').text
#     val5 = driver.find_element(:xpath,'/html/body/main/section/div[5]/p').attribute('innerHTML')
#     content = "{ #{key1} : #{val1},#{key2} : #{val2},#{key3} : #{val3},#{key4} : #{val4},#{key5} : #{val5},}"
    
#     client.query("insert into packages(id,rating,title,content,location,extra_link,status,is_suggested,image_url,approved_at,description) values ('#{package}','#{rating}','#{title}','#{content}','0','#{extra_link}','#{status}','0','0',null,'#{des}')")
# end
package_ids = redis.keys('subsidy*')
bussines_type = [101,111,141,151,181,201,301,401,501,601,701,801,999]
investment_type = [50000000,100000000,300000000]
employee_amount_type = [50,100,200,300,900]
business_form_type = [1,2]
invesment_ratio_type = [1,2,3]
establishment_type = [11,12,13,14]
prefectures = []
purpose = []
index = 1
while(index<=47)
    if index <= 20
        purpose.push(index)
    end
    prefectures.push(index)
    index+=1
end

package_ids.each do |package|
    purpose_rand = rand 0..purpose.length-1
    client.query("Insert into purpose_type_combinations (package_id,purpose_type_id) values ('#{package}',#{purpose[purpose_rand]})")
    # combinations = rand 1..3
    # index = 0;
    # while(index<combinations)
    #     bussines_rand = rand 0..bussines_type.length-1
    #     business_form_rand = rand 0..business_form_type.length-1
    #     investment_rand = rand 0..investment_type.length-1
    #     invesment_ratio_rand = rand 0..invesment_ratio_type.length-1
    #     prefectures_rand = rand 0..prefectures.length-1
    #     employee_amount_rand = rand 0..employee_amount_type.length-1
    #     establishment_rand = rand 0..establishment_type.length-1
    #     client.query("Delete from business_type_combinations where package_id = '#{package}' and business_type_id = #{bussines_type[bussines_rand]}")
    #     client.query("Delete from business_form_type_combinations where package_id = '#{package}' and business_form_type_id = #{business_form_type[business_form_rand]}")
    #     client.query("Delete from investment_type_combinations where package_id = '#{package}' and investment_type_id = #{investment_type[investment_rand]}")
    #     client.query("Delete from employee_amount_type_combinations where package_id = '#{package}' and employee_amount_type_id = #{employee_amount_type[employee_amount_rand]}")
    #     client.query("Delete from invest_ratio_type_combinations where package_id = '#{package}' and invest_ratio_type_id = #{invesment_ratio_type[invesment_ratio_rand]}")
    #     client.query("Delete from establishment_year_type_combinations where package_id = '#{package}' and establishment_year_type_id = #{establishment_type[establishment_rand]}")
    #     client.query("Delete from prefecture_combinations where package_id = '#{package}' and prefecture_id = #{prefectures[prefectures_rand]}")

    #     client.query("Insert into business_type_combinations (package_id,business_type_id) values ('#{package}',#{bussines_type[bussines_rand]})")
    #     client.query("Insert into business_form_type_combinations (package_id,business_form_type_id) values ('#{package}',#{business_form_type[business_form_rand]})")
    #     client.query("Insert into investment_type_combinations (package_id,investment_type_id) values ('#{package}',#{investment_type[investment_rand]})")
    #     client.query("Insert into employee_amount_type_combinations (package_id,employee_amount_type_id) values ('#{package}',#{employee_amount_type[employee_amount_rand]})")
    #     client.query("Insert into invest_ratio_type_combinations (package_id,invest_ratio_type_id) values ('#{package}',#{invesment_ratio_type[invesment_ratio_rand]})")
    #     client.query("Insert into establishment_year_type_combinations (package_id,establishment_year_type_id) values ('#{package}',#{establishment_type[establishment_rand]})")
    #     client.query("Insert into prefecture_combinations (package_id,prefecture_id) values ('#{package}',#{prefectures[prefectures_rand]})")
    #     index+=1
    #end
    
end
p 'ok'

$stdin.gets
