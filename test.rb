require "selenium-webdriver"
require "nokogiri"
require 'byebug'
require 'mysql2'
require 'redis'

@db_host  = "localhost"
@db_user  = "root"
@db_pass  = "root"
@db_name = "hojokin"

client = Mysql2::Client.new(:host => @db_host, :username => @db_user, :password => @db_pass, :database => @db_name)
redis = Redis.new(host: "localhost")
Redis.exists_returns_integer = false
redis.flushall
# //*[@id="condition"]/div[1]/div/select/option[2]
# //*[@id="condition"]/div[1]/div/select/option[14]

# //*[@id="CapitalCode0"]
# //*[@id="CapitalCode1"]
# //*[@id="CapitalCode2"]


# //*[@id="NumOfEmpCode0"]
# //*[@id="NumOfEmpCode4"]

# //*[@id="BizTypeCode0"]
# //*[@id="BizTypeCode1"]

# //*[@id="InvRatioCode0"]
# //*[@id="InvRatioCode2"]

# //*[@id="EstablishedCode0"]
# //*[@id="EstablishedCode3"]

# //*[@id="condition"]/div[7]/div/select/option[2]
# //*[@id="condition"]/div[7]/div/select/option[48]
redis = Redis.new(host: "localhost")
driver = Selenium::WebDriver.for:firefox
driver.get "https://www.squet.ne.jp/mufg/s/login/"
element = driver.find_element(:xpath,'//*[@id="str_header"]/div/div/div/div/div/form/p[1]/label/input')
element.send_keys "s180851473-2"
element = driver.find_element(:xpath,'//*[@id="str_header"]/div/div/div/div/div/form/p[2]/label/input')
element.send_keys "m180851473"
element.submit
sleep 3
driver.execute_script( "window.open('https://www.squet.ne.jp/mufg/s/Z1CC10-020?id=joseikin')" )
sleep 3   
window = driver.window_handles[-1]
p window
driver.switch_to.window(window)
sleep 3
element = driver.find_element(:xpath,'/html/body/form/main/article/section[2]/div/div/ul/li[1]/a').click
industryIndex = 3
while(industryIndex<=14)
    investmentIndex = 1
    while(investmentIndex<=2)
        employeeAmountIndex = 2;
        while(employeeAmountIndex<=4)
            businessFromIndex = 0;
            while(businessFromIndex<=1)
                investRatioIndex = 0
                while (investRatioIndex <=2)
                    establishIndex = 0
                    while (establishIndex<=3)
                        prefectureIndex = 2
                        while prefectureIndex<=48
                            driver.get "https://ww2.soudan-shikin.jp/navi1.aspx"
                            driver.find_element(:xpath,"//*[@id='condition']/div[1]/div/select/option[#{industryIndex}]").click
                            driver.find_element(:xpath,"//*[@id='CapitalCode#{investmentIndex}']").click
                            driver.find_element(:xpath,"//*[@id='NumOfEmpCode#{employeeAmountIndex}']").click
                            driver.find_element(:xpath,"//*[@id='BizTypeCode#{businessFromIndex}']").click
                            driver.find_element(:xpath,"//*[@id='InvRatioCode#{investRatioIndex}']").click
                            driver.find_element(:xpath,"//*[@id='EstablishedCode#{establishIndex}']").click
                            driver.find_element(:xpath,"//*[@id='condition']/div[7]/div/select/option[#{prefectureIndex}]").click
                            driver.find_element(:xpath,'//*[@id="condition"]/p[2]/input').click
                            packages_amount = 0;
                            subsidies = ''
                            while true
                                sleep 0.5
                                element = driver.find_element(:tag_name,'body')
                                html_doc = html_doc = Nokogiri::HTML(element.attribute("outerHTML")) 
                                next_page_btn = html_doc.css('input.btn')
                                list = html_doc.css('ul.list_detail').children.css('li')
                                packages_amount+=list.length
                                list.each do |list_item|
                                    link = list_item.children.css('a').first['href']
                                    subsidy_id = link[23..40]
                                    if redis.exists(subsidy_id)==false
                                        redis.set(subsidy_id,1)
                                    end
                                    subsidies+="#{subsidy_id},"
                                end
                                if next_page_btn.length() == 0
                                    break
                                else 
                                    driver.find_element(:xpath,'//*[@id="condition"]/div[2]/div[1]/ul/li[2]/input').click
                                end
                            end
                            combination_config = "#{industryIndex}-#{investmentIndex}-#{employeeAmountIndex}-#{businessFromIndex}-#{investRatioIndex}-#{establishIndex}-#{prefectureIndex}"
                            client.query("insert into combinations(config,subsidies,total) values ('#{combination_config}','#{subsidies}',#{packages_amount})")
                            prefectureIndex+=1
                        end
                        establishIndex+=1
                    end
                    investRatioIndex+=1
                end
                businessFromIndex+=1
            end
            employeeAmountIndex+=1
        end
        investmentIndex+=1
    end
    industryIndex+=1
end
p 'ok'
# submit_button = driver.find_element(:xpath,'//*[@id="condition"]/p[2]/input');
# submit_button.click
# sleep 3   
# while true
#     sleep 0.5;
#     element = driver.find_element(:tag_name,'body')
#     html_doc = html_doc = Nokogiri::HTML(element.attribute("outerHTML")) 
#     next_page_btn = html_doc.css('input.btn')
#     list = html_doc.css('ul.list_detail').children.css('li')
#     # list.each do |list_item|
#     #     count+=1
#     #     p list_item.children.css('a').first['href']
#     #     p list_item.children.css('a').first.children.first.text
#     #     puts '\n'
#     # end 
#     listEntity = driver.find_element(:class,'list_detail');
#     listItemsFirst = listEntity.find_elements(:tag_name,'input');
#     listItemsFirst.each_with_index  do |listItem,index|
#         subsidyId = "SubsidyID#{index}"
#         checkListRatio = "//*[@id='#{subsidyId}']";
#         driver.find_element(:xpath,checkListRatio).click;
#         driver.find_element(:xpath,'/html/body/form/div[1]/div/ul/li[2]/input').click;
#         checklist = driver.find_elements(:tag_name,'label')
#         p checklist.length
#         driver.execute_script("window.history.go(-1)")
#         sleep(0.25)
#     end
#     if next_page_btn.length() > 0
#         driver.find_element(:xpath,'//*[@id="condition"]/div[2]/div[1]/ul/li[2]/input').click 
#     else                                                                                     
#         break
#     end
# end
$stdin.gets
