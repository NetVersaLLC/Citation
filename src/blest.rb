#!/usr/bin/env ruby

require 'rest_client'

@host = ENV['CITATION_HOST'] || 'https://staging.netversa.com'
@key = ARGV.shift
@bid = ARGV.shift

msg = "Created job!"
name = "Test/Bitcoin"
time_delay = nil

RestClient.post("#{@host}/jobs.json?auth_token=#{@key}&business_id=#{@bid}", :message => msg, 
		:name => name, :delay => time_delay)
