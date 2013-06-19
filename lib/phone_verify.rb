#!/usr/bin/env ruby

class PhoneVerify
	def self.retrieve_code(site)
		retries = 0
		begin 
			res = RestClient.get "#{$host}/codes/#{$bid}/#{site}.json"
			if res
				response = JSON.parse(res)
				if response['entered'] == 'yes'
					return response['code']
				end
			end
			retries += 1
			sleep 10
		end while retries < 25
		raise "Phone code never entered!"
	end
	def self.send_code(site, code)
    res = RestClient.post "#{$host}/codes/#{$bid}/#{site}.json?code=#{code}"
	end
	def self.ask_for_code()
		code = `incoming_call.exe`
	end
	def self.enter_code(code)
		`verify_account.exe #{code}`
	end
end
