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
require 'http/cookie/scanner'
require 'http/cookie_jar'
require 'http/cookie_jar/abstract_store'
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

STDOUT.sync = true

$version = '0.1.3.68'

$host = ENV['CITATION_HOST'] || 'https://citation.netversa.com'
$key  = ARGV.shift
$bid  = ARGV.shift

if ENV['CITATION_HOST']
    STDERR.puts "Connecting to: #{$host}"
end

def send_json(message, status='error')
  msg = {
	  :status => status,
	  :message => message,
	  :version => $version
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

	# browser = 'Mozilla/5.0 (Windows; Windows NT 6.1) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/0.1.3.68 Safari/536.5'
	#capabilities = Selenium::WebDriver::Remote::Capabilities.phantomjs("phantomjs.page.settings.userAgent" => "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/0.1.3.68 Safari/537.36")
	#driver = Selenium::WebDriver.for :phantomjs, :desired_capabilities => capabilities
	#browser = ::Watir::Browser.new driver
	browser = ::Watir::Browser.new
	browser.goto 'https://signup.live.com/signup.aspx?'
	image = "#{ENV['USERPROFILE']}\\citation\\test_captcha.png"
	obj = browser.img( :id, /wlspispHIPBimg/ )
	STDERR.puts "CAPTCHA source: #{obj.src}"
	STDERR.puts "CAPTCHA width: #{obj.width}"
	#obj.save image
	#puts browser.html
	#puts CAPTCHA.solve image, :manual

	STDERR.puts "Version is: #{$version}"

	browser.close
	agent = Mechanize.new
	agent.agent.http.ca_file = 'files/ca-bundle.crt'
	agent.user_agent_alias = 'Mac Safari'
	page = agent.get "https://mtgox.com/"
	true
	exit
end



begin
    cj = ContactJob.new $host, $key, $bid, $version
    cj.run
rescue => detail
    send_json(detail.message + "\n" + detail.backtrace.join("\n"))
    ContactJob.booboo(detail.backtrace.join("\n"), $key, $bid)
end
