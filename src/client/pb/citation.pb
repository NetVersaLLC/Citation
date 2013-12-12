;;
;; Copyright (C) 2013 NetVersa, LLC.
;; All rights reserved.
;;

XIncludeFile "registry.pb"

Declare.l OpenLog(logFile$)
Declare.l ReadKeyfile(*key, keyFile$)
Declare   ReportBooboo(msg.s)

Global logDriver, logErr, logOut
Global bid$, key$, booboosUrl$

#KEY_LENGTH  = 64
sep.s        = "\"
program      = 0
copyright$   = "Copyright (C) 2012 NetVersa, LLC."
productName$ = "Citation v1.0"
contactName$ = "Jonathan Jeffus <jonathan.jeffus@netversa.com>"
booboosUrl$  = "https://citation.netversa.com/booboos.json"
programName$ = GetPathPart(ProgramFilename()) + "citationCheck.exe"
keyFile$     = GetPathPart(ProgramFilename()) + "key.txt"
bidFile$     = GetPathPart(ProgramFilename()) + "bid.txt"
key$         = Space(#KEY_LENGTH + 1)
bid$         = Space(#KEY_LENGTH + 1)

If ProgramParameter(1) <> ""
  key$ = ProgramParameter(0)
  bid$ = ProgramParameter(1)
Else
  If ReadKeyfile(@key$, keyFile$)
    Debug "Can't open keyfile: "+keyFile$
    ReportBooboo("Can't open keyfile: "+keyFile$)
    End 9
  EndIf
  If ReadKeyfile(@bid$, bidFile$)
    Debug "Can't open bidfile: "+bidFile$
    ReportBooboo("Can't open bidfile: "+bidFile$)
    End
  EndIf
EndIf


logDir$      = GetHomeDirectory() + "citation"
If FileSize(logDir$) <> -2
  If CreateDirectory(logDir$) = 0
    ReportBooboo(bid$+": Could not create log directory: "+logDir$)
   End
  EndIf
EndIf
If FileSize(logDir$ + sep + bid$) <> -2
  If CreateDirectory(logDir$ + sep + bid$) = 0
    ReportBooboo(bid$+": Could not create log directory: "+logDir$+sep+bid$)
    End
  EndIf
EndIf
logDriver$   = logDir$ + sep + bid$ + sep + "driver.log"
logErr$      = logDir$ + sep + bid$ + sep + "err.txt"
logOut$      = logDir$ + sep + bid$ + sep + "out.txt"
killFile$    = logDir$ + sep + bid$ + sep + "kill.txt"

Debug "Opening logs"

logDriver = OpenLog(logDriver$)
logErr    = OpenLog(logErr$)
logOut    = OpenLog(logOut$)

Debug "Logs opened"

#INTERNET_OPEN_TYPE_DIRECT   = 1
#HTTP_ADDREQ_FLAG_ADD        = $20000000
#HTTP_ADDREQ_FLAG_REPLACE    = $80000000
#INTERNET_FLAG_SECURE        = $800000
#INTERNET_SERVICE_HTTP       = 3
#INTERNET_DEFAULT_HTTPS_PORT = 443 

Procedure.s WindowsVersion()
  Version.OSVERSIONINFO
  Version\dwOSVersionInfoSize=SizeOf(OSVERSIONINFO)
  GetVersionEx_(Version)
  
  ProcedureReturn Str(Version\dwMajorVersion) + "."+ Str(Version\dwMinorVersion) + " (" + Str(Version\dwBuildNumber) +") " + Str(Version\dwPlatformId)
EndProcedure

Procedure.s do_post(url.s, post_data.s)
  post_data = URLEncoder(post_data)
  Debug "Posting: "+url
  Debug "Data: "+post_data
  host.s = GetURLPart(url, #PB_URL_Site)
  get_url.s = "/" + GetURLPart(url, #PB_URL_Path)
  result.s = ""
  port = 80
  ssl_option = 0
  
  If GetURLPart(url, #PB_URL_Protocol) = "https"
    ssl_option = #INTERNET_FLAG_SECURE
    port = #INTERNET_DEFAULT_HTTPS_PORT
  EndIf

  open_handle = InternetOpen_(productName$,#INTERNET_OPEN_TYPE_DIRECT,"","",0)
  connect_handle = InternetConnect_(open_handle,host,port,"","",#INTERNET_SERVICE_HTTP,0,0)
  request_handle = HttpOpenRequest_(connect_handle,"POST",get_url,"","",0,ssl_option,0)
  headers.s = "Content-Type: application/x-www-form-urlencoded" +Chr(13)+Chr(10) 
  HttpAddRequestHeaders_(request_handle,headers,Len(headers), #HTTP_ADDREQ_FLAG_REPLACE | #HTTP_ADDREQ_FLAG_ADD)
; post_data.s = "CMD=AUTH&USERNAME=test&PASSWORD=test"
  post_data_len = Len(post_data)
  send_handle = HttpSendRequest_(request_handle,"",0,post_data,post_data_len)
  buffer.s = Space(1024)
  bytes_read.l
  total_read.l
  total_read = 0
     
  ;
  ; Read until we can't read anymore..
  ; The string "result" will hold what ever the server pushed at us.
  ;
  Repeat
    InternetReadFile_(request_handle,@buffer,1024,@bytes_read)
    result + Left(buffer,bytes_read)
    buffer = Space(1024)
  Until bytes_read=0
  Debug result
  ProcedureReturn result
EndProcedure

Procedure ReportBooboo(msg.s)
  Debug "Posting: "+msg
  Debug "UUUUUURL: "+booboosUrl$
  os$ = WindowsVersion()
  browser$ = Reg_GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Version Vector", "IE")
  do_post(booboosUrl$, "auth_token="+key$+"&business_id="+bid$+"&osversion="+os$+"&browser="+browser$+"&message="+msg)
EndProcedure

Procedure WriteToLog(fd, line.s)
  FileSeek(fd, Lof(fd))
  WriteStringN(fd, FormatDate("%yyyy-%mm-%dd %hh:%ii:%ss", Date())+": "+line)
  PrintN(line)
EndProcedure

Procedure FatalError(err.l, msg$)
  WriteToLog(logDriver, msg$)
  ReportBooboo(msg$)
  End err
EndProcedure

Procedure.l OpenLog(logFile$)
  fd = OpenFile(#PB_Any, logFile$)
  If fd = 0
    ReportBooboo("Can't open log file: "+logFile$)
  EndIf
  ProcedureReturn fd
EndProcedure

Procedure.l ReadKeyfile(*key, keyFile$)
  keyFd = ReadFile(#PB_Any, keyFile$)
  If keyFd <> 0
    len = FileSize(keyFile$)
    If len >= #KEY_LENGTH
      len = #KEY_LENGTH
    EndIf
    If ReadData(keyFd, *key, len) = 0
      ProcedureReturn 2
    EndIf
    PokeS(*key, Trim(PeekS(*key)))
    ProcedureReturn 0
  Else
    ProcedureReturn 1
  EndIf
EndProcedure

If FileSize(logDir$) = -1
  If CreateDirectory(logDir$) = 0
    FatalError(1, "Error: Could not create log directory: "+logDir$)
  EndIf
EndIf

If FileSize(killFile$) >= 0
  WriteToLog(logDriver, "Dying from KillFile!")
  End 5
EndIf

WriteToLog(logDriver, "Starting up...")
program = RunProgram(programName$, key$ + " " + bid$, GetPathPart(ProgramFilename()), #PB_Program_Hide|#PB_Program_Open|#PB_Program_Read|#PB_Program_Error)
If program <> 0 And ProgramRunning(program)
  WriteToLog(logDriver, "Started...")
  While ProgramRunning(program) <> 0
    While AvailableProgramOutput(program) > 0
      line$ = ReadProgramString(Program)
      If line$ <> ""
        WriteToLog(logOut, line$)
      EndIf
    Wend
    Delay(500)
  Wend
EndIf

If program <> 0
  WriteToLog(logDriver, "Process exit: "+Str(ProgramExitCode(program)))
  CloseProgram(program)
Else
  FatalError(99, "Could not start process: "+programName$)
EndIf

CloseFile(logErr)
CloseFile(logOut)
CloseFile(logDriver)
; IDE Options = PureBasic 5.20 LTS (Windows - x86)
; CursorPosition = 137
; FirstLine = 127
; Folding = --
; EnableXP
; Executable = build\citation.exe
; CompileSourceDirectory
; IncludeVersionInfo
; VersionField0 = 0.1.0.1
; VersionField1 = 0.1.0.4
; VersionField2 = NetVersa, LLC.
; VersionField3 = Citation Server
; VersionField4 = 1.04
; VersionField5 = 1.0.1
; VersionField6 = Citation check runner.
; VersionField7 = Citation
; VersionField8 = citation.exe
; VersionField9 = Copyright (C) 2013 NetVersa, LLC.