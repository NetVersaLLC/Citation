#!/usr/bin/env ruby

require 'rubygems'
require 'fileutils'
require 'inifile'

label = ARGV.shift
output = ARGV.shift || "C:\\Users\\jonathan\\dev\\Citation\\Setup.exe"

FileUtils.cp 'installer.bim', 'build.bim'
whitelabel = IniFile.new "labels/#{label}/installer.bim"
installer  = IniFile.new "build.bim"

installer['GeneralInformation']['ProgramName']    = whitelabel['GeneralInformation']['ProgramName']
installer['GeneralInformation']['ProgramWebsite'] = whitelabel['GeneralInformation']['ProgramWebsite']
installer['GeneralInformation']['SupportEmail']   = whitelabel['GeneralInformation']['SupportEmail']
installer['GeneralInformation']['OutputFile']     = output
installer['InstallerExeInfo']['FileDescription']  = whitelabel['InstallerExeInfo']['FileDescription']
installer['InstallerExeInfo']['ProductName']      = whitelabel['InstallerExeInfo']['ProductName']
installer['InstallerExeInfo']['Website']          = whitelabel['InstallerExeInfo']['Website']
installer['LookAndFeel']['WizardImage']           = whitelabel['LookAndFeel']['WizardImage']
installer['LookAndFeel']['HeaderImage']           = whitelabel['LookAndFeel']['HeaderImage']
installer['ReadmeFiles']['-1']                    = whitelabel['ReadmeFiles']['-1']
installer['LicenseFiles']['-1']                   = whitelabel['LicenseFiles']['-1']

installer.write
