#!/usr/bin/ruby

require 'rubygems'
require 'ffi'
FFI::typedef(:int, :intptr_t)
require 'ipaddr'
require "watir-webdriver"

outFile = "#{ENV['USERPROFILE']}\\Desktop\\strip.gif"

browser = Watir::Browser.new :firefox
browser.goto 'http://www.dilbert.com/'
browser.image(:src, /\/dyn\/str_strip\/.*?.strip.*?.gif/).save outFile
browser.close

puts "Saved to: #{outFile}"
