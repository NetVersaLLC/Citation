#!/usr/bin/env ruby

require 'rubygems'

Dir.chdir 'C:\Users\jonathan\dev\Citation'

if ARGV[0] == 'production'
	servers = %w/web1.netversa.com web2.netversa.com staging.netversa.com/
else
	servers = %w/staging.netversa.com/
end
servers.each do |server|
	STDERR.puts "Posting to: #{server}"
	system "scp -i C:\\Users\\jonathan\\Dropbox\\new_keys\\deploy\\contact -r labels ubuntu@#{server}:~/contact/shared/labels.new"
	system "ssh -i C:\\Users\\jonathan\\Dropbox\\new_keys\\deploy\\contact ubuntu@#{server} 'rm -rf /home/ubuntu/contact/shared/labels.old && mv /home/ubuntu/contact/shared/labels /home/ubuntu/contact/shared/labels.old && mv /home/ubuntu/contact/shared/labels.new /home/ubuntu/contact/shared/labels'"
end
