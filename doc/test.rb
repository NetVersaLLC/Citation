#!/usr/bin/ruby

require 'rubygems'
require 'ffi'
FFI::typedef(:int, :intptr_t)
require 'ipaddr'
require "watir-webdriver"

browser = Watir::Browser.new :firefox

browser.goto 'http://slashdot.org'
