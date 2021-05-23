require "selenium-webdriver"
require "nokogiri"
require 'byebug'
require 'mysql2'
require 'digest'
require 'redis'

@db_host  = "localhost"
@db_user  = "root"
@db_pass  = "root"
@db_name = "hojokin"

client = Mysql2::Client.new(:host => @db_host, :username => @db_user, :password => @db_pass, :database => @db_name)
redis = Redis.new(host: "localhost")
Redis.exists_returns_integer = false
md5 = Digest::MD5.new  
# redis.flushall
#そういあえおかきくけこさしすせたちつてとなにぬね
hiragana_alphabet = 'のはひふへほまみむめもやゆよらりるれろわをんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽ'
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
driver.switch_to.window(window)
hiragana_alphabet = hiragana_alphabet.split('')
hiragana_alphabet.each do |word|
    driver.get 'https://ww2.soudan-shikin.jp/DBC/index.aspx'
    sleep 2
    element = driver.find_element(:xpath,'/html/body/form/main/article/section[3]/div/div/input')
    element.send_keys word
    element = driver.find_element(:xpath,'/html/body/form/main/article/section[3]/div/div/p/a').click
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
            # subsidies+="#{subsidy_id},"
        end
        if next_page_btn.length() == 0
            break
        else 
            driver.find_element(:xpath,'//*[@id="condition"]/div[2]/div[1]/ul/li[2]/input').click
        end
    end
    client.query("insert into combinations(config,subsidies,total) values ('#{word}','#{subsidies}',#{packages_amount})")
end
$stdin.gets