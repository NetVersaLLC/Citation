require "rubygems"
require "watir"
require "httparty"

$HIDE_IE=true

key = ARGV.shift

$stdout.reopen("out.txt", "a")
$stderr.reopen("err.txt", "a")

STDERR.puts "Key: #{key}"
