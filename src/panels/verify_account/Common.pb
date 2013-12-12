;
; PureBasic Visual Designer v3.95 build 1485 (PB4Code)


;- Window Constants
;
Enumeration
  #Notice
  #Entry
EndEnumeration

;- Gadget Constants
;
Enumeration
  #Text
  #Frame3D
  #Phone
  #Button
  #Text2
  #Frame3D2
  #Code
  #Button2
EndEnumeration

;- Fonts
Global FontID1
FontID1 = LoadFont(1, "Calibri", 14)
Global FontID2
FontID2 = LoadFont(2, "Calibri", 20)

Procedure Open_Entry()
  If OpenWindow(#Entry, 253, 8, 311, 265, "Incoming Call",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar )
      TextGadget(#Text2, 20, 10, 290, 60, "Please enter the numbers provided in the box below when prompted.")
      SetGadgetFont(#Text2, FontID1)
      Frame3DGadget(#Frame3D2, 20, 80, 270, 80, "Verification Code")
      TextGadget(#Code, 40, 100, 230, 40, verificationCode$)
      SetGadgetFont(#Code, FontID2)
      ButtonGadget(#Button2, 20, 180, 270, 60, "Done")
      SetGadgetFont(#Button2, FontID2)
  EndIf
EndProcedure


; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 38
; FirstLine = 14
; Folding = -
; EnableXP