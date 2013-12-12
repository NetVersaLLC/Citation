OpenConsole()

whiteLabel.s = ProgramParameter(0)

; programName.s = ""
buildVersion.s = GetEnvironmentVariable("BUILD_VERSION")
companyName.s = GetEnvironmentVariable("COMPANY_NAME")
copyright.s = GetEnvironmentVariable("COPYRIGHT")
productName.s = GetEnvironmentVariable("PROGRAM_NAME")
programName.s = ""
programWebsite.s = ""
supportEmail.s = ""
outpuFile.s = ""
fileDescription.s = ""
website.s = ""
wizardImage.s = ""
headerImage.s = ""
readme.s = ""
license.s = ""


whiteLabelBim.s =  "labels\"+whiteLabel+"\installer.bim"
If OpenPreferences(whiteLabelBim)
  If ExaminePreferenceGroups()
    While NextPreferenceGroup()
      If PreferenceGroupName() = "GeneralInformation"
        programName = ReadPreferenceString("ProgramName", "")
        programWebsite = ReadPreferenceString("ProgramWebsite", "")
        supportEmail = ReadPreferenceString("SupportEmail", "")
        outpuFile = ReadPreferenceString("OutputFile", "")
      ElseIf PreferenceGroupName() = "InstallerExeInfo"
        fileDescription.s = ReadPreferenceString("FileDescription", "")
        ; productName.s = ReadPreferenceString("ProductName", "")
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
Else
  PrintN("Cannot open whitelabel file: "+whiteLabelBim)
  End 3
EndIf

PrintN("Patching installer for: "+whiteLabel)
PrintN("Build Version: "+buildVersion)
PrintN("Company Name: "+companyName)
PrintN("Copyright: "+copyright)
PrintN("Program Name: "+programName)
PrintN("ProgramWebsite: "+programWebsite)
PrintN("SupportEmail: "+supportEmail)
PrintN("OutputFile: "+outpuFile)
PrintN("FileDescription: "+fileDescription)
PrintN("Website: "+website)
PrintN("WizardImage: "+wizardImage)
PrintN("HeaderImage: "+headerImage)
PrintN("ReadMe: "+readme)
PrintN("License: "+license)

buildVersion.s = GetEnvironmentVariable("BUILD_VERSION")
companyName.s = GetEnvironmentVariable("COMPANY_NAME")
copyright.s = GetEnvironmentVariable("COPYRIGHT")
productName.s = GetEnvironmentVariable("PRODUCT_NAME")


file = OpenFile( #PB_Any, "build\website.txt" )
WriteString(file, programWebsite)
CloseFile( file )

If OpenPreferences("build.bim")
  If ExaminePreferenceGroups()
    While NextPreferenceGroup()
      If PreferenceGroupName() = "GeneralInformation"
        WritePreferenceString("CompanyName", companyName)
        WritePreferenceString("Copyright", copyright)
        WritePreferenceString("ProgramVersion", buildVersion)
        WritePreferenceString("ProgramName", programName)
        WritePreferenceString("ProgramWebsite", programWebsite)
        WritePreferenceString("SupportEmail", supportEmail)
        WritePreferenceString("OutputFile", outpuFile)
      ElseIf PreferenceGroupName() = "InstallerExeInfo"
        WritePreferenceString("CompanyName", companyName)
        WritePreferenceString("Copyright", copyright)
        WritePreferenceString("FileDescription", fileDescription)
        WritePreferenceString("ProductName", productName)
        WritePreferenceString("ProductVersion", buildVersion)
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
Else
  PrintN("Could not open build.bim!")
  End 5
EndIf
; IDE Options = PureBasic 4.61 (Windows - x86)
; ExecutableFormat = Console
; CursorPosition = 9
; EnableXP
; Executable = whitelabel.exe