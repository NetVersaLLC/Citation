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
require "./lib/phone_verify"
require "./lib/captcha"

$host = ENV['CITATION_HOST'] || 'https://citation.netversa.com'
$key  = ARGV.shift
$bid  = ARGV.shift

if ENV['CITATION_HOST']
    puts "Connecting to: #{$host}"
end

if $key == nil or $key.strip == ''
    puts "Error: Cannot run without access key!"
    exit
end

if $bid == nil or $bid.strip == ''
    puts "Error: Cannot run without business id!"
    exit
end

puts "M: #{Time.now.iso8601}"

begin
    puts "starting #{$host}: #{$key}: #{$bid}"
    cj = ContactJob.new $host, $key, $bid
    cj.run
rescue => detail
    puts detail.message + "\n" + detail.backtrace.join("\n")
    ContactJob.booboo(detail.backtrace.join("\n"), $key, $bid)
end
