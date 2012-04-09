require "rubygems"
require "watir"
require "json"
require "multi_json"
MultiJson.engine = :json_gem

require "httparty"
require "./lib/contact_job"

Watir::Browser.default = "ie"

$HIDE_IE=false

key  = ARGV.shift
file = ARGV.shift

$stdout.reopen("out.txt", "a")
$stderr.reopen("err.txt", "a")

puts "Key: #{key}"

begin
    if file
        ContactJob.run_from_file(file, key)
    else
        ContactJob.run(key)
    end
rescue Exception => e
    STDERR.puts e.inspect
end
