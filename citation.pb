Global fd

#KEY_LENGTH  = 64
sep.s        = "\"
program      = 0
productName$ = "Citation v1.0"
contactName$ = "Jonathan Jeffus <jonathan@blazingdev.com>"
programName$ = GetPathPart(ProgramFilename()) + "citationCheck.exe"
keyFile$     = GetPathPart(ProgramFilename()) + "key.txt"
key$         = Space(#KEY_LENGTH + 1)
logDir$      = GetHomeDirectory() + "citation"
logDriver$   = logDir$ + sep + "driver.log"
fd           = 0
killFile$    = logDir$ + sep + "kill.txt"

Procedure WriteToLog(line.s)
  FileSeek(fd, Lof(fd))
  WriteStringN(fd, FormatDate("%yyyy-%mm-%dd %hh:%ii:%ss", Date())+": "+line)
EndProcedure

Procedure FatalError(err.l, msg$)
  WriteToLog(msg$)
  msg$ = "Unable to start "+productName$+" please contact "+contactName$+" and report this."+Chr(10)+msg$
  MessageRequester("Error", msg$)
  End err
EndProcedure

If FileSize(logDir$) = -1
  If CreateDirectory(logDir$) = 0
    FatalError(1, "Error: Could not create log directory: "+logDir$)
  EndIf
EndIf

fd = OpenFile(#PB_Any, logDriver$)
If fd <> 0
Else
  FatalError(2, "Error: Could not open log file: "+logDriver$)
EndIf

FillMemory(@key$, #KEY_LENGTH+1, 0)
keyFd = ReadFile(#PB_Any, keyFile$)
If keyFd <> 0
  len = FileSize(keyFile$)
  If len >= #KEY_LENGTH
    len = #KEY_LENGTH
  EndIf
  If ReadData(keyFd, @key$, len) = 0
    FatalError(3, "Error: Error reading access key file: "+keyFile$)
  EndIf
Else
  FatalError(4, "Error: Could not read access key file: "+keyFile$)
EndIf

If FileSize(killFile$) >= 0
  WriteToLog("Dying from KillFile!")
  End 5
EndIf

WriteToLog("Starting up...")
program = RunProgram(programName$, key$, logDir$, #PB_Program_Hide|#PB_Program_Open)
If program <> 0 And ProgramRunning(program)
  WriteToLog("Started...")
Else
  WriteToLog("Error: Process exited with status: "+Str(ProgramExitCode(program)))
  CloseProgram(program)
EndIf

CloseFile(fd)
; IDE Options = PureBasic 4.61 Beta 1 (Windows - x64)
; CursorPosition = 59
; FirstLine = 47
; Folding = -
; EnableXP
; Executable = build\citation.exe
; CompileSourceDirectory
