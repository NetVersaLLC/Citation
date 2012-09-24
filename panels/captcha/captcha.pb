; PureBasic Visual Designer v3.95 build 1485 (PB4Code)

OpenConsole()
UseJPEG2000ImageDecoder()
UseJPEGImageDecoder()
UsePNGImageDecoder()

#Img = 0
fileName$ = ProgramParameter(1)
;fileName$ = "/Users/jjeffus/dev/Citation/panels/captcha/image.jpeg"
If LoadImage(#Img, fileName$)
Else
  End
EndIf

IncludeFile "Common.pb"

Open_Window()

Repeat ; Start of the event loop
  
  Event = WaitWindowEvent() ; This line waits until an event is received from Windows
  
  WindowID = EventWindow() ; The Window where the event is generated, can be used in the gadget procedures
  
  GadgetID = EventGadget() ; Is it a gadget event?
  
  EventType = EventType() ; The event type
  
  ;You can place code here, and use the result as parameters for the procedures
  
  If Event = #PB_Event_Gadget
    
    If GadgetID = #Button
      PrintN( GetGadgetText( #Solution ))
      End 100
    EndIf
    
  EndIf
  
Until Event = #PB_Event_CloseWindow ; End of the event loop

End
;
; IDE Options = PureBasic 4.61 (MacOS X - x86)
; CursorPosition = 9
; EnableXP