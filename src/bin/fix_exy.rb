#!/usr/bin/env ruby

file = ARGV.shift
check = ARGV.shift

File.open(file).each do |line|
    if line =~ /:$/ and line =~ /^\s*C:/ and line =~ /(C:.*\/lib\/([^:]+)):/
        puts "  #{$2}:"
        puts "    file: #{$1}"
    else
        puts line unless check
    end
end
