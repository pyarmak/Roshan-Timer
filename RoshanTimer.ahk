#Include %A_ScriptDir%/Timer.ahk

; Configurable Variables
Roshan_Up_Color = cLime
Pause_Color = cFuchsia
Agies_Not_Reclaimed_Color = cRed
Agies_Reclaimed_No_Roshan = cAqua
Roshan_Respawn_Window = cYellow

Time_Remaining = 0
Show_OSD = 2
CustomColor = EEAA99  ; Can be any RGB color (it will be made transparent below).
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, %CustomColor%
Gui, Font, s32  ; Set a large font size (32-point).
Gui, Add, Text, vMyText %Roshan_Up_Color%, XXXXX YYYYY  ; XX & YY serve to auto-size the window.
; Make all pixels of this color transparent and make the text itself translucent (150):
WinSet, TransColor, %CustomColor% 150
SetTimer, UpdateOSD, 200
Gosub, UpdateOSD  ; Make the first update immediate rather than waiting for the timer.
; Play with offsets for resolutions other than 1920x1080
Gui, Show, x1500 y-25 NoActivate  ; NoActivate avoids deactivating the currently active window.
return

MsToMinSec(i) {
	Return, i < 1 ? "0:0" : ((n := i // g := 60000) ? n : "0") . ":"
		. ((0 < i -= n * g) ? ((n := i // 1000) ) : "0")
}

UpdateOSD:
MS_Left := 660000-Timer("Roshan","L")
Time_Left := MsToMinSec(MS_Left)
if Time_Remaining > 0 
 {
  Gui, Font, %Pause_Color%
  GuiControl, Font, MyText
  GuiControl,, MyText, Paused
 }
else if (Timer("Roshan","S") and !Timer("Roshan")) {
 if MS_Left between 0 and 300000
 {
  Gui, Font, %Agies_Not_Reclaimed_Color%
  GuiControl, Font, MyText
 }
 else if MS_Left between 300001 and 480000 
 {
  Gui, Font, %Agies_Reclaimed_No_Roshan%
  GuiControl, Font, MyText
 }
 else if MS_Left between 480001 and 660000
 {
  Gui, Font, %Roshan_Respawn_Window%
  GuiControl, Font, MyText
 } 
 GuiControl,, MyText, %Time_Left%
}
else 
{
 Gui, Font, %Roshan_Up_Color%
 GuiControl, Font, MyText
 GuiControl,, MyText, Roshan is up!
}
return

; Keybinds
+^space:: ; Start/Pause timer
 if Time_Remaining > 0
 {
  Timer("Roshan",Time_Remaining)
  Time_Remaining = 0
 }
 else if (Timer("Roshan","S") and !Timer("Roshan"))
 {
  Time_Remaining := Timer("Roshan","L")
  Timer("Roshan","U")
 }
 else
  Timer("Roshan",660000)
return

pause:: ; Remove timer
 Time_Remaining = 0
 Timer("Roshan","U")
 
^Esc::
 display := mod(Show_OSD, 2)
 Show_OSD++
 GuiControl, Show%display%, MyText
return