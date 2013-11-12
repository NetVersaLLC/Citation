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
  #BIDFrame
  #BusinessID
  #OpenButton
  #AuthTokenFrame
  #AuthToken
  #Payloads
  #RunPayload
  #RunThrough
  #CompanyName
  #ClearQueue
  #AddMissed
  #SubFrame
  #Subscription
  #PausedFrame
  #Paused
  #SiteName
  #PayloadStatusFrame
  #PayloadStatus
  #ToggleActive
  #Notes
  #NotesFrame
  #CompanyNameFrame
  #Save
  #CitationHostFrame
  #CitationHost
  #Settings
EndEnumeration

;- Fonts
Global FontID1
FontID1 = LoadFont(1, "Calibri", 14)
Global FontID2
FontID2 = LoadFont(2, "Calibri", 12)
Global FontID3
FontID3 = LoadFont(3, "Calibri", 18)
;- Image Plugins



Procedure Open_Window()
  If OpenWindow(#Window, 270, 104, 683, 581, "Net Versa Payload Tester",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar )
    If CreateGadgetList(WindowID(#Window))

      
    EndIf
  EndIf
EndProcedure


; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 53
; FirstLine = 20
; Folding = -
; EnableXP