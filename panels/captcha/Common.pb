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
  #Image
  #Frame3D
  #Solution
  #Button
EndEnumeration

;- Fonts
Global FontID1
FontID1 = LoadFont(1, "Calibri", 20)
Global FontID2
FontID2 = LoadFont(2, "Calibri", 18)
;- Image Plugins

Procedure Open_Window()
  Debug "OpenWindow()"
  IW = ImageWidth(#Img)
  IH = ImageHeight(#Img)
  MinWin = 394
  If IW < MinWin
    WW = MinWin
  Else
    WW = IW + 20
  EndIf
  WH = IH + 232
  Debug "Width: "+Str(WW)
  Debug "Height: "+Str(WH)
  If OpenWindow(#Window, 282, 37, WW, WH, "CAPTCHA",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar )
      IX = 20
      IY = 10
      ImageGadget(#Image, IX, IY, IW, IH, ImageID(#Img))
      IY = IY + IH + 10
      Frame3DGadget(#Frame3D, IX, IY, 360, 90, "Solution Text")
      IY = IY + 30
      StringGadget(#Solution, IX+10, IY, 330, 50, "")
      SetGadgetFont(#Solution, FontID1)
      IY = IY + 80
      ButtonGadget(#Button, IX, IY, 360, 60, "Done")
      SetGadgetFont(#Button, FontID2)
  EndIf
EndProcedure

; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 27
; FirstLine = 24
; Folding = -
; EnableXP