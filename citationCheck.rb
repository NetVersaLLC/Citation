require "rubygems"
require "watir"
require "httparty"
require "./lib/contact_job"

#$HIDE_IE=true

key  = ARGV.shift
file = ARGV.shift

$stdout.reopen("out.txt", "a")
$stderr.reopen("err.txt", "a")

puts "Key: #{key}"

#api_base = 'http://localhost:3000/'
api_base = 'http://cite.netversa.com/'

begin
    if file
        ContactJob.run_from_file(file, key)
    else
        ContactJob.run(key)
    end
rescue Exception => e
    STDERR.puts e.inspect
end
