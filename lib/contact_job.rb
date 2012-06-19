class ContactJob
    include HTTParty;
    format :json;

    def self.host
        'https://citation.netversa.com'
    end

    def self.run_from_file(file, key, bid)
        @key = key
        @bid = bid
        eval File.open(file, 'r').read
    end

    def self.run(key, bid)
        @key = key
        @bid = bid
        job = get("/jobs.json?auth_token=#{@key}&business_id=#{@bid}")
        data = job[:data]
        if job['status'] == 'wait'
            STDERR.puts "Wait"
            exit
        end
        eval job['payload']
    end

    def self.success(job, msg='Job completed successfully.')
        options = { :query => {:status => 'success', :message => msg}}
        res = put("/jobs/#{job[:id]}.json?auth_token=#{@key}", options)
        STDERR.puts res.inspect
    end

    def self.failure(job, msg='Job failed.')
        options = { :query => {:status => 'failure', :message => msg}}
        res = put("/jobs/#{job[:id]}.json?auth_token=#{@key}", options)
        STDERR.puts res.inspect
    end

    def self.queue(payload, msg='Client job.')
        options = { :query => {:message => msg, :payload => payload}}
        res = post("/jobs.json?auth_token=#{@key}", options)
    end

    def self.booboo(msg='Something went wrong!')
        options = { :query => {:message => msg, :business_id => @bid } }
        res = post("/booboos.json?auth_token=#{@key}", options)
    end

    base_uri self.host
end
