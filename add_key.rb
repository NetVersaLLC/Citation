#!/usr/bin/env ruby

#
# Copyright (C) 2012 NetVersa, LLC.
# All rights reserved.
#

require 'rubygems'
require 'zip/zip'

file = 'dist\\Setup.exe'
key  = 'key.txt'
dir  = nil
Zip::ZipFile.open(file) { |zip_file|
    zip_file.each { |f|
        next unless f.name =~ /^(\d+)\\/
        dir = $1
    }
    STDERR.puts "Error: Could not find inner dir!" and exit 10 unless dir
}

STDERR.puts "Creating inner directory: #{dir}"
Dir.mkdir dir
STDERR.puts "Copy #{key} to #{dir}\\key.txt..."
system "copy \"#{key}\" #{dir}\\key.txt"
STDERR.puts "Adding #{dir}\\key.txt to #{file}..."
system "zip -0 \"#{file}\" \"#{dir}\\key.txt\""
STDERR.puts "Unlinking #{dir}\\key.txt"
File.unlink "#{dir}/key.txt"
STDERR.puts "Removing temporary directory #{dir}..."
Dir.rmdir dir
