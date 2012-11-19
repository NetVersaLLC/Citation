#
# Copyright (C) NetVersa, LLC.
# All rights reserved.
#

require "rubygems"
require "optparse"
require "json"
require "multi_json"
require "fileutils"
MultiJson.engine = :json_gem

require "./lib/restclient"
require "./lib/contact_job"
require "./lib/captcha"
include FileUtils

class JobOptions
    ACTIONS = %w/list add remove run/
    def self.parse(args)
        options = OpenStruct.new
        options.bid       = nil
        options.key       = nil
        options.action    = 'list'
        options.directory = pwd
        options.exe       = "#{pwd}/citationCheck.exe"
        opts = OptionParser.new do |opts|
            opts.banner = "Usage: jobs.rb [options]"
            opts.separator ""
            opts.separator "Specific options:"
            opts.on("-b", "--business-id BID", "The business id to perform the action on.") do |bid|
                options.bid    = bid
            end
            opts.on("-k", "--auth-token TOKEN", "The API access token.") do |key|
                options.key    = key
            end
            opts.on("-a", "--action ACTION", ACTIONS, "Action to perform, one of add, list, remove or run") do |action|
                options.action = action
            end
            opts.on("-e", "--exe EXE", "Location of citationCheck.exe.") do |exe|
                options.exe = exe
            end
            opts.on("-d", "--config-directory", "Directory to look for key.txt and bid.txt in.") do |dir|
                options.directory = dir
            end
            opts.on_tail("-h", "--help", "Show this message") do
                puts opts
                exit
            end
        end
        opts.parse!(args)
        options
    end
end

options = JobOptions.parse(ARGV)

if options.key.nil?
    keyfile = "#{options.directory}/key.txt"
    if options.directory and File.exists? keyfile
        options.key = File.read(keyfile)
    else
        puts "Error: Auth key is required and not found at: #{keyfile}"
        exit
    end
end

if options.bid.nil?
    bidfile = "#{options.directory}/bid.txt"
    if options.directory and File.exists? bidfile
        options.bid = File.read(bidfile)
    else
        puts "Error: Business id is required and not found at: #{bidfile}"
        exit
    end
end

unless File.exists? options.exe
    puts "Error: Missing citationCheck.exe"
    exit
end

$host = ENV['CITATION_HOST'] || 'https://citation.netversa.com'
$key  = options.key
$bid  = options.bid

if ENV['CITATION_HOST']
    puts "Connecting to: #{$host}"
end

if $key == nil or $key.strip == ''
    puts "Error: Cannot run without access key!"
    exit
end

if $bid == nil or $bid.strip == ''
    puts "Error: Cannot run without business id!"
    exit
end

begin
    cj = ContactJob.new $host, $key, $bid
    case options.action
    when 'list' then
        list = JSON.parse( cj.list )
        puts '%5s: %-20s: %s' % ['id', 'name', 'status']
        list.each do |row|
            puts '%5s: %-20s: %s' % [row['id'], row['name'], row['status']]
        end
    when 'remove' then
        job_id = ARGV.shift
        unless job_id.nil? and job_id =~ /^\d+$/
            res = cj.remove(job_id)
        else
            puts "Error: Action requires job id."
            exit
        end
    when 'add' then
        job_name = ARGV.shift
        unless job_name.nil? and job_name =~ /\//
            cj.start( job_name  )
        else
            puts "Error: Missing or invalid job name."
            exit
        end
    when 'run' then
        job_name = ARGV.shift
        unless job_name.nil? and job_name =~ /\//
            cj.start( job_name  )
            system("citationCheck.exe", $key, $bid)
        else
            puts "Error: Missing or invalid job name."
            exit
        end
    else
        puts "Error: Unknown action: #{options.action}"
        exit
    end
rescue => detail
    puts detail.message + "\n" + detail.backtrace.join("\n")
end
