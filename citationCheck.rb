require "rubygems"
require "watir"
require "json"
require "multi_json"
MultiJson.engine = :json_gem

require "httparty"
require "./lib/contact_job"

Watir::Browser.default = "ie"

$HIDE_IE=true

key  = ARGV.shift
bid  = ARGV.shift
file = ARGV.shift

$stdout.reopen("out.txt", "a")
$stderr.reopen("err.txt", "a")

puts "Key: #{key}"
puts "bid: #{bid}"

begin
    if file
        STDERR.puts "opening from file: #{file}"
        ContactJob.run_from_file(file, key, bid)
    else
        ContactJob.run(key, bid)
    end
rescue Exception => e
    STDERR.puts e.inspect
    ContactJob.booboo(e.inspect)
end
