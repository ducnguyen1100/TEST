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

jp_alphabet = '2そういあえおかきくけこさしすせたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン'
while(true)
    redis.flushall
    begin
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
        driver.switch_to.window(window)
        jp_alphabet = jp_alphabet.split('')
        crawl_amount = 0;
        word_amount = 0;
        jp_alphabet.each do |word|
            begin
                word_amount+=1
                p "word index #{word_amount}"
                if(word_amount%5==0)
                    driver.quit
                    driver = Selenium::WebDriver.for:firefox
                    driver.get "https://www.squet.ne.jp/mufg/s/login/"
                    element = driver.find_element(:xpath,'//*[@id="str_header"]/div/div/div/div/div/form/p[1]/label/input')
                    element.send_keys "s180851473-2"
                    element = driver.find_element(:xpath,'//*[@id="str_header"]/div/div/div/div/div/form/p[2]/label/input')
                    element.send_keys "m180851473"
                    element.submit
                    sleep 10
                    driver.execute_script( "window.open('https://www.squet.ne.jp/mufg/s/Z1CC10-020?id=joseikin')" )
                    sleep 10
                    window = driver.window_handles[-1]
                    driver.switch_to.window(window)
                end
                driver.get 'https://ww2.soudan-shikin.jp/DBC/index.aspx'
                sleep 5
                element = driver.find_element(:xpath,'/html/body/form/main/article/section[3]/div/div/input')
                element.send_keys word
                element = driver.find_element(:xpath,'/html/body/form/main/article/section[3]/div/div/p/a').click
                packages_amount = 0
                while true
                    sleep 0.5
                    element = driver.find_element(:tag_name,'body')
                    html_doc = html_doc = Nokogiri::HTML(element.attribute("outerHTML")) 
                    next_page_btn = html_doc.css('input.btn')
                    list = html_doc.css('ul.list_detail').children.css('li')
                    packages_amount+=list.length
                    list.each_with_index do |list_item,index|
                        link = list_item.children.css('a').first['href']
                        subsidy_id = link[23..40]
                        if redis.exists(subsidy_id)==false
                            redis.set(subsidy_id,1)
                            begin
                                driver.find_element(:xpath,"//*[@id='SubsidyID#{index}']").click
                                driver.find_element(:xpath,"//*[@id='condition']/ul/li[2]/input").click
                                sleep 0.1
                                check_list = driver.find_elements(:tag_name,'label')
                                check_list.each_with_index do |item,index|
                                    begin
                                        feature = client.query("SELECT * FROM hojokin.features  where name = '#{check_list[index].text}' and package_id = '#{subsidy_id}'")
                                        if feature.count == 0
                                            p "here #{subsidy_id}"
                                            byebug 
                                            client.query("insert into features(name,package_id) values ('#{check_list[index].text}','#{subsidy_id}')")
                                        end
                                    rescue => exception
                                        p "error in checklist item #{exception}"
                                    end    
                                end
                                driver.execute_script("window.history.go(-1)")
                                sleep 0.5
                            rescue => exception
                                p  exception.message
                                driver.execute_script("window.history.go(-1)")
                                sleep 0.5
                            end
                            crawl_amount+=1
                            if crawl_amount%300==0
                                sleep 20
                            end
                            p "index :#{crawl_amount}"
                        end
                    end
                    if next_page_btn.length() == 0
                        break
                    else 
                        driver.find_element(:xpath,'//*[@id="condition"]/div[2]/div[1]/ul/li[2]/input').click
                    end
                end
                client.query("insert into combinations(config,subsidies,total) values ('#{word}','',#{packages_amount})")
            rescue => exception
                p  "error in checklist #{exception.message}"
            end
        end

        package_ids = redis.keys('subsidy*')
        index = 0;
        package_ids.each do |package|
            begin
                driver.get "https://ww2.soudan-shikin.jp/detail/#{package}.html"
                index+=1
                p "index : #{index}"
                title = driver.find_element(:xpath,'/html/body/main/section/h3').text
                des = driver.find_element(:xpath,'/html/body/main/section/div[1]/p').text
                extra_link = driver.find_element(:xpath,'/html/body/main/section/dl/dd/a').attribute('href')
                content1 = driver.find_element(:xpath,'/html/body/main/section/div[1]/p').attribute('innerHTML')
                content2 = driver.find_element(:xpath,'/html/body/main/section/div[3]/p').attribute('innerHTML')
                content3 = driver.find_element(:xpath,'/html/body/main/section/div[4]/p').attribute('innerHTML')
                content4 = driver.find_element(:xpath,'/html/body/main/section/div[5]/p').attribute('innerHTML')
                package_db = client.query("select * from packages where id = '#{package}'")
                if package_db.count == 1
                    is_update = 0
                    package_db.each do |row|
                        if row['content1'] != content1 || row['content2'] != content2 || row['content3'] != content3 ||row['content4'] != content4 || row['title']!=title || row['extra_link'] != extra_link
                            p "update #{package}"
                            is_update = 1
                        end
                    end
                    if is_update == 1
                        p "update #{package}"
                        client.query("update packages set title = '#{title}',extra_link = '#{extra_link}',description='#{des}',content1='#{content1}',content2='#{content2}',content3='#{content3}',content4='#{content4}' where id = '#{package}'")
                    end
                end
                if package_db.count == 0
                    p "#{package} not insert"
                    client.query("insert into packages(id,title,content1,content2,content3,content4,extra_link,status,description) values ('#{package}','#{title}','#{content1}','#{content2}','#{content3}','#{content4}','#{extra_link}',0,'#{des}')")
                end
                if index%300==0
                    driver.quit()
                    driver = Selenium::WebDriver.for:firefox
                end
            rescue => exception
                p "#{package} + #{exception}"
            end
        end
        driver.quit
        p 'ok'
    rescue => exception
        p "error in main #{exception}"
    end
    byebug
end
$stdin.gets
