#!/usr/bin/env ruby

#
# Copyright (C) NetVersa, LLC.
# All rights reserved.
#

require 'rubygems'
require 'zip/zip'

file = 'dist\\Setup.exe'
key  = File.open("key.txt", "r").read
Zip::ZipFile.open(file) { |zip_file|
    dir = nil
    zip_file.each { |f|
        next unless f.name =~ /^(\d+)\\/
        dir = $1
        puts f.name
    }
    STDERR.puts "Error: Could not find inner dir!" and exit 10 unless dir
    #zip_file.get_output_stream("#{dir}\\key.txt") { |f| f.puts key }
}
