#!/usr/bin/env ruby

require 'rubygems'
require 'watir-webdriver'

@browser = Watir::Browser.new :phantomjs
@browser.goto "http://www.ratemyknockers.com/"
@browser.image(:src, /\/pics\/img.*?\.jpg/).save  "C:\\Users\\jonathan\\Desktop\\knockers.jpg"

