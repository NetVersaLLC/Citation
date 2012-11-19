class CAPTCHA
  def self.solve(file, type = 'manual')
    if type == 'manual' or type == :manual
        res = `captcha.exe "#{file}"`
    else
        res = RestClient.post "#{$host}/captcha/#{type}", :image => File.new(file, 'rb')
    end
    res
  end
end
