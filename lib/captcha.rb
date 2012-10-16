class CAPTCHA
  def self.solve(obj, type = 'recaptcha')

    obj.right_click

    gets

    file = `populate.exe png`
    #if type == 'manual' or type == :manual
    #    res = `captcha.exe "#{file}"`
    #else
    #    res = RestClient.post "#{$REMOTE}/captcha/#{type}", :image => File.new(file, 'rb')
    #end
    #res
  end
end
