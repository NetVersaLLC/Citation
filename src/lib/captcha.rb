class CAPTCHA
  def self.solve(file, type = 'manual')
    type = type.to_s
    puts "Before captcha post"
    res = RestClient.post "#{$host}/captcha/#{type}?auth_token=#{$key}&business_id=#{$bid}", :image => File.new(file, 'rb')
    puts "After captcha post: #{res.inspect}"
    res = JSON.parse(res)
    res['answer']
  end
end
