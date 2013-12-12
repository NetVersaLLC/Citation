require 'rubygems'
require 'watir-webdriver'
require 'fileutils'

path = ARGV.shift
if File.exists? path
  FileUtils.rm path
end
browser = Watir::Browser.start 'http://www.explosm.net/comics/'
browser.image(:xpath, '//*[@id="maincontent"]/div[2]/div[2]/div[1]/img').save path
system "start comic.png"
