class ContactJob
    include HTTParty;
    format :json;

    def self.host
        if ENV['RAILS_ENV'] == 'production'
            'https://cite.netversa.com'
        else
            'http://localhost:3000'
        end
    end

    def self.run_from_file(file, key)
        business = get('/businesses.json?auth_token='+key)
        business = business.parsed_response['business']
        STDERR.puts "Got: #{business.inspect}"
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

    base_uri self.host
end
