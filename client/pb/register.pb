Procedure StartWithWindows(State.b) ; by Joakim Christiansen
  Protected Key.l    = #HKEY_CURRENT_USER
  Protected Path.s   = "Software\Microsoft\Windows\CurrentVersion\Run" 
  Protected Value.s  = "Citation"
  Protected String.s = Chr(34)+GetPathPart(ProgramFilename()) + "server.exe"+Chr(34)
  Protected CurKey.l 
  If State 
    RegCreateKey_(Key,@Path,@CurKey) 
    RegSetValueEx_(CurKey,@Value,0,#REG_SZ,@String,Len(String)) 
  Else 
    RegOpenKey_(Key,@Path,@CurKey) 
    RegDeleteValue_(CurKey,@Value) 
  EndIf 
  RegCloseKey_(CurKey) 
EndProcedure

Procedure StartWithWebsite(State.b) ; by Joakim Christiansen
  Protected Key.l    = #HKEY_CURRENT_USER
  Protected Path.s   = "Software\Microsoft\Windows\CurrentVersion\RunOnce" 
  Protected Value.s  = "CitationWebsite"
  Protected String.s = Chr(34)+GetPathPart(ProgramFilename()) + "website.exe"+Chr(34)
  Protected CurKey.l 
  If State 
    RegCreateKey_(Key,@Path,@CurKey) 
    RegSetValueEx_(CurKey,@Value,0,#REG_SZ,@String,Len(String)) 
  Else 
    RegOpenKey_(Key,@Path,@CurKey) 
    RegDeleteValue_(CurKey,@Value) 
  EndIf 
  RegCloseKey_(CurKey) 
EndProcedure

StartWithWindows(1)
StartWithWebsite(1)
; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 16
; Folding = -
; EnableXP