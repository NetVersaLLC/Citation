RunProgram("Uninst0.exe", "", "", #PB_Program_Wait)

#PROCESS_ALL_ACCESS_VISTA_WIN7 = $1FFFFF

Prototype.i PFNCreateToolhelp32Snapshot(dwFlags.i, th32ProcessID.i) ;
Prototype.b PFNProcess32First(hSnapshot.i, *lppe.PROCESSENTRY32) ;
Prototype.b PFNProcess32Next(hSnapshot.i, *lppe.PROCESSENTRY32) ;

Procedure GetPidByName(p_name$) 
    Protected hDLL.i, process_name$ 
    Protected PEntry.PROCESSENTRY32, hTool32.i 
    Protected pCreateToolhelp32Snapshot.PFNCreateToolhelp32Snapshot 
    Protected pProcess32First.PFNProcess32First 
    Protected pProcess32Next.PFNProcess32Next 
    Protected pid.i 
    
    hDLL = OpenLibrary(#PB_Any,"kernel32.dll") 
    
    If hDLL 
        pCreateToolhelp32Snapshot = GetFunction(hDLL,"CreateToolhelp32Snapshot") 
        pProcess32First = GetFunction(hDLL,"Process32First") 
        pProcess32Next = GetFunction(hDLL,"Process32Next") 
    Else 
        ProcedureReturn 0 
    EndIf 
    
    PEntry\dwSize = SizeOf(PROCESSENTRY32) 
    hTool32 = pCreateToolhelp32Snapshot(#TH32CS_SNAPPROCESS, 0) 
    pProcess32First(hTool32, @PEntry) 
    process_name$ = Space(#MAX_PATH) 
    CopyMemory(@PEntry\szExeFile,@process_name$,#MAX_PATH) 
    
    If  UCase(process_name$) = UCase(p_name$) 
        ProcedureReturn PEntry\th32ProcessID 
    EndIf 
    
    While pProcess32Next(hTool32, @PEntry) > 0 
        process_name$ = Space(#MAX_PATH) 
        CopyMemory(@PEntry\szExeFile,@process_name$,#MAX_PATH) 
        
        If  UCase(process_name$) = UCase(p_name$) 
            ProcedureReturn PEntry\th32ProcessID 
        EndIf 
    
    Wend 
    
    CloseLibrary(hDLL) 
    
    ProcedureReturn 0 
EndProcedure

Procedure EnumWindowsProc(hWnd,lParam) 
   GetWindowThreadProcessId_(hWnd,@lpProc) 
   If lpProc=PeekL(lParam) ; process passed to EnumWindows is process found at this hwnd 
      PokeL(lParam,hWnd) ; set ptr to hwnd 
      ProcedureReturn 0 
   EndIf 
   ProcedureReturn 1 
EndProcedure

Procedure GetProcessId_(hProcess) ; for windows Vista, Windows XP SP1, Windows 7 
  Protected hThread 
  Protected Pid 
  Protected GCPI 
  
  GCPI    = GetProcAddress_(GetModuleHandle_("Kernel32"),"GetCurrentProcessId");    
  hThread = CreateRemoteThread_(hProcess,0,0,GCPI,0,0,0) 
  
  If Not hThread 
    ProcedureReturn 0 
  EndIf 
  
  WaitForSingleObject_(hThread,#INFINITE)  
  GetExitCodeThread_(hThread,@Pid) 
  CloseHandle_(hThread) 
  
  ProcedureReturn Pid  
EndProcedure

Procedure GetProcHwnd(lpProc) 
   Protected pid = GetProcessId_(lpProc) 
   ptr=pid 
   Repeat : Until EnumWindows_(@EnumWindowsProc(),@ptr) 
   If ptr=pid ; if no handle is returned no matching process was found 
      ProcedureReturn 0 
   EndIf 
   ; some form of GetWindow_() here for top-level window.. 
   ProcedureReturn ptr 
EndProcedure

Global YesButton = 0

Procedure ListWindows(Window, Parameter)
  WindowTitle.s = Space(255)
  GetWindowText_(Window, WindowTitle, 255)
  If WindowTitle = "&Yes"
    YesButton = Window
    ProcedureReturn #False
  Else
    ProcedureReturn #True
  EndIf
EndProcedure

OpenConsole()

Pid.i = GetPidByName("_Uninstall_0.exe")
hproc.i = OpenProcess_(#PROCESS_ALL_ACCESS,0,Pid)
hWnd  = GetProcHwnd(hproc)
EnumChildWindows_(hWnd,@ListWindows(), 0)
If YesButton
  SendMessage_(YesButton,#WM_LBUTTONDOWN ,#MK_LBUTTON, 0)
  Delay(300) 
  SendMessage_(YesButton,#WM_LBUTTONUP ,#MK_LBUTTON, 0)
Else
  MessageRequester("Error", "Uninstallation failed, could not find uninstaller.")
EndIf
; IDE Options = PureBasic 4.61 (Windows - x86)
; ExecutableFormat = Console
; CursorPosition = 114
; FirstLine = 69
; Folding = -
; EnableXP
; Executable = ..\..\..\Program Files (x86)\Fastrank Client\uninst.exe