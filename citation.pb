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

#INTERNET_OPEN_TYPE_DIRECT = 1
#HTTP_ADDREQ_FLAG_ADD = $20000000
#HTTP_ADDREQ_FLAG_REPLACE = $80000000
#INTERNET_FLAG_SECURE = $800000
#INTERNET_SERVICE_HTTP = 3
#INTERNET_DEFAULT_HTTP_PORT = 443 

Procedure do_post()
  host.s = "cite.netversa.com"
  get_url.s = "/results" 
  result.s = ""
  open_handle = InternetOpen_("NetVersa Citation 1.0",#INTERNET_OPEN_TYPE_DIRECT,"","",0)
  connect_handle = InternetConnect_(open_handle,host,#INTERNET_DEFAULT_HTTP_PORT,"","",#INTERNET_SERVICE_HTTP,0,0)
  request_handle = HttpOpenRequest_(connect_handle,"POST",get_url,"","",0,#INTERNET_FLAG_SECURE,0)
  headers.s = "Content-Type: application/x-www-form-urlencoded" +Chr(13)+Chr(10)
  HttpAddRequestHeaders_(request_handle,headers,Len(headers), #HTTP_ADDREQ_FLAG_REPLACE | #HTTP_ADDREQ_FLAG_ADD)
  post_data.s = "testval=dootdedootdoot"
  post_data_len = Len(post_data)
  send_handle = HttpSendRequest_(request_handle,"",0,post_data,post_data_len)
  buffer.s = Space(1024)
  bytes_read.l
  total_read.l
  total_read = 0
 
  Repeat
    InternetReadFile_(request_handle,@buffer,1024,@bytes_read)
    result + Left(buffer,bytes_read)
    buffer = Space(1024)   
  Until bytes_read=0
EndProcedure

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
; CursorPosition = 57
; FirstLine = 36
; Folding = -
; EnableXP
; Executable = build\citation.exe
; CompileSourceDirectory