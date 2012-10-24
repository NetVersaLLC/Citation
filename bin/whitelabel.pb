OpenConsole()

whiteLabel.s = "Splatr"; ProgramParameter(1)

programName.s = ""
programWebsite.s = ""
supportEmail.s = ""
outpuFile.s = ""
fileDescription.s = ""
productName.s = ""
website.s = ""
wizardImage.s = ""
headerImage.s = ""
readme.s = ""
license.s = ""

If OpenPreferences("labels\"+whiteLabel+"\installer.bim")
  If ExaminePreferenceGroups()
    While NextPreferenceGroup()
      If PreferenceGroupName() = "GeneralInformation"
        programName = ReadPreferenceString("ProgramName", "")
        programWebsite = ReadPreferenceString("ProgramWebsite", "")
        supportEmail = ReadPreferenceString("SupportEmail", "")
        outpuFile = ReadPreferenceString("OutputFile", "")
      ElseIf PreferenceGroupName() = "InstallerExeInfo"
        fileDescription.s = ReadPreferenceString("FileDescription", "")
        productName.s = ReadPreferenceString("ProductName", "")
        website.s = ReadPreferenceString("Website", "")
      ElseIf PreferenceGroupName() = "LookAndFeel"
        wizardImage.s = ReadPreferenceString("WizardImage", "")
        headerImage.s = ReadPreferenceString("HeaderImage", "")
      ElseIf PreferenceGroupName() = "ReadmeFiles"
        readme.s = ReadPreferenceString("-1", "")
      ElseIf PreferenceGroupName() = "LicenseFiles"
        license.s = ReadPreferenceString("-1", "")
      EndIf
    Wend
  EndIf
  ClosePreferences()
EndIf

PrintN("Patching installer for: "+whiteLabel)
PrintN("ProgramName: "+programName)
PrintN("ProgramWebsite: "+programWebsite)
PrintN("SupportEmail: "+supportEmail)
PrintN("OutputFile: "+outpuFile)
PrintN("FileDescription: "+fileDescription)
PrintN("ProductName: "+productName)
PrintN("Website: "+website)
PrintN("WizardImage: "+wizardImage)
PrintN("HeaderImage: "+headerImage)
PrintN("ReadMe: "+readme)
PrintN("License: "+license)

If OpenPreferences("build.bim")
  If ExaminePreferenceGroups()
    While NextPreferenceGroup()
      If PreferenceGroupName() = "GeneralInformation"
        WritePreferenceString("ProgramName", programName)
        WritePreferenceString("ProgramWebsite", programWebsite)
        WritePreferenceString("SupportEmail", supportEmail)
        WritePreferenceString("OutputFile", outpuFile)
      ElseIf PreferenceGroupName() = "InstallerExeInfo"
        WritePreferenceString("FileDescription", fileDescription)
        WritePreferenceString("ProductName", productName)
        WritePreferenceString("Website", website)
      ElseIf PreferenceGroupName() = "LookAndFeel"
        WritePreferenceString("WizardImage", wizardImage)
        WritePreferenceString("HeaderImage", headerImage)
      ElseIf PreferenceGroupName() = "ReadmeFiles"
        WritePreferenceString("-1", readme)
      ElseIf PreferenceGroupName() = "LicenseFiles"
        WritePreferenceString("-1", license)
      EndIf
    Wend
  EndIf
  ClosePreferences()
EndIf
; IDE Options = PureBasic 4.60 (MacOS X - x86)
; CursorPosition = 76
; EnableXP