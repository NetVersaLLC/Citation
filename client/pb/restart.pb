Procedure.b CheckRunningExe(FileName.s)
  Protected snap.l , Proc32.PROCESSENTRY32 , dll_kernel32.l
  FileName = GetFilePart( FileName )
  dll_kernel32 = OpenLibrary (#PB_Any, "kernel32.dll")
  If dll_kernel32
    snap = CallFunction (dll_kernel32, "CreateToolhelp32Snapshot",$2, 0)
    If snap
      Proc32\dwSize = SizeOf (PROCESSENTRY32)
      If CallFunction (dll_kernel32, "Process32First", snap, @Proc32) 
        While CallFunction (dll_kernel32, "Process32Next", snap, @Proc32)
          If PeekS (@Proc32\szExeFile)=FileName
            CloseHandle_ (snap)
            CloseLibrary (dll_kernel32)
            ProcedureReturn #True
          EndIf
        Wend
      EndIf   
      CloseHandle_ (snap)
    EndIf
    CloseLibrary (dll_kernel32)
  EndIf
  ProcedureReturn #False
EndProcedure

path.s = GetPathPart(ProgramFilename())
SetCurrentDirectory(path)
RunProgram("taskkill /F /T /IM citationServer.exe")
RunProgram("citationServer.exe")

Delay(1000)

If CheckRunningExe("citationServer.exe") = #True
  MessageRequester("Restarted", "The server process was restarted!")
Else
  MessageRequester("Error", "The server process was not able to be started!")  
EndIf
; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 35
; Folding = -
; EnableXP