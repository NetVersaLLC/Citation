#
# Copyright (C) NetVersa, LLC.
# All rights reserved.
#

require "rubygems"
require 'time'
require "watir"
require "json"
require "multi_json"
MultiJson.engine = :json_gem

require "httparty"
require "./lib/contact_job"

Watir::Browser.default = "ie"

$HIDE_IE=true

key  = ARGV.shift.strip
bid  = ARGV.shift.strip
file = ARGV.shift

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
