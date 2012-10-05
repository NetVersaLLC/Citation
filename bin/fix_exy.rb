#!/usr/bin/env ruby

check = ARGV.shift

File.open(ARGV.shift).each do |line|
    if line =~ /:$/ and line =~ /^\s*C:/ and line =~ /(C:.*\/lib\/([^:]+)):/
        puts "  #{$2}:"
        puts "    file: #{$1}"
    else
        puts line unless check
    end
end
