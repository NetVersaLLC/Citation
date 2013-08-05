; PureBasic Visual Designer v3.95 build 1485 (PB4Code)


;- Window Constants
;
Enumeration
  #Window
  #WebWindow
EndEnumeration

;- Gadget Constants
;
Enumeration
  #AlreadyHave
  #NewAccount
  #SignInLabel
  #Email
  #PasswordLabel
  #Password
  #Web
  #Heading
  #Halp
  #SignIn
EndEnumeration

;- Misc Constants

Enumeration
  #EmailRegex
EndEnumeration

CreateRegularExpression(#EmailRegex, "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")

;- Fonts
Global FontID1
FontID1 = LoadFont(1, "Cambria", 14)
Global FontID2
FontID2 = LoadFont(2, "Cambria", 16)

OpenConsole()

Declare Open_Window()

Procedure NavigationCallback(Gadget, Url$) 
  Debug Url$
  If CountString(Url$, "SignUpDone") > 0
    CloseWindow(#WebWindow)
    Open_Window()
  EndIf
  ProcedureReturn #True
EndProcedure

Procedure Open_Window()
  If OpenWindow(#Window, 315, 156, 343, 371, "Google Account Sign In",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar )
      OptionGadget(#AlreadyHave, 20, 110, 230, 30, "I already have a Google account.")
      OptionGadget(#NewAccount, 20, 330, 230, 20, "I need to sign up to Google.")
      TextGadget(#SignInLabel, 40, 150, 190, 20, "Google Account Email:")
      StringGadget(#Email, 40, 170, 280, 30, "")
      SetGadgetFont(#Email, FontID1)
      TextGadget(#PasswordLabel, 40, 210, 70, 20, "Password:")
      StringGadget(#Password, 40, 230, 280, 30, "", #PB_String_Password)
      SetGadgetFont(#Password, FontID1)
      TextGadget(#Heading, 20, 10, 310, 30, "Google Account Sign In")
      SetGadgetFont(#Heading, FontID2)
      TextGadget(#Halp, 20, 50, 310, 50, "In order to sync your business listing on Google you need to provide the Google account credentials for the Google account you want associated with the business.")
      ButtonGadget(#SignIn, 190, 280, 130, 40, "Sign In")
      SetGadgetFont(#SignIn, FontID1)
  EndIf
EndProcedure

Procedure Open_WebWindow()
  If OpenWindow(#WebWindow, 740, 87, 800, 600, "Google Account Sign Up",  #PB_Window_SystemMenu | #PB_Window_TitleBar )
    WebGadget(#Web, 10, 10, 790, 590, "https://accounts.google.com/SignUp")
    SetGadgetAttribute(#Web, #PB_Web_NavigationCallback, @NavigationCallback())
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
    If GadgetID = #AlreadyHave
    ElseIf GadgetID = #NewAccount
      CloseWindow(#Window)
      Open_WebWindow()
    ElseIf GadgetID = #SignIn
      If GetGadgetText(#Email) = "" Or GetGadgetText(#Password) = ""
        MessageRequester("Error", "Please provide your Google login information.")
      ElseIf MatchRegularExpression(#EmailRegex, GetGadgetText(#Email)) = 0
        MessageRequester("Error", "Email does not appear to be valid.")
      Else
        PrintN(GetGadgetText(#Email) + Chr(9) + GetGadgetText(#Password))
        End
      EndIf
    EndIf
  EndIf
  If Event = #PB_Event_CloseWindow And WindowID = #WebWindow
    Open_Window()
    CloseWindow(#WebWindow)
  EndIf
Until Event = #PB_Event_CloseWindow And WindowID <> #WebWindow ; End of the event loop

End
; IDE Options = PureBasic 4.61 (Windows - x86)
; ExecutableFormat = Console
; CursorPosition = 98
; Folding = -
; EnableXP
; Executable = ..\..\build\glogin.exe