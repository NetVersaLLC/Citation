require "selenium-webdriver"
require "test/unit"

class YelpUnit < Test::Unit::TestCase

  def setup
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "https://biz.yelp.com/"
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end
  
  def test_yelp_unit
    @driver.get(@base_url + "/")
    @driver.find_element(:css, "a.ybtn.btn-r-l > span").click
    @driver.find_element(:id, "business-search-query").clear
    @driver.find_element(:id, "business-search-query").send_keys "Assured Development, LLC."
    @driver.find_element(:id, "business-search-location").clear
    @driver.find_element(:id, "business-search-location").send_keys "Columbia, MO"
    @driver.find_element(:css, "button.btn-r-l").click
    @driver.find_element(:link, "Add your business to Yelp").click
    @driver.find_element(:id, "biz_address1").clear
    @driver.find_element(:id, "biz_address1").send_keys "2932 Leeway Dr."
    @driver.find_element(:id, "biz_address2").clear
    @driver.find_element(:id, "biz_address2").send_keys "Apt C"
    @driver.find_element(:id, "biz_zipcode").clear
    @driver.find_element(:id, "biz_zipcode").send_keys "65202"
    @driver.find_element(:id, "biz_phone").clear
    @driver.find_element(:id, "biz_phone").send_keys "5735292536"
    @driver.find_element(:id, "biz_city").clear
    @driver.find_element(:id, "biz_city").send_keys "Columbia"
    @driver.find_element(:id, "biz_state").clear
    @driver.find_element(:id, "biz_state").send_keys "MO"
    @driver.find_element(:id, "biz_website").clear
    @driver.find_element(:id, "biz_website").send_keys "http://assuredwebdevelopment.com"
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:name, "category")).select_by(:text, "Local Services")
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:name, "category")).select_by(:text, "Pest Control")
    @driver.find_element(:css, "button.btn-r-l").click
  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
end
