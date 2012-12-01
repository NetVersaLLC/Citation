; PureBasic Visual Designer v3.95 build 1485 (PB4Code)

; Global phoneNumber$ = ProgramParameter(0)
; Global verificationCode$ = ProgramParameter(0)
OpenConsole()

IncludeFile "Common.pb"

Open_Entry()

Repeat ; Start of the event loop

  Event = WaitWindowEvent() ; This line waits until an event is received from Windows
  WindowID = EventWindow() ; The Window where the event is generated, can be used in the gadget procedures
  GadgetID = EventGadget() ; Is it a gadget event?
  EventType = EventType() ; The event type

  ;You can place code here, and use the result as parameters for the procedures

  If Event = #PB_Event_Gadget

    If GadgetID = #Button
      CloseWindow(#Notice)
      Open_Entry()
    EndIf
    If GadgetID = #Button2
      str.s = GetGadgetText( #Code )
      WriteConsoleData( @str, Len(str) )
      End 100
    EndIf

  EndIf

Until Event = #PB_Event_CloseWindow ; End of the event loop

End
;

; IDE Options = PureBasic 4.61 (Windows - x86)
; ExecutableFormat = Console
; CursorPosition = 3
; EnableXP
; Executable = ..\..\test.exe