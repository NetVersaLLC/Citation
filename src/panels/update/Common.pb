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
  #Later
  #Install
EndEnumeration

;- Fonts
Global FontID1
FontID1 = LoadFont(1, "Calibri", 16)

Procedure Open_Window()
  If OpenWindow(#Window, 216, 0, 450, 184, "Sotware Update",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar )
      TextGadget(#Text, 20, 10, 400, 80, "A software update is available for Town Center, install now?")
      SetGadgetFont(#Text, FontID1)
      ButtonGadget(#Later, 20, 100, 190, 60, "Later")
      SetGadgetFont(#Later, FontID1)
      ButtonGadget(#Install, 230, 100, 190, 60, "Install")
      SetGadgetFont(#Install, FontID1)
  EndIf
EndProcedure


; IDE Options = PureBasic 4.61 (MacOS X - x86)
; CursorPosition = 30
; FirstLine = 12
; Folding = -
; EnableXP