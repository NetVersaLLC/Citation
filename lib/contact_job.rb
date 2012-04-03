class ContactJob
    include HTTParty;
    format :json;
    #base_uri "http://localhost:3000"
    base_uri "http://cite.netversa.com"
    # debug_output

    def self.run_from_file(file, key)
        business = get('/businesses.json?auth_token='+key)
        business = business.parsed_response['business']
        eval File.open(file, 'r').read
    end

    def self.run(key)
        business = get('/businesses.json?auth_token='+key)
        business = business.parsed_response['business']
        job = get('/jobs.json?auth_token='+key)
        if job['status'] == 'wait'
            STDERR.puts "Wait"
            exit
        end
        eval job['payload']
    end

end
