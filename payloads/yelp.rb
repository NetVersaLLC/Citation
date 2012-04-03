class Yelp
    include HTTParty
    format :json
    #base_uri "http://localhost:3000"
    base_uri "http://cite.netversa.com"
    # debug_output

    def self.notify_of_join(key)
        get("/yelps/check_email.json?auth_token=#{key}")
    end
end


browser = Watir::Browser.start("https://biz.yelp.com")
browser.a(:text => 'Create your free account now').click
browser.text_field(:id => 'business-search-query').set business['name']
browser.text_field(:id => 'business-search-location').set "#{business['city']}, #{business['state']}"
browser.button(:value => 'submit').click
Watir::Wait::until do
    if browser.text.include? "Sorry, there were no matches" or browser.text.include? "Category:"
        true
    else
        false
    end
end
if browser.text.include? "Sorry, there were no matches"
    browser.a(:text => "Add your business to Yelp").click
    browser.text_field(:id => 'biz_name').set business['name']
    browser.text_field(:id => 'biz_address1').set business['address']
    browser.text_field(:id => 'biz_address2').set business['address2']
    browser.text_field(:id => 'biz_city').set business['city']
    browser.text_field(:id => 'biz_state').set business['state']
    browser.text_field(:id => 'biz_zipcode').set business['zip']
    browser.text_field(:id => 'biz_phone').set business['phone']
    browser.text_field(:id => 'biz_website').set business['website']
    browser.select_list(:index, 4).select business['yelp_category'][0]
    sleep 1
    browser.select_list(:index, 5).select business['yelp_category'][1]
    if business['yelp_category'][2] != nil
        sleep 1
        browser.select_list(:index, 6).select business['yelp_category'][2]
    end
    browser.text_field(:name => 'email').set business['email']
    browser.button(:text => 'Add').click
    Watir::Wait::until do
        browser.text.include? "Your Business Is Almost On Yelp"
    end
    if browser.text.include? "Your Business Is Almost On Yelp"
        Yelp.notify_of_join(key)
    else
        puts "Somekinda error"
    end
else
    puts "Not yet"
end
