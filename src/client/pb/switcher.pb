Enumeration
  #Window
EndEnumeration

;- Gadget Constants
;
Enumeration
  #Button
EndEnumeration

Global startupinfo.STARTUPINFO
startupinfo\cb=SizeOf(STARTUPINFO)
startupinfo\lpReserved=#NUL
startupinfo\lpDesktop=#NUL
startupinfo\lpTitle=#NUL
startupinfo\dwX=#NUL
startupinfo\dwY=#NUL
startupinfo\dwXSize=#NUL
startupinfo\dwYSize=#NUL
startupinfo\dwXCountChars=#NUL
startupinfo\dwYCountChars=#NUL
startupinfo\dwFillAttribute=#NUL
startupinfo\dwFlags=#STARTF_USESHOWWINDOW
startupinfo\wShowWindow=#SW_SHOW
startupinfo\cbReserved2=#NUL
startupinfo\lpReserved2=#NUL
startupinfo\hStdInput=#NUL
startupinfo\hStdOutput=#NUL
startupinfo\hStdError=#NUL

Global process_information.PROCESS_INFORMATION
process_information\hProcess=#NUL
process_information\hThread=#NUL
process_information\dwProcessId=#NUL
process_information\dwThreadId=#NUL


;- Fonts
Global FontID1
FontID1 = LoadFont(1, "Cambria", 18)

Procedure Open_Window()
  If OpenWindow(#Window, 376, 210, 283, 98, "Desktop Switcher",  #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered | #PB_Window_WindowCentered )
    ButtonGadget(#Button, 20, 20, 250, 60, "Return to Desktop")
    SetGadgetFont(#Button, FontID1)
  EndIf
EndProcedure

Procedure.l GetDesktop(name.s)
  desktop_hd.l = OpenDesktop_(name, 1, #True, #GENERIC_ALL)
  If desktop_hd = #Null
   Define.SECURITY_ATTRIBUTES lpsa
   lpsa\nLength = SizeOf(SECURITY_ATTRIBUTES)
   lpsa\lpSecurityDescriptor = 0
   lpsa\bInheritHandle = #True
   desktop_hd = CreateDesktop_(name, #NULL$, #Null, 1, #GENERIC_ALL, @lpsa)
  EndIf
   
  ProcedureReturn desktop_hd
EndProcedure

Global desktop_name.s = "citation"

desktop_hd = GetDesktop(desktop_name)
default_hd = GetDesktop("Default")

If ProgramParameter(0) = "--gui"
  Open_Window()
  Repeat
    Event = WaitWindowEvent() ; This line waits until an event is received from Windows
    WindowID = EventWindow() ; The Window where the event is generated, can be used in the gadget procedures
    GadgetID = EventGadget() ; Is it a gadget event?
    If Event = #PB_Event_Gadget
      If GadgetID = #Button
        SwitchDesktop_(default_hd)
        End
      EndIf
    EndIf
  Until Event = #PB_Event_CloseWindow ; End of the event loop
  SwitchDesktop_(default_hd)
  End;
EndIf

SwitchDesktop_(desktop_hd)
SetThreadDesktop_(desktop_hd)
  
tSi.STARTUPINFO
tSi\lpDesktop = @desktop_name
tPi.PROCESS_INFORMATION

CreateProcess_(0, ProgramFilename() + " --gui",#NUL,#NUL,#False,0,#NUL,#NUL,@tSi,@tPi)
; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 84
; FirstLine = 45
; Folding = -
; EnableXP
; Executable = switcher.exe