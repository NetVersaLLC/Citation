#
# Copyright (C) NetVersa, LLC.
# All rights reserved.
#

require "rubygems"
require 'time'
if RUBY_PLATFORM.downcase.include?("mswin")
  require "watir"
  require 'watir/ie'
  Watir::Browser.default = "ie"
else
  require "watir-webdriver"
end
require "json"
require "multi_json"
MultiJson.engine = :json_gem

require "rest-client"
require "httparty"
require "./lib/contact_job"
require "./lib/captcha"

$HIDE_IE=false
$REMOTE = 'http://localhost:3000'
# $REMOTE = 'https://citation.netversa.com'

key  = ARGV.shift
bid  = ARGV.shift
file = ARGV.shift

if key == nil
    ie = Watir::Browser.new
    ie.goto "http://slashdot.org"
    sleep 1
    exit
end

# key = File.open("#{pwd}\\key.txt", 'r').read
# bid = File.open("#{pwd}\\bid.txt", 'r').read
# dir = File.expand_path('~')

#$stdout.reopen("#{dir}\\out.txt", "a")
#$stderr.reopen("#{dir}\\err.txt", "a")

#log = File.open("#{dir}\\log.txt", "w")
puts "Doing run: #{Time.now.iso8601}"
puts "Key: #{key}"
puts "bid: #{bid}"

puts "Mark: #{Time.now.iso8601}"

begin
    if file
        puts "opening from file: #{file}"
        ContactJob.run_from_file(file, key, bid)
    else
        ContactJob.run(key, bid)
    end
rescue => detail
    puts detail.message + "\n" + detail.backtrace.join("\n")
    ContactJob.booboo(detail.backtrace.join("\n"))
end
