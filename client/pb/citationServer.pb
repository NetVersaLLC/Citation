;;
;; Copyright (C) 2013 NetVersa, LLC.
;; All rights reserved.
;;

Global programName$ = GetPathPart(ProgramFilename()) + "citation.exe"
Global waitTime     = 60000
Global killTime     = 300000

Procedure.l RunExe()
  PrintN("Running program: "+programName$)
  program = RunProgram(programName$, "", GetPathPart(ProgramFilename()), #PB_Program_Open)
  ProcedureReturn program
EndProcedure  

Procedure.l WaitForRun()
  timer = 0
  While timer < waitTime
    Delay(1000)
    timer = timer + 1000
  Wend
  program = RunExe()
  ProcedureReturn program
EndProcedure

Procedure WaitForProgram(program)
  timer = 0
  While timer < killTime
    Delay(1000)
    timer = timer + 1000
    If IsProgram(program) And ProgramRunning(program) = 0
      CloseProgram(program)
      ProcedureReturn
    EndIf
  Wend
  PrintN("Program: "+Str(program))
  PrintN("Process ID: "+Str(ProgramID(program)))
  If IsProgram(program)
    If ProgramRunning(program)
      PrintN("Killing process: "+Str(program))
      GenerateConsoleCtrlEvent_(#CTRL_C_EVENT, 0)
      Delay(2000)
      KillProgram(program)
    EndIf
    CloseProgram(program)
  EndIf 
EndProcedure

While 1
  program = WaitForRun()
  WaitForProgram(program)
  Delay(1000)
Wend
; IDE Options = PureBasic 4.61 (Windows - x86)
; ExecutableFormat = Console
; CursorPosition = 34
; Folding = -
; Executable = ..\..\build\server.exe
; IncludeVersionInfo
; VersionField0 = 0.1.0.1
; VersionField1 = 0.1.0.4
; VersionField2 = NetVersa, LLC.
; VersionField3 = Citation Server
; VersionField4 = 1.04
; VersionField5 = 1.0.1
; VersionField6 = Business citation creator server process.
; VersionField7 = Citation Server
; VersionField8 = citationServer.exe
; VersionField9 = Copyright (C) 2013 NetVersa, LLC.
