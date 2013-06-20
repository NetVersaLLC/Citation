;;
;; Copyright (C) 2013 NetVersa, LLC.
;; All rights reserved.
;;

Procedure StartWithWindows(State.b) ; by Joakim Christiansen
  Protected Key.l    = #HKEY_CURRENT_USER
  Protected Path.s   = "Software\Microsoft\Windows\CurrentVersion\Run" 
  Protected Value.s  = "Citation"
  Protected String.s = Chr(34)+GetPathPart(ProgramFilename()) + "citationServer.exe"+Chr(34)
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

; Procedure StartWithWebsite(State.b) ; by Joakim Christiansen
;   Protected Key.l    = #HKEY_CURRENT_USER
;   Protected Path.s   = "Software\Microsoft\Windows\CurrentVersion\RunOnce" 
;   Protected Value.s  = "CitationWebsite"
;   Protected String.s = Chr(34)+GetPathPart(ProgramFilename()) + "website.exe"+Chr(34)
;   Protected CurKey.l 
;   If State 
;     RegCreateKey_(Key,@Path,@CurKey) 
;     RegSetValueEx_(CurKey,@Value,0,#REG_SZ,@String,Len(String)) 
;   Else 
;     RegOpenKey_(Key,@Path,@CurKey) 
;     RegDeleteValue_(CurKey,@Value) 
;   EndIf 
;   RegCloseKey_(CurKey) 
; EndProcedure

Procedure StartServer()
  path.s = GetPathPart(ProgramFilename())
  RunProgram(path + "citationServer.exe", "", path, #PB_Program_Hide)
EndProcedure

status.s = ProgramParameter(0)

If status = "add"
  StartWithWindows(1)
ElseIf status = "start"
  StartServer()
Else
  StartWithWindows(0)  
EndIf
; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 36
; Folding = -
; EnableXP
; Executable = build\register.exe
; IncludeVersionInfo
; VersionField0 = 0.1.0.1
; VersionField1 = 0.1.0.4
; VersionField2 = NetVersa, LLC.
; VersionField3 = Citation Server
; VersionField4 = 1.04
; VersionField5 = 1.0.1
; VersionField6 = Register server process.
; VersionField7 = Register
; VersionField8 = register.exe
; VersionField9 = Copyright (C) 2013 NetVersa, LLC.
