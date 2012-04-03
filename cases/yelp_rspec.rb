require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"

class yelp_rspec < Test::Unit::TestCase

  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => "localhost",
      :port => 4444,
      :browser => "*chrome",
      :url => "https://biz.yelp.com/",
      :timeout_in_second => 60

    @selenium.start_new_browser_session
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_yelp_rspec
    @selenium.open "/"
    @selenium.click "css=a.ybtn.btn-r-l > span"
    @selenium.wait_for_page_to_load "30000"
    @selenium.type "id=business-search-query", "Assured Development, LLC."
    @selenium.type "id=business-search-location", "Columbia, MO"
    @selenium.click "css=button.btn-r-l"
    @selenium.click "link=Add your business to Yelp"
    @selenium.wait_for_page_to_load "30000"
    @selenium.type "id=biz_address1", "2932 Leeway Dr."
    @selenium.type "id=biz_address2", "Apt C"
    @selenium.type "id=biz_zipcode", "65202"
    @selenium.type "id=biz_phone", "5735292536"
    @selenium.type "id=biz_city", "Columbia"
    @selenium.type "id=biz_state", "MO"
    @selenium.type "id=biz_website", "http://assuredwebdevelopment.com"
    @selenium.select "name=category", "label=Local Services"
    @selenium.select "name=category", "label=Pest Control"
    @selenium.click "css=button.btn-r-l"
    @selenium.wait_for_page_to_load "30000"
  end
end
