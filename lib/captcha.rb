class CAPTCHA
  def self.solve(file, type = 'manual')
    type = type.to_s
    if type == 'manual'
        res = RestClient.post "http://captcha.netversa.com:8080/upload.json?auth_token=UYEjkDy6pppR2pCZrss7", :file => File.new(file, 'rb')
        res = res['solution']
    else
        res = RestClient.post "#{$host}/captcha/#{type}?auth_token=#{$key}&business_id=#{$bid}", :image => File.new(file, 'rb')
    end
    res
  end
end
