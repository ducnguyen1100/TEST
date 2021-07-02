require "selenium-webdriver"
require "nokogiri"
require 'byebug'
require 'mysql2'
require 'redis'

@db_host  = "localhost"
@db_user  = "root"
@db_pass  = "duc123456"
@db_name = "hojokin"

client = Mysql2::Client.new(:host => @db_host, :username => @db_user, :password => @db_pass, :database => @db_name)
redis = Redis.new(host: "localhost")
#2ういあえおかきくけこさしすせたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン
Redis.exists_returns_integer = false
CRAWL_CHECKLIST = 'CRAWL_CHECKLIST'
CRAWL_DETAILS = 'CRAWL_DETAILS'
alphabet = '2'
wait = Selenium::WebDriver::Wait.new(:timeout => 60)
options = Selenium::WebDriver::Firefox::Options.new(args: ['--headless'])
crawl_times = 0;

def getSubsidyId (str)
    subsidy_id = ''
    flag = false
    str.each_char do |char|
        if flag == true
            if(char == "'")
                break
            else
                subsidy_id+=char
            end
        else
            if(char == "'")
                flag = true
            end
        end
    end
    return subsidy_id
end

while(true)
    # redis.flushall
    crawl_times+=1
    begin
        # driver = Selenium::WebDriver.for:firefox
        # driver.get "https://www.squet.ne.jp/mufg/s/login/"
        # element = driver.find_element(:xpath,'//*[@id="str_header"]/div/div/div/div/div/form/p[1]/label/input')
        # element.send_keys "s180851473-2"
        # element = driver.find_element(:xpath,'//*[@id="str_header"]/div/div/div/div/div/form/p[2]/label/input')
        # element.send_keys "m180851473"
        # element.submit
        # sleep 5
        # driver.execute_script( "window.open('https://www.squet.ne.jp/mufg/s/Z1CC10-020?id=joseikin')" )
        # sleep 5
        # window = driver.window_handles[-1]
        # driver.switch_to.window(window)
        # jp_alphabet = alphabet.split('')
        # crawl_amount = 0;
        # word_amount = 0;
        # jp_alphabet.each do |word|
        #     begin
        #         word_amount+=1
        #         p "word index #{word_amount}"
        #         if(word_amount%5==0)
        #             driver.quit
        #             driver = Selenium::WebDriver.for:firefox
        #             driver.get "https://www.squet.ne.jp/mufg/s/login/"
        #             element = driver.find_element(:xpath,'//*[@id="str_header"]/div/div/div/div/div/form/p[1]/label/input')
        #             element.send_keys "s180851473-2"
        #             element = driver.find_element(:xpath,'//*[@id="str_header"]/div/div/div/div/div/form/p[2]/label/input')
        #             element.send_keys "m180851473"
        #             element.submit
        #             sleep 10
        #             driver.execute_script( "window.open('https://www.squet.ne.jp/mufg/s/Z1CC10-020?id=joseikin')" )
        #             sleep 10
        #             window = driver.window_handles[-1]
        #             driver.switch_to.window(window)
        #         end
        #         driver.get 'https://ww2.soudan-shikin.jp/DBC/index.aspx'
        #         sleep 5
        #         element = driver.find_element(:xpath,'/html/body/form/main/article/section[3]/div/div/input')
        #         element.send_keys word
        #         element = driver.find_element(:xpath,'/html/body/form/main/article/section[3]/div/div/p/a').click
        #         packages_amount = 0
        #         while true
        #             sleep 0.5
        #             element = driver.find_element(:tag_name,'body')
        #             html_doc = html_doc = Nokogiri::HTML(element.attribute("outerHTML")) 
        #             next_page_btn = html_doc.css('input.btn')
        #             list = html_doc.css('ul.list_detail').children.css('li')
        #             packages_amount+=list.length
        #             list.each_with_index do |list_item,index|
        #                 link = list_item.children.css('a').first['href']
        #                 subsidy_id = getSubsidyId(link)
        #                 if redis.exists(subsidy_id)==false
        #                     redis.set(subsidy_id,1)
        #                     begin
        #                         element = wait.until { driver.find_element(:xpath,"//*[@id='SubsidyID#{index}']") }
        #                         element.click
        #                         element = wait.until {driver.find_element(:xpath,"//*[@id='condition']/ul/li[2]/input")}
        #                         element.click
        #                         check_list = wait.until { driver.find_elements(:tag_name,'label') }
        #                         feature = client.query("SELECT * FROM hojokin.features  where  package_id = '#{subsidy_id}' order by id")
        #                         if feature.count == 0
        #                             p 'add more'
        #                             client.query("delete from waiting_features where package_id = '#{subsidy_id}'")
        #                             check_list.each_with_index do |item,index|
        #                                 client.query("insert into waiting_features(name,package_id) values ('#{check_list[index].text}','#{subsidy_id}')")
        #                             end  

        #                             jobs_history = client.query("select * from jobs_history where package_id = '#{subsidy_id}' and crawl_type = '#{CRAWL_CHECKLIST}'")
        #                             if jobs_history.count == 0
        #                                 client.query("insert into jobs_history(package_id,crawl_type,action,success,exception,crawl_times,created_at,updated_at) values('#{subsidy_id}','#{CRAWL_CHECKLIST}','create',1,null,#{crawl_times},'#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}','#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}')")
        #                             else
        #                                 client.query("update jobs_history set action = 'create', exception = null, success = 1, crawl_times = '#{crawl_times}', updated_at = '#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}' where  package_id = '#{subsidy_id}' and crawl_type = '#{CRAWL_CHECKLIST}'")
        #                             end    
        #                         else
        #                             isModified = 0
        #                             if check_list.length == feature.count
        #                                 feature.each_with_index do |row,index|
        #                                     if check_list[index].text != row['name']
        #                                         isModified = 1
        #                                     end
        #                                 end
        #                             else
        #                                 isModified = 1
        #                             end  
                                    
        #                             if isModified == 1
        #                                 p "modified #{subsidy_id}"
        #                                 client.query("delete from waiting_features where package_id = '#{subsidy_id}'")
        #                                 check_list.each_with_index do |item,index|
        #                                     client.query("insert into waiting_features(name,package_id) values ('#{check_list[index].text}','#{subsidy_id}')")
        #                                 end  
        #                                 jobs_history = client.query("select * from jobs_history where package_id = '#{subsidy_id}' and crawl_type = '#{CRAWL_CHECKLIST}'")
        #                                 if jobs_history.count == 0
        #                                     client.query("insert into jobs_history(package_id,crawl_type,action,success,exception,crawl_times,created_at,updated_at) values('#{subsidy_id}','#{CRAWL_CHECKLIST}','update',1,null,#{crawl_times},'#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}','#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}')")
        #                                 else
        #                                     client.query("update jobs_history set action = 'update', exception = null, success = 1, crawl_times = '#{crawl_times}', updated_at = '#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}' where  package_id = '#{subsidy_id}' and crawl_type = '#{CRAWL_CHECKLIST}'")
        #                                 end    
        #                             end 
        #                         end
        #                         driver.execute_script("window.history.go(-1)")
        #                     rescue => exception
        #                         p  exception.message
        #                         jobs_history = client.query("select * from jobs_history where package_id = '#{subsidy_id}' and crawl_type = '#{CRAWL_CHECKLIST}'")
        #                         if jobs_history.count == 0
        #                             client.query("insert into jobs_history(package_id,crawl_type,action,success,exception,crawl_times,created_at,updated_at) values('#{subsidy_id}','#{CRAWL_CHECKLIST}','error',0,'#{exception.message}',#{crawl_times},'#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}','#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}')")
        #                         else
        #                             client.query("update jobs_history set action = 'error', exception = '#{exception.message}', success = 0, crawl_times = '#{crawl_times}', updated_at = '#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}' where  package_id = '#{subsidy_id}' and crawl_type = '#{CRAWL_CHECKLIST}'")
        #                         end    
        #                         driver.execute_script("window.history.go(-1)")
        #                     end
        #                     crawl_amount+=1
        #                     if crawl_amount%300==0
        #                         sleep 20
        #                     end
        #                     p "index :#{crawl_amount}"
        #                 end
        #             end
        #             if next_page_btn.length() == 0
        #                 break
        #             else 
        #                 element = wait.until{driver.find_element(:xpath,'//*[@id="condition"]/div[2]/div[1]/ul/li[2]/input')}
        #                 element.click
        #             end
        #         end
        #     rescue => exception
        #         p  "error in checklist #{exception.message}"
        #         byebug
        #         jobs_history = client.query("select * from jobs_history where package_id = 'Checklist' and crawl_type = '#{CRAWL_CHECKLIST}'")
        #         if jobs_history.count == 0
        #             client.query("insert into jobs_history(package_id,crawl_type,action,success,exception,crawl_times,created_at,updated_at) values('Checklist','#{CRAWL_CHECKLIST}','error',0,'#{exception.message.gsub("'",'')}',#{crawl_times},'#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}','#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}')")
        #         else
        #             client.query("update jobs_history set action = 'error', exception = '#{exception.message.gsub("'",'')}', success = 0, crawl_times = '#{crawl_times}', updated_at = '#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}' where  package_id = 'Checklist' and crawl_type = '#{CRAWL_CHECKLIST}'")
        #         end  

        #         driver.quit()  
        #     end
        # end

        # driver.quit()
        driver = Selenium::WebDriver.for:firefox

        package_ids = redis.keys('subsidy*')
        index = 0;
        prefectures = client.query('select name from prefectures');
        package_ids.each do |package|
            begin
                driver.get "https://ww2.soudan-shikin.jp/detail/#{package}.html"
                index+=1
                p "index : #{index}"
                titleCrawl = driver.find_element(:xpath,'/html/body/main/section/h3').text
                des = driver.find_element(:xpath,'/html/body/main/section/div[1]/p').text
                extra_link = driver.find_element(:xpath,'/html/body/main/section/dl/dd/a').attribute('href')
                content1 = driver.find_element(:xpath,'/html/body/main/section/div[1]/p').attribute('innerHTML')
                content2 = driver.find_element(:xpath,'/html/body/main/section/div[3]/p').attribute('innerHTML')
                content3 = driver.find_element(:xpath,'/html/body/main/section/div[4]/p').attribute('innerHTML')
                content4 = driver.find_element(:xpath,'/html/body/main/section/div[5]/p').attribute('innerHTML')
                title = '';
                titleBeforeContent = ''
                titleCrawl.each_char do |char|
                    if char == '「'
                        break
                    end
                    titleBeforeContent+=char
                end
                prefectures.each do |row|
                    matchState =  titleBeforeContent.match /.*#{row['name']}/
                    if matchState
                        matchDetails = titleCrawl.match /「.*」/
                        title += matchState[0] + matchDetails[0];
                        break;
                    end
                end
                is_crawl = true
                if(title.length == 0 || titleBeforeContent.length == titleCrawl.length)
                    title = titleCrawl
                else
                    is_crawl = false
                end          
                if is_crawl == false
                    next
                end
                package_db = client.query("select * from packages where id = '#{package}' and deleted_at is  NULL ")
                if package_db.count == 0
                    p "#{package} not insert"
                    client.query("delete from waiting_packages where id = '#{package}'")
                    client.query("insert into waiting_packages(id,title,content1,content2,content3,content4,extra_link,status,description) values ('#{package}','#{title}','#{content1}','#{content2}','#{content3}','#{content4}','#{extra_link}',0,'#{des}')")

                    jobs_history = client.query("select * from jobs_history where package_id = '#{package}' and crawl_type = '#{CRAWL_DETAILS}'")
                    if jobs_history.count == 0
                        client.query("insert into jobs_history(package_id,crawl_type,action,success,exception,crawl_times,created_at,updated_at) values('#{package}','#{CRAWL_DETAILS}','create',1,null,#{crawl_times},'#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}','#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}')")
                    else
                        client.query("update jobs_history set action = 'create', exception = null, success = 1, crawl_times = '#{crawl_times}', updated_at = '#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}' where  package_id = '#{package}' and crawl_type = '#{CRAWL_DETAILS}'")
                    end   
                end

                if package_db.count == 1
                    is_update = 0
                   waiting_features = client.query("SELECT * FROM hojokin.waiting_features  where  package_id = '#{package}'")
                    package_db.each do |row|
                        if row['content1'] != content1 || row['content2'] != content2 || row['content3'] != content3 ||row['content4'] != content4 || row['title']!=title || row['extra_link'] != extra_link
                            p "update #{package}"
                            is_update = 1
                        end
                    end
                    if(waiting_features.count > 0 )
                        p "update checklist and update '#{package}'"
                        client.query("delete from waiting_packages where id = '#{package}'")
                        client.query("insert into waiting_packages(id,title,content1,content2,content3,content4,extra_link,status,description) values ('#{package}','#{title}','#{content1}','#{content2}','#{content3}','#{content4}','#{extra_link}',1,'#{des}')")

                        jobs_history = client.query("select * from jobs_history where package_id = '#{package}' and crawl_type = '#{CRAWL_DETAILS}'")
                        if jobs_history.count == 0
                            client.query("insert into jobs_history(package_id,crawl_type,action,success,exception,crawl_times,created_at,updated_at) values('#{package}','#{CRAWL_DETAILS}','update',1,null,#{crawl_times},'#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}','#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}')")
                        else
                            client.query("update jobs_history set action = 'update', exception = null, success = 1, crawl_times = '#{crawl_times}', updated_at = '#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}' where  package_id = '#{package}' and crawl_type = '#{CRAWL_DETAILS}'")
                        end   
                    else 
                        if is_update == 1
                            p "update #{package} not update checklist"
                            client.query("delete from waiting_features where package_id = '#{package}'")
                            check_list_db = client.query("select * from features where package_id = '#{package}'")
                            check_list_db.each do |row|
                                client.query("insert into waiting_features(name,package_id) values ('#{row['name']}','#{row['package_id']}')")
                            end
                            client.query("delete from waiting_packages where id = '#{package}'")
                            client.query("insert into waiting_packages(id,title,content1,content2,content3,content4,extra_link,status,description) values ('#{package}','#{title}','#{content1}','#{content2}','#{content3}','#{content4}','#{extra_link}',1,'#{des}')")

                            jobs_history = client.query("select * from jobs_history where package_id = '#{package}' and crawl_type = '#{CRAWL_DETAILS}'")
                            if jobs_history.count == 0
                                client.query("insert into jobs_history(package_id,crawl_type,action,success,exception,crawl_times,created_at,updated_at) values('#{package}','#{CRAWL_DETAILS}','update',1,null,#{crawl_times},'#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}','#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}')")
                            else
                                client.query("update jobs_history set action = 'update', exception = null, success = 1, crawl_times = '#{crawl_times}', updated_at = '#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}' where  package_id = '#{package}' and crawl_type = '#{CRAWL_DETAILS}'")
                            end   
                        end
                    end   
                end
                if index%300==0
                    driver.quit()
                    driver = Selenium::WebDriver.for:firefox
                end
            rescue => exception
                p "#{package} + #{exception}"

                jobs_history = client.query("select * from jobs_history where package_id = '#{package}' and crawl_type = '#{CRAWL_DETAILS}'")
                if jobs_history.count == 0
                    client.query("insert into jobs_history(package_id,crawl_type,action,success,exception,crawl_times,created_at,updated_at) values('#{package}','#{CRAWL_DETAILS}','error',0,'#{exception.message.gsub("'",'')}',#{crawl_times},'#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}','#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}')")
                else
                    client.query("update jobs_history set action = 'error', exception = '#{exception.message.gsub("'",'')}', success = 0, crawl_times = '#{crawl_times}', updated_at = '#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}' where  package_id = '#{package}' and crawl_type = '#{CRAWL_DETAILS}'")
                end   
                driver.quit()
                driver = Selenium::WebDriver.for:firefox
            end
        end
        driver.quit()
        p 'ok'
        byebug
    rescue => exception
        p "error in main #{exception}"
        driver.quit()
    end
end

$stdin.gets
