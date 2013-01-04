class CAPTCHA
  def self.solve(file, type = 'manual')
    type = type.to_s
    if type == 'manual'
        res = `captcha.exe "#{file}"`
    else
        res = RestClient.post "#{$host}/captcha/#{type}?auth_token=#{$key}&business_id=#{$bid}", :image => File.new(file, 'rb')
    end
    res
  end
end
