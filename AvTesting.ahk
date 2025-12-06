; Start
#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode "Pixel", "Screen"
MyGui := Gui()
MyGui.Show("w1550 h900")
MyGui.BackColor := "0B1329"
MyGui.Opt("+AlwaysOnTop  +ToolWindow -DPIScale -Caption ")


; Dont even understand ts part ngl
hwnd := MyGui.Hwnd
hRgnFull := DllCall("CreateRectRgn", "int", 0, "int", 0, "int", 1550, "int", 900, "ptr")
holeSizeY := 700
holeSizeX := 1170
x := (1550 - holeSizeX) // 2
y := (900 - holeSizeY) // 2
hRgnHole := DllCall("CreateRectRgn", "int", x, "int", y, "int", x + holeSizeX, "int", y + holeSizeY, "ptr")

; Subtract hole from full region
RGN_DIFF := 3
DllCall("CombineRgn", "ptr", hRgnFull, "ptr", hRgnFull, "ptr", hRgnHole, "int", RGN_DIFF)

; Apply region to the window
DllCall("SetWindowRgn", "ptr", hwnd, "ptr", hRgnFull, "int", true)

Taskgp := MyGui.Add("GroupBox", "w200 h400 cWhite", "Tasks")
Taskgp.move(1400, 92, 120, 320)


; Sidequests

ExitB := MyGui.Add("Picture", "w19 h-1", A_ScriptDir "\ExitButtonIcon.jpg")
ExitB.move(1525, 10, 20, 20)
ExitB.OnEvent("Click", ExitX)
MinimizeB := MyGui.Add("Picture", "w17.5 h-1", A_ScriptDir "\MinimizeButtonIcon.png")
MinimizeB.move(1400, 10, 20, 20)
MinimizeB.OnEvent("Click", MinimizeX)
ReloadB := MyGui.Add("Picture", "w17.5 h-1", A_ScriptDir "\ReloadButtonIcon.png")
ReloadB.move(1462, 10, 20, 20)
ReloadB.OnEvent("Click", ReloadX)

MainModes := MyGui.Add("Button", "w100 h40 cWhite", "Main Mode")
MainModes.move(1410, 122, 100, 30)
MainModes.OnEvent("Click", MainModesChoose)
MainModesChoose(*) {
    configFile := A_ScriptDir "\mode_selection.txt"

    NewGui := Gui()
    NewGui.Show("w300 h230")
    WinActivate "AvTesting.ahk"
    NewGui.Opt("+ToolWindow -DPIScale -Caption +WsPopup")
    NewGui.BackColor := "0B1329"

    ; Save button
    ExitButton := NewGui.Add("Button", "w100 h40 cWhite", "Save")
    ExitButton.Move(100, 180, 100, 40)
    ExitButton.OnEvent("Click", SaveChoice)

    ; === Radio Buttons ===
    ; only the first radio declares the variable name (Choice) and Group
    BossRushR := NewGui.Add("Radio", "vChoice Group cWhite", "Boss Rush")
    BossRushR.Move(20, 20, 100, 40)

    ; subsequent radios should NOT reuse vChoice — just create them and keep references
    InfinitieR := NewGui.Add("Radio", "cWhite", "Infinitie")
    InfinitieR.Move(130, 20, 100, 40)

    DungeonR := NewGui.Add("Radio", "cWhite", "Dungeon")
    DungeonR.Move(230, 20, 100, 40)

    LegendStageR := NewGui.Add("Radio", "cWhite", "Legend Stage")
    LegendStageR.Move(20, 70, 100, 40)

    OdyseeyR := NewGui.Add("Radio", "cWhite", "Odyseey")
    OdyseeyR.Move(130, 70, 100, 40)

    PortalR := NewGui.Add("Radio", "cWhite", "Portal")
    PortalR.Move(230, 70, 100, 40)

    RaidR := NewGui.Add("Radio", "cWhite", "Raid")
    RaidR.Move(20, 120, 100, 40)

    StoryR := NewGui.Add("Radio", "cWhite", "Story")
    StoryR.Move(130, 120, 100, 40)

    WorldlineR := NewGui.Add("Radio", "cWhite", "Worldline")
    WorldlineR.Move(230, 120, 100, 40)

    EventR := NewGui.Add("Radio", "cWhite", "Event")
    EventR.Move(20, 170, 100, 40)

    radios := [BossRushR, InfinitieR, DungeonR, LegendStageR, OdyseeyR, PortalR, RaidR, StoryR, WorldlineR, EventR]

    ; Load saved selection if file exists
    if FileExist(configFile) {
        saved := Trim(FileRead(configFile))
        for r in radios {
            if (r.Text = saved)
                r.Value := true
        }
    }

    ; Save function (nested so it can access NewGui, radios and configFile)
    SaveChoice(*) {
        ; Ensure GUI values are updated (only necessary if you used v-variables; we use radio objects so not strictly required,
        ; but keeping Submit is harmless)
        NewGui.Submit()
        selected := ""
        for r in radios {
            if r.Value
                selected := r.Text
        }

        if (selected != "") {
            if FileExist(configFile)
                FileDelete configFile
            FileAppend selected, configFile
            MsgBox "Saved: " selected
        } else {
            MsgBox "No option selected!"
        }

        NewGui.Destroy()
    }
}


TChallangeCB := MyGui.Add("Checkbox", "w150 h40 cWhite", "Trait Challange")
TChallangeCB.move(1410, 160, 90, 50)
TChallangeCB.SetFont("s10")

OChallangeCB := MyGui.Add("Checkbox", "w150 h40 cWhite", "Other Challange")
OChallangeCB.move(1410, 200, 90, 50)
OChallangeCB.SetFont("s10")

DailyChallangeCB := MyGui.Add("Checkbox", "w150 h40 cWhite", "Daily Challange")
DailyChallangeCB.move(1410, 240, 90, 50)
DailyChallangeCB.SetFont("s10")

WeeklyChallangeCB := MyGui.Add("Checkbox", "w150 h40 cffffff", "Weekly Challange")
WeeklyChallangeCB.move(1410, 280, 90, 50)
WeeklyChallangeCB.SetFont("s10")

BountyCB := MyGui.Add("Checkbox", "w150 h40 cWhite", "Bounty")
BountyCB.move(1410, 320, 90, 50)
BountyCB.SetFont("s10")

Rift := MyGui.Add("Checkbox", "w150 h40 cWhite", "Rift")
Rift.move(1410, 360, 90, 50)
Rift.SetFont("s10")

ReziseText := MyGui.Add("Text", "w150 h40 cWhite", "Press F1 to rezise Roblox")
ReziseText.Move(1410, 440, 110 , 60)
ReziseText.SetFont(, "Seoge UI")
ReziseText.SetFont("s12")

StartText := MyGui.Add("Text", "w150 h40 cWhite", "Press F2 to start the Macro")
StartText.Move(1410, 500, 110 , 60)
StartText.SetFont(, "Seoge UI")
StartText.SetFont("s12")

StopText := MyGui.Add("Text", "w150 h40 cWhite", "Press F3 to stop the Macro")
StopText.Move(1410, 560, 110 , 60)
StopText.SetFont(, "Seoge UI")
StopText.SetFont("s12")

RestartText := MyGui.Add("Text", "w150 h40 cWhite", "Press F4 to restart the Macro")
RestartText.Move(1410, 620, 110 , 60)
RestartText.SetFont(, "Seoge UI")
RestartText.SetFont("s12")

ShowText := MyGui.Add("Text", "w150 h40 cWhite", "Press F6 to Hide/Show the Macro")
ShowText.Move(1410, 700, 110 , 60)
ShowText.SetFont(, "Seoge UI")
ShowText.SetFont("s12")

MacroTXT := MyGui.Add("Text", "w300 h40 cWhite", "Macro")
MacroTXT.move(730, 22, 90, 30)
MacroTXT.SetFont("bold")
MacroTXT.SetFont("s10")


; Start / make roblox resize
F1:: {
    ; Run Notepad
    Run "notepad.exe"
    WinWait "ahk_exe notepad.exe"
    Sleep 500
    ; Get a window object
    win := WinExist("ahk_exe notepad.exe")
    ; Define coordinates2
    x1 := 750
    y1 := 300
    x2 := 1793
    y2 := 1043
    ; Move and resize
    WinMove(x1, y1, x2 - x1, y2 - y1, "ahk_exe notepad.exe")
}

F2:: {
    ; Start the Mango
}

F3:: {
    ExitApp
}

ExitX(*) {
    ExitApp
}

F4:: {
    Reload
    sleep 1000
}

F6:: {
    WinShow "AvTesting.ahk"
}

MinimizeX(*) {
    WinHide "AvTesting.ahk"
}

ReloadX(*) {
    try {
        Reload
    } catch {
        MsgBox "Failed to reload script."
    }
}


; Add pause https://www.autohotkey.com/docs/v2/lib/Pause.htm


; Ideas:
; Config (cords and all)
; Webhook
; Credits


;if MainModes.Value := 1 {
;    Something
;}
