puts "Starting Watir Test"
b = Watir::Browser.new
puts "Created Object"
b.goto "http://www.stevesouders.com/blog/2009/06/03/using-iframes-sparingly/"
puts "Went to Site"
puts b.html
puts "Printed HTML"
