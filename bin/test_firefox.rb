#!/usr/bin/env ruby

require 'rubygems'
require 'watir-webdriver'
require 'awesome_print'

b = Watir::Browser.new

b.goto 'https://slashdot.org'
