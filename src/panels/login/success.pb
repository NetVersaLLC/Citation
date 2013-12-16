; PureBasic Visual Designer v3.95 build 1485 (PB4Code)

IncludeFile "SuccessCommon.pb"

Open_SuccessWindow()

Repeat ; Start of the event loop
  
  Event = WaitWindowEvent() ; This line waits until an event is received from Windows
  
  WindowID = EventWindow() ; The Window where the event is generated, can be used in the gadget procedures
  
  GadgetID = EventGadget() ; Is it a gadget event?
  
  EventType = EventType() ; The event type
  
  ;You can place code here, and use the result as parameters for the procedures
  
  If Event = #PB_Event_Gadget
    
    If GadgetID = #Image
      
    ElseIf GadgetID = #OkButton
      
    Endif
    
  EndIf
  
Until Event = #PB_Event_CloseWindow ; End of the event loop

End
;
