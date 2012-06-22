#
# Copyright (C) 2012 NetVersa, LLC.
# All rights reserved.
#

STDERR.puts "Wrong ruby version: #{RUBY_VERSION}" and exit if RUBY_VERSION != '1.8.7'
STDERR.puts "Cleaning..."
system "rm -rf build/*"
system "rm -rf dist/*"
STDERR.puts "Adding add_task.bat"
system "cp add_task.bat build"
system "cp libiconv2.dll build"
system "cp libeay32-1.0.0-msvcrt.dll build"
system "cp ssleay32-1.0.0-msvcrt.dll build"
system "cp remove_task.bat build"
#STDERR.puts "Building citationCheck.exy"
#system "mkexy citationCheck.rb"
STDERR.puts "Building citationCheck.exe"
system "exerb citationCheck.exy"
STDERR.puts "Moving to build/"
File.rename "citationCheck.exe", "build/citationCheck.exe"
STDERR.puts "Packing..."
system "upx --best build/citationCheck.exe"
STDERR.puts "Compiling citation.exe"
system "C:\\Program Files (x86)\\PureBasic\\Compilers\\pbcompiler.exe", "citation.pb", "/exe", "build/citation.exe"
STDERR.puts "Building Setup.exe"
system "C:\\Program Files (x86)\\Bytessence InstallMaker\\BInstallMaker.exe", "-compile", "C:\\Users\\jonathan\\dev\\Citation\\installer.bim", "C:\\Users\\jonathan\\dev\\Citation\\installer.log"
STDERR.puts "Copying to Contact"
system "copy dist\\Setup.exe ..\\Contact\\doc"
#STDERR.puts "Adding key.txt"
#system "ruby add_key.rb"
#system "ruby check_key.rb"
