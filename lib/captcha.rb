class CAPTCHA
  def solve(file, type = 'recaptcha')
    res = RestClient.post "#{$REMOTE}/captcha/#{type}", :image => File.new(file, 'rb')
  end
end
