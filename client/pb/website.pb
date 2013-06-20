;;
;; Copyright (C) 2013 NetVersa, LLC.
;; All rights reserved.
;;

websiteFile$ = GetPathPart(ProgramFilename()) + "website.txt"
file = OpenFile(#PB_Any, websiteFile$)
website$ = ReadString(file)
CloseFile(file)
RunProgram(website$)
; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 4
; EnableXP
; Executable = build\website.exe
; CompileSourceDirectory
; IncludeVersionInfo
; VersionField0 = 0.1.0.1
; VersionField1 = 0.1.0.4
; VersionField2 = NetVersa, LLC.
; VersionField3 = Citation Server
; VersionField4 = 1.04
; VersionField5 = 1.0.1
; VersionField6 = Open sign up website.
; VersionField7 = Website
; VersionField8 = website.exe
; VersionField9 = Copyright (C) 2013 NetVersa, LLC.
