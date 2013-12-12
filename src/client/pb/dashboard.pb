;- Window Constants
;
Enumeration
  #Window
EndEnumeration

;- Gadget Constants
;
Enumeration
  #Web
EndEnumeration


Procedure Open_Window()
  If OpenWindow(#Window, 172, 94, 800, 600, "Fastrank Client",  #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered )
    WebGadget(#Web, 0, 0, 800, 600, "https://sync.fastrank.net/businesses/367?auth_token=EpS3yqezp1ts67fXEQLz")
  EndIf
EndProcedure

Open_Window()

Repeat ; Start of the event loop
  
  Event = WaitWindowEvent() ; This line waits until an event is received from Windows
  
  WindowID = EventWindow() ; The Window where the event is generated, can be used in the gadget procedures
  
  GadgetID = EventGadget() ; Is it a gadget event?
  
  EventType = EventType() ; The event type
  
  ;You can place code here, and use the result as parameters for the procedures
  
  If Event = #PB_Event_Gadget
    
    If GadgetID = #Web
      
    EndIf
    
  EndIf
  
Until Event = #PB_Event_CloseWindow ; End of the event loop

End
;

; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 15
; FirstLine = 1
; Folding = -
; EnableXP