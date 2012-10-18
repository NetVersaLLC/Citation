#
# Copyright (C) NetVersa, LLC.
# All rights reserved.
#

require "rubygems"
require 'ffi'
FFI::typedef(:int, :intptr_t)
require 'time'
require 'ipaddr'
require "watir-webdriver"
require "json"
require "multi_json"
MultiJson.engine = :json_gem

require "open-uri"
require "nokogiri"
require "./lib/restclient"
require "./lib/contact_job"
require "./lib/captcha"

$HIDE_IE = true

host = 'http://192.168.0.22:3000'
key  = ARGV.shift
bid  = ARGV.shift

puts "Doing run: #{Time.now.iso8601}"
puts "Key: #{key}"
puts "bid: #{bid}"
puts "Mark: #{Time.now.iso8601}"

begin
    cj = ContactJob.new host, key, bid
    cj.run
rescue => detail
    puts detail.message + "\n" + detail.backtrace.join("\n")
    ContactJob.booboo(detail.backtrace.join("\n"))
end
