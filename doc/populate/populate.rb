#!/usr/bin/ebv ruby

require 'rubygems'
require 'ffi'
require 'rautomation'
require 'tmpdir'
require 'tempfile'

# path = Dir.tmpdir
#puts path

extension = ARGV.shift || 'png'

file = Tempfile.new("image")
path =  file.path
file.close
File.unlink path

file_dir = path
Dir.mkdir path

path.gsub!(File::SEPARATOR, File::ALT_SEPARATOR)

parts = path.split("\\")

parts.push("image.#{extension}")
path = parts.join("\\")

window=::RAutomation::Window.new(:title => /Save Picture/)
window.text_field(:class => 'Edit', :index => 0).set(path)
window.text_field(:class => 'Edit', :index => 0).send_keys(:space)
window.text_field(:class => 'Edit', :index => 0).send_keys(:enter)

newfile = nil
Dir.open(file_dir).each do |item|
    next if item =~ /^\./
    newfile = item
end

if newfile
    puts "#{path}"
    exit 0
else
    exit 5
end
