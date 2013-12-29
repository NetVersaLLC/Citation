class ContactJob
	def initialize(host, key, bid, version)
		@host     = host
		@key      = key.strip
		@bid      = bid.strip
		@version  = version
	end

	def send_json(message, status='error')
		msg = {
			:status => status,
			:message => message,
			:version => @version
		}
		STDERR.puts "STDERR: "+msg.to_json
		puts msg.to_json
	end

	def run
		STDERR.puts "Getting: #{@host}/jobs.json?auth_token=#{@key}&business_id=#{@bid}"
		resp = RestClient.get("#{@host}/jobs.json?auth_token=#{@key}&business_id=#{@bid}&version=#{@version}")
		@job = JSON.parse(resp)
		if self.signature_valid(@job) == false
			send_json("Signature is invalid, ignoring...", "invalid")
			exit
		elsif @job['status'] == 'default'
			send_json("default", "default")
			exit
		elsif @job['status'] == 'no_categories'
			send_json("No categories selected for business.", "no_categories")
			exit
		elsif @job['status'] == 'paused'
			send_json("Sync is paused for business.", "paused")
			exit
		elsif @job['status'] == 'error'
			send_json("Internal server error", "error")
			exit
		elsif @job['status'] == 'wait'
			send_json("Waiting on job.", "wait")
			exit
		elsif @job['status'] == 'inactive'
			send_json("Subscription is not active for business.", "inactive")
			exit
		end

		send_json("Job is running.", "success")

		# Make it so jobs load other jobs when finished.
		@chained = true
		begin
			data = @job['payload_data']
			ret =  eval(@job['payload'])
			if ret == true
				self.success()
			elsif ret == false
				self.failure()
			end
		rescue => e
			if @browser != nil
				dir = "#{ENV['USERPROFILE']}\\citation\\#{$bid}\\screenshots"
				FileUtils.mkdir_p dir
				file = "#{dir}\\#{SecureRandom.hex}.png"
				@browser.screenshot.save file
				self.failure e || 'nil', e.backtrace.join("\n"), file
			else
				self.failure e || 'nil', e.backtrace.join("\n")
			end
		end
		unless ENV['CITATION_HOST']
			begin
				@browser.close
				@browser = nil
			rescue
			end
			begin
				browser.close
				browser = nil
			rescue
			end
		end
	end

	def success(msg='Job completed successfully.')
		puts "ReportJobSuccess"
		RestClient.put("#{@host}/jobs/#{@job['id']}.json?auth_token=#{@key}&business_id=#{@bid}", :status => 'success', :message => msg, :version => @version)
	end

	def failure(msg='Job failed.', backtrace=nil, screenshot=nil)
		puts "Failure: #{msg}"
		puts "Backtrace: #{backtrace}"
		puts "ReportJobFailure"
		if screenshot and File.exists? screenshot
			puts "screenshot: #{@host}/jobs/#{@job['id']}.json?auth_token=#{@key}&business_id=#{@bid}"
			RestClient.put("#{@host}/jobs/#{@job['id']}.json?auth_token=#{@key}&business_id=#{@bid}", :status => 'failure', :message => msg, :backtrace => backtrace, :screenshot => File.open(screenshot, 'rb'), :version => @version)
		else
			puts "no screenshot: #{@host}/jobs/#{@job['id']}.json?auth_token=#{@key}&business_id=#{@bid}"
			RestClient.put("#{@host}/jobs/#{@job['id']}.json?auth_token=#{@key}&business_id=#{@bid}", :status => 'failure', :backtrace => backtrace, :message => msg, :version => @version)
		end
	end

	def start(name, time_delay=0, msg='Client job.')
		puts "Staring: #{name} next"
		RestClient.post("#{@host}/jobs.json?auth_token=#{@key}&business_id=#{@bid}", :message => msg, :name => name, :delay => time_delay, :version => @version)
	end

	def list()
		RestClient.get("#{@host}/jobs/list.json?auth_token=#{@key}&business_id=#{@bid}", :version => @version)
	end

	def remove(job_id)
		RestClient.delete("#{@host}/jobs/#{job_id}.json?auth_token=#{@key}&business_id=#{@bid}&version=#{@version}")
	end

	def save_account(model, options)
		puts "Saving: #{model}: #{options.to_json}"
		posting = {}
		options.each_key do |key|
			posting["account[#{key}]"] = options[key]
		end
		posting['model'] = model
		RestClient.post("#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}&version=#{@version}", posting)
	end

	def images
		dir = "#{ENV['USERPROFILE']}\\citation\\#{@bid}\\images"
		Dir.entries(dir).grep(/png|jpe?g/i)
	end

	def logo
		dir = "#{ENV['USERPROFILE']}\\citation\\#{@bid}\\"
		if File.exists? dir
			Dir.open(dir).each do |file|
				if file =~ /^logo\./
					return "#{dir}#{file}"
				end
			end
		end
		nil
	end

	def signature_valid(job)
		# NOTE: Need to write this ASAP!
		true
	end

	def booboo(msg='Something went wrong!')
		return if msg =~ /SystemExit/
		RestClient.post("#{@host}/booboos.json?auth_token=#{@key}&business_id=#{@bid}", :message => msg, :version => @version)
	end

	def self.booboo(msg='Something went wrong!', key='',bid='')
		return if msg =~ /SystemExit/
		RestClient.post("#{$host}/booboos.json?auth_token=#{key}&business_id=#{bid}&version=#{$version}", :message => msg)
	end
end
