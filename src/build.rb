#
# Copyright (C) 2013 NetVersa, LLC.
# All rights reserved.
#

require 'rubygems'
require 'fileutils'
require 'iniparse'

if RUBY_VERSION != '1.8.7'
  STDERR.puts "Wrong ruby version: #{RUBY_VERSION}"
  exit 
end

# We are building, notify sub-scripts.
ENV['BUILD']         = 'active'

# Now set build options.
ini = IniParse.parse( File.read("build_options.ini") )
old = ini['build']['build_version']
ini['build']['build_version'].gsub!(/(\d+)$/) { ($1.to_i + 1).to_s }
ENV['PRODUCT_NAME']  = ini['build']['product_name']
ENV['BUILD_VERSION'] = ini['build']['build_version']
ENV['COPYRIGHT']     = ini['build']['copyright']
ENV['COMPANY_NAME']  = ini['build']['company_name']
File.open("build_options.ini", "w").write ini.to_ini

script = File.read("client/ruby/citationCheck.rb")
script.gsub!(/\d+\.\d+\.\d+\.\d+/, ini['build']['build_version'])
f = File.open("client/ruby/citationCheck.rb", "w")
f.write script
f.close

STDERR.puts "Building: #{ini['build']['build_version']}"

STDERR.puts "Cleaning..."
system "rm -rf build/*"
system "rm -rf dist/*"

STDERR.puts "Building citationCheck.exe"
system "mkexy client\\ruby\\citationCheck.rb onetwo 1"
system "exerb client\\ruby\\citationCheck.exy"

STDERR.puts "Copying data"
system "cp -r atoms build/atoms"
system "cp prefs.json build"
system "cp webdriver.xpi build"
system "cp files\\firefox.exe build"
system "cp files\\ssleay32-0.9.8-msvcrt.dll build"
system "cp files\\libeay32-0.9.8-msvcrt.dll build"
system "cp files\\libiconv2.dll build"
system "cp files\\php_bcompiler.dll build"
system "cp files\\php_curl.dll build"
system "cp files\\php_win32std.dll build"
system "cp files\\php_winbinder.dll build"
system "cp files\\php5ts.dll build"
system "cp files\\php-embed.ini build"
system "cp files\\ca-bundle.crt build"
system "cp files\\Newtonsoft.Json.dll build"
system "cp files\\login.exe build"
system "cp files\\gusto.exe build"
system "cp files\\citationMaker.exe build"

STDERR.puts "Moving to build/"
File.rename "client\\ruby\\citationCheck.exe", "build/citationCheck.exe"

STDERR.puts "Compiling citation.exe"
system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "client\\pb\\switcher.pb", "/exe", "build/switcher.exe"
system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "client\\pb\\uninst.pb", "/exe", "build/uninstall.exe"
system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "client\\pb\\glogin.pb", "/xp", "/console", "/exe", "build/glogin.exe"
system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "client\\pb\\website.pb", "/exe", "build/website.exe"
system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "client\\pb\\register.pb", "/exe", "build/register.exe"
system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "client\\pb\\citationServer.pb", "/exe", "build/citationServer.exe"
system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "client\\pb\\citation.pb", "/exe", "build/citation.exe"
system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "client\\pb\\restart.pb", "/exe", "build/restart.exe"
system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "panels\\captcha\\captcha.pb", "/xp",  "/console", "/exe", "build/captcha.exe"
system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "panels\\incoming_call\\incoming_call.pb", "/xp", "/console", "/exe", "build/incoming_call.exe"
system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "panels\\update\\update.pb", "/xp", "/console", "/exe", "build/ask.exe"
system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "panels\\verify_account\\verify_account.pb", "/xp", "/console", "/exe", "build/verify_account.exe"
# system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "panels\\login\\main.pb", "/xp", "/exe", "build/login.exe"

files = {
	"website.exe" => 'Open our website.',
	"verify_account.exe" => 'Display an account verification dialog.',
	"citation.exe" => 'Citation process monitor.',
	"citationServer.exe" => 'Business citation creator server process.',
	"register.exe" => 'Register/deregister processes.',
	"incoming_call.exe" => 'Warn about an incoming call.',
	"ask.exe" => 'Ask to install a new software update.',
	"captcha.exe" => 'Display a captcha solution request.',
	"citationCheck.exe" => 'Check for new citation creation and updates.',
	"restart.exe" => 'Restart the citation server process.',
	"switcher.exe" => 'Switch to alternate desktop.',
	"uninstall.exe" => 'Uninstall the client software.',
	"glogin.exe" => 'Get account information for the G site.',
	"login.exe" => 'Login to the system.',
	"gusto.exe" => 'Perform updates and syncs.'
}


Dir.open("build").each do |file|
	next unless file =~ /\.exe$/i
	next if file =~ /^firefox.exe$/i
	STDERR.puts "Adding config: #{file}"
	#unless file =~ /gusto.exe/
	system "files\\ChangeVersion.exe build\\#{file} fileversion=#{ENV['BUILD_VERSION']} productversion=#{ENV['BUILD_VERSION']} filedate=now key:LegalCopyright=\"#{ENV['COPYRIGHT']}\" key:CompanyName=\"#{ENV['COMPANY_NAME']}\" key:FileDescription=\"#{files[file]}\" key:OriginalFilename=\"#{file}\" key:ProductName=\"#{ENV['PRODUCT_NAME']}\" appicon=files\\map.ico"
	#end
	STDERR.puts "Signing: #{file}"
	system "signtool sign /f certs\\netversa.pfx /p FWq31i1GSl /t http://timestamp.comodoca.com/authenticode build\\#{file}"
end

Dir.chdir('..')
STDERR.puts "buildAll #{ENV['ENVIRONMENT']} #{ENV['BUILD_VERSION']}"
# system("buildAll #{ENV['ENVIRONMENT']} #{ENV['BUILD_VERSION']}")

__END__
if ENV['TESTING_CITATION'] == 'active'
	exit
end
STDERR.puts "Building Setup.exe"
system 'sh -c "rm -v labels/*/Setup.exe"'
Dir.open("./labels").each do |label|
    next unless File.directory? "./labels/#{label}"
    next if label =~ /^\./
    labeldir = "labels\\#{label}"
    system "cp -fv installer.bim build.bim"
    STDERR.puts "bin\\whitelabel.exe #{label}"
    system "bin\\whitelabel.exe #{label}"
    system "cp -fv #{labeldir}\\website.txt build"
    system "rm -v Setup.exe"
    system "C:\\Program Files (x86)\\Bytessence Install Maker\\BInstallMaker.exe", "-compile", "C:\\Users\\jonathan\\dev\\Citation\\src\\build.bim", "C:\\Users\\jonathan\\dev\\Citation\\src\\installer.log"

    FileUtils.mkdir_p labeldir
    # This is signed after the bid and key have been injected on the server.
    # system "signtool sign /f certs\\netversa.pfx /p FWq31i1GSl /t http://timestamp.comodoca.com/authenticode Setup.exe"
    STDERR.puts "Copying to #{labeldir}"
    system "copy Setup.exe #{labeldir}"
end

STDERR.puts "Don't forget!"
STDERR.puts "Sync using sync_with_serv.bat.."
#system "C:\\Users\\jonathan\\dev\\Citation\\sync_with_server.bat"
