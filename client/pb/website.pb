websiteFile$ = GetPathPart(ProgramFilename()) + "website.txt"
file = OpenFile(#PB_Any, websiteFile$)
website$ = ReadString(file)
CloseFile(file)
RunProgram(website$)
; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 4
; EnableXP