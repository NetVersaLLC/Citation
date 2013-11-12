#
# Copyright (C) 2013 NetVersa, LLC.
# All rights reserved.
#

require "rubygems"
require 'ffi'
FFI::typedef(:int, :intptr_t)
require 'time'
require 'ipaddr'
require "watir-webdriver"
require 'mechanize'
require "fileutils"
require "securerandom"
require "json"
require "multi_json"
MultiJson.engine = :json_gem

require "open-uri"
require "nokogiri"
require "pstore"
require "./lib/restclient"
require "./lib/contact_job"
require "./lib/phone_verify"
require "./lib/captcha"

$host = ENV['CITATION_HOST'] || 'https://citation.netversa.com'
$key  = ARGV.shift
$bid  = ARGV.shift

if ENV['CITATION_HOST']
    STDERR.puts "Connecting to: #{$host}"
end

def send_json(message, status='error')
  msg = {
	  :status => status,
	  :message => message
  }
  puts msg.to_json
end

if $key == nil or $key.strip == ''
    send_json("Cannot run without access key!")
    exit
end

if $bid == nil or $bid.strip == ''
    send_json("Cannot run without business id!")
    exit
end

if ENV['BUILD'] == 'active'
	total = 'unknown'
	browser = Watir::Browser.start 'http://mtgox.com'
	if browser.text =~ /High:\$([0-9\.]+)/i
		total = $1
	end
	browser.close
	puts "Total: #{total}"
	true
	exit
end

begin
    cj = ContactJob.new $host, $key, $bid
    cj.run
rescue => detail
    send_json(detail.message + "\n" + detail.backtrace.join("\n"))
    ContactJob.booboo(detail.backtrace.join("\n"), $key, $bid)
end
