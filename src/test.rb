#!/usr/bin/env ruby

require 'rubygems'
require 'watir-webdriver'
require 'ffi'
FFI::typedef(:int, :intptr_t)
require 'time'
require 'ipaddr'
require "watir-webdriver"
require 'http/cookie/scanner'
require 'mechanize'
require "fileutils"
require "securerandom"
require "json"
require "multi_json"
require 'pry'
MultiJson.engine = :json_gem


browser = Watir::Browser.new  ARGV.shift
browser.goto 'https://signup.live.com/signup.aspx'
image = "#{ENV['USERPROFILE']}\\citation\\test_captcha.png"
#obj = browser.img( :css,  "('div#WLX_HIP_CTL_AMFE img')[1]" )
# obj = browser.img( :xpath,  '//div/table/tbody/tr/td/img[1]' )
#
#p browser.images

#binding.pry

obj = browser.img( :id,  /wlspispHIPBimg/ )
puts "CAPTCHA source: #{obj.src}"
puts "CAPTCHA width: #{obj.width}"
obj.save image
#puts browser.html

