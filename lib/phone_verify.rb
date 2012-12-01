#!/usr/bin/env ruby

class PhoneVerify
    def self.ask_for_code()
        code = `incoming_call.exe`
    end
    def self.enter_code(code)
        `verify_account.exe #{code}`
    end
end
