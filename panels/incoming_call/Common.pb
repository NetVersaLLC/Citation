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
  #Code
  #Button
EndEnumeration

;- Fonts
Global FontID1
FontID1 = LoadFont(1, "Calibri", 14)
Global FontID2
FontID2 = LoadFont(2, "Calibri", 16)

Procedure Open_Window()
  If OpenWindow(#Window, 253, 8, 311, 265, "Incoming Call",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar )
      TextGadget(#Text, 20, 10, 290, 60, "Please enter the numbers provided on the call in the box below.")
      SetGadgetFont(#Text, FontID1)
      Frame3DGadget(#Frame3D, 20, 80, 270, 80, "Verification Code")
      StringGadget(#Code, 40, 100, 230, 40, "")
      SetGadgetFont(#Code, FontID2)
      ButtonGadget(#Button, 20, 180, 270, 60, "Done")
      SetGadgetFont(#Button, FontID2)
  EndIf
EndProcedure


; IDE Options = PureBasic 4.61 (MacOS X - x86)
; CursorPosition = 33
; FirstLine = 17
; Folding = -
; EnableXP