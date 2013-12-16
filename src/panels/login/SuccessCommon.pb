;
; PureBasic Visual Designer v3.95 build 1485 (PB4Code)


;- Window Constants
;
Enumeration
  #SuccessWindow
EndEnumeration

;- Gadget Constants
;
Enumeration
  #Image
  #OkButton
EndEnumeration

;- Fonts
Global FontID1
FontID1 = LoadFont(1, "Calibri", 22)
;- Image Plugins
UsePNGImageDecoder()

;- Image Globals
Global Image0

;- Catch Images
Image0 = CatchImage(0, ?Image0)

;- Images
DataSection
Image0:
  IncludeBinary "C:\Users\jonathan\dev\Citation\src\files\login_success.png"
EndDataSection

Procedure Open_SuccessWindow()
  If OpenWindow(#SuccessWindow, 552, 170, 500, 250, "Success!",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar )
    If CreateGadgetList(WindowID(#SuccessWindow))
      ImageGadget(#Image, 0, 0, 500, 250, Image0)
      ButtonGadget(#OkButton, 250, 170, 130, 50, "Ok")
      SetGadgetFont(#OkButton, FontID1)
      
    EndIf
  EndIf
EndProcedure


; IDE Options = PureBasic 5.20 LTS (Windows - x86)
; CursorPosition = 18
; FirstLine = 7
; Folding = -
; EnableXP