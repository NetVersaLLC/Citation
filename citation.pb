Global fd

sep.s        = "\"
program      = 0
productName$ = "Citation v1.0"
contactName$ = "Jonathan Jeffus <jonathan@blazingdev.com>"
programName$ = GetPathPart(ProgramFilename()) + "citationCheck.exe"
logDir$      = GetHomeDirectory() + "citation"
logDriver$   = logDir$ + sep + "driver.log"
fd           = 0
killFile$    = logDir$ + sep + "kill.txt"

Procedure WriteToLog(line.s)
  FileSeek(fd, Lof(fd))
  WriteStringN(fd, FormatDate("%yyyy-%mm-%dd %hh:%ii:%ss", Date())+": "+line)
EndProcedure

Procedure FatalError(log$, msg$, err.l)
  WriteToLog(log$)
  MessageRequester("Error", msg$)
  End err
EndProcedure

If FileSize(logDir$) = -1
  If CreateDirectory(logDir$) = 0
    MessageRequester("Error", "Unable to start "+productName$+" please contact "+contactName$+" and report this."+Chr(10)+"Error: Could not create log directory: "+logDir$)
    End 1    
  EndIf
EndIf

fd = OpenFile(#PB_Any, logDriver$)
If fd <> 0
Else
  MessageRequester("Error", "Unable to start "+productName$+" please contact "+contactName$+" and report this."+Chr(10)+"Error: Could not open log file: "+logDriver$)
  End 1  
EndIf

If FileSize(killFile$) >= 0
  WriteToLog("Dying from KillFile!")
  End 1
EndIf

WriteToLog("Starting up...")
program = RunProgram(programName$, "", logDir$, #PB_Program_Hide|#PB_Program_Open)
If program <> 0 And ProgramRunning(program)
  WriteToLog("Started...")
Else
  WriteToLog("Error: Process exited with status: "+Str(ProgramExitCode(program)))
  CloseProgram(program)
EndIf

CloseFile(fd)
; IDE Options = PureBasic 4.61 Beta 1 (Windows - x64)
; CursorPosition = 20
; Folding = -
; EnableXP
; Executable = citation.exe
; CompileSourceDirectory