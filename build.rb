#
# Copyright (C) 2012 NetVersa, LLC.
# All rights reserved.
#

STDERR.puts "Wrong ruby version: #{RUBY_VERSION}" and exit if RUBY_VERSION != '1.8.7'

STDERR.puts "Cleaning..."
system "rm -rf build/*"
system "rm -rf dist/*"

STDERR.puts "Adding files.."
system "cp client\\populate\\populate.exe build"
system "cp files\\IAccessibleDLL.dll build"
system "cp files\\IEDialog.dll build"
system "cp files\\libiconv2.dll build"
system "cp files\\libeay32-1.0.0-msvcrt.dll build"
system "cp files\\ssleay32-1.0.0-msvcrt.dll build"
system "cp -r files\\win32 build"

STDERR.puts "Building citationCheck.exe"
system "exerb client\\ruby\\citationCheck.exy"

STDERR.puts "Moving to build/"
File.rename "client\\ruby\\citationCheck.exe", "build/citationCheck.exe"

STDERR.puts "Packing..."
system "upx --best build/citationCheck.exe"

STDERR.puts "Compiling citation.exe"
system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "client\\pb\\citation.pb", "/exe", "build/citation.exe"
system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "panels\\captcha\\captcha.pb", "/console", "/exe", "build/captcha.exe"
system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "panels\\incoming_call\\incoming_call.pb", "/console", "/exe", "build/incoming_call.exe"
system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "panels\\update\\update.pb", "/console", "/exe", "build/ask.exe"
system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "panels\\verify_account\\verify_account.pb", "/console", "/exe", "build/verify_account.exe"

STDERR.puts "Building Setup.exe"
system "C:\\Program Files (x86)\\Bytessence InstallMaker\\BInstallMaker.exe", "-compile", "C:\\Users\\jonathan\\dev\\Citation\\installer.bim", "C:\\Users\\jonathan\\dev\\Citation\\installer.log"

STDERR.puts "Copying to Contact"
system "copy Setup.exe ..\\Contact\\doc"
