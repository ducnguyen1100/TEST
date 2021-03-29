require 'selenium-webdriver'
def run_session(url)
    driver = Selenium::WebDriver.for:firefox
    driver.get url
    # elem = driver.find_element(:name, 'q')      #q is the namespace of searchbox element
    # elem.send_keys q   #send_keys method used to write text
    # elem.submit
    sleep 5
    element = driver.find_element(:tag_name,'body');
    p element.attribute("outerHTML")
end
t1 = Thread.new{run_session("https://ww2.soudan-shikin.jp/detail/subsidy_111_210005.html")}
t2 = Thread.new{run_session("https://ww2.soudan-shikin.jp/detail/subsidy_111_210004.html")}
# t1.join()
# t2.join()
# run_session("gmail")
$stdin.gets
require 'set'
products = Set.new
products << '111_210005'
products << '111_210005'
products << '111_210004'
p products