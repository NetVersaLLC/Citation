class ContactJob
    include HTTParty;
    format :json;

    def self.host
        $REMOTE
    end

    base_uri self.host

    def self.run_from_file(file, key, bid)
        @key = key.strip
        @bid = bid.strip
        eval File.open(file, 'r').read
        self.success(job)
    end

    def self.run(key, bid)
        @key = key.strip
        @bid = bid.strip
        job = get("/jobs.json?auth_token=#{@key}&business_id=#{@bid}")
        data = job[:data]
        if job['status'] == 'wait'
            puts "Wait"
            exit
        end
        puts job.inspect
        eval job['payload']
        self.success(job)
    end

    def self.success(job, msg='Job completed successfully.')
        options = { :query => {:status => 'success', :message => msg}}
        res = put("/jobs/#{job[:id]}.json?auth_token=#{@key}&business_id=#{@bid}", options)
        puts res.inspect
    end

    def self.failure(job, msg='Job failed.')
        options = { :query => {:status => 'failure', :message => msg}}
        res = put("/jobs/#{job[:id]}.json?auth_token=#{@key}&business_id=#{@bid}", options)
        puts res.inspect
    end

    def self.start(name, msg='Client job.')
        options = { :query => {:message => msg, :name => name}}
        res = post("/jobs.json?auth_token=#{@key}&business_id=#{@bid}", options)
    end

    def self.booboo(msg='Something went wrong!')
        return if msg =~ /SystemExit/
        options = { :query => {:message => msg, :business_id => @bid } }
        res = post("/booboos.json?auth_token=#{@key}&business_id=#{@bid}", options)
    end
end
