class ContactJob
    def initialize(host, key, bid)
        @host = host
        @key  = key.strip
        @bid  = bid.strip
    end

    def run
        resp = RestClient.get("#{@host}/jobs.json?auth_token=#{@key}&business_id=#{@bid}")
        @job = JSON.parse(resp)
        puts @job.inspect
        data = @job['payload_data']
        if @job['status'] == 'wait'
            puts "Wait"
            exit
        end

        # Make it so jobs load other jobs when finished.
        @chained = true
        begin
            @browser = Watir::Browser.new
	    at_exit do
		    if @browser
			    @browser.close
		    end
	    end
            puts "got browser: #{@browser}"
            ret =  eval(@job['payload'])
            if ret == true
                puts "Job returned true!"
                self.success()
            elsif ret == false
                puts "Job returned false!"
                self.failure()
            else
                puts "Job handled return value!"
                # Presume the script handled reporting back
            end
        rescue => e
            puts "Job had failure!"
            self.failure "#{e}: #{e.backtrace.join("\n")}"
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
        RestClient.put("#{@host}/jobs/#{@job['id']}.json?auth_token=#{@key}&business_id=#{@bid}", :status => 'success', :message => msg)
    end

    def failure(msg='Job failed.')
        RestClient.put("#{@host}/jobs/#{@job['id']}.json?auth_token=#{@key}&business_id=#{@bid}", :status => 'failure', :message => msg)
    end

    def start(name, time_delay=0, msg='Client job.')
        RestClient.post("#{@host}/jobs.json?auth_token=#{@key}&business_id=#{@bid}", :message => msg, :name => name, :delay => time_delay)
    end

    def list()
        RestClient.get("#{@host}/jobs/list.json?auth_token=#{@key}&business_id=#{@bid}")
    end

    def remove(job_id)
        RestClient.delete("#{@host}/jobs/#{job_id}.json?auth_token=#{@key}&business_id=#{@bid}")
    end

    def save_account(model, options)
			posting = {}
			options.each_key do |key|
				posting["account[#{key}]"] = options[key]
			end
			posting['model'] = model
			RestClient.post("#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", options)
		end

    def booboo(msg='Something went wrong!')
        return if msg =~ /SystemExit/
        puts "Posting to: #{@host}/booboos.json?auth_token=#{@key}&business_id=#{@bid}"
        RestClient.post("#{@host}/booboos.json?auth_token=#{@key}&business_id=#{@bid}", :message => msg)
    end

    def self.booboo(msg='Something went wrong!', key='',bid='')
        return if msg =~ /SystemExit/
        puts "Posting to: #{$host}/booboos.json?auth_token=#{key}&business_id=#{bid}"
        RestClient.post("#{$host}/booboos.json?auth_token=#{key}&business_id=#{bid}", :message => msg)
    end
end
