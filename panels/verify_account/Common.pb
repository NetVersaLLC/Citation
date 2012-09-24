;
; PureBasic Visual Designer v3.95 build 1485 (PB4Code)


;- Window Constants
;
Enumeration
  #Window
EndEnumeration

;- Gadget Constants
;
Enumeration
  #Text
  #Frame3D
  #Phone
  #Button
EndEnumeration

;- Fonts
Global FontID1
FontID1 = LoadFont(1, "Calibri", 14)
Global FontID2
FontID2 = LoadFont(2, "Calibri", 20)

Procedure Open_Window()
  If OpenWindow(#Window, 527, 79, 327, 312, "Verify Account",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar )
      TextGadget(#Text, 30, 10, 290, 120, "In order to verify your business listing many sites require that you receive a call at your listed phone number. Press the button below to start the call.")
      SetGadgetFont(#Text, FontID1)
      Frame3DGadget(#Frame3D, 30, 150, 270, 70, "Calling")
      TextGadget(#Phone, 50, 170, 230, 40, phoneNumber$)
      SetGadgetFont(#Phone, FontID2)
      ButtonGadget(#Button, 30, 240, 270, 50, "I'm Ready, Call Me")
      SetGadgetFont(#Button, FontID1)
  EndIf
EndProcedure


; IDE Options = PureBasic 4.61 (MacOS X - x86)
; CursorPosition = 33
; FirstLine = 17
; Folding = -
; EnableXP