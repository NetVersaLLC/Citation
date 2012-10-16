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
            STDERR.puts "Payload: #{@job['payload']}"
            if eval(@job['payload']) == nil
                self.success()
            else
                self.failure()
            end
        rescue => e
            self.failure "#{e}: #{e.backtrace.join("\n")}"
        end
    end

    def success(msg='Job completed successfully.')
        res = RestClient.put("#{@host}/jobs/#{@job['id']}.json?auth_token=#{@key}&business_id=#{@bid}", :status => 'success', :message => msg)
    end

    def failure(msg='Job failed.')
        res = RestClient.put("#{@host}/jobs/#{@job['id']}.json?auth_token=#{@key}&business_id=#{@bid}", :status => 'failure', :message => msg)
    end

    def start(name, msg='Client job.')
        res = RestClient.post("#{@host}/jobs.json?auth_token=#{@key}&business_id=#{@bid}", :message => msg, :name => name)
    end

    def booboo(msg='Something went wrong!')
        return if msg =~ /SystemExit/
        STDERR.puts "Posting to: #{@host}/booboos.json?auth_token=#{@key}&business_id=#{@bid}"
        res = RestClient.post("#{@host}/booboos.json?auth_token=#{@key}&business_id=#{@bid}", :message => msg)
    end

    def self.booboo(msg='Something went wrong!')
        return if msg =~ /SystemExit/
        res = RestClient.post("#{@host}/booboos.json", :message => msg)
    end
end
