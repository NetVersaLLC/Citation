#!/usr/bin/env ruby

require 'rubygems'
require 'ffi'
require 'win32/screenshot'

hwnd  = ARGV.shift
image = ARGV.shift

unless hwnd and hwnd =~ /^\d+$/
    puts "Invalid hwnd"
    exit 7
end
unless image and image =~ /\.bmp$/
    puts "No image or image wrong format"
    exit 11
end
if File.exists? image
    puts "Image already exists"
    exit 23
end

Win32::Screenshot::Take.of(:window, :hwnd => hwnd, :context => :client).write image

exit 0
