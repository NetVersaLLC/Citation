#!/usr/bin/env ruby

require 'rubygems'
require 'net/scp'
require 'fileutils'

Dir.open("src/labels").each do |label|
	next if label =~ /^\./
	FileUtils.cp_r "src/labels/#{label}/publish", "deploy/#{label}"
end
