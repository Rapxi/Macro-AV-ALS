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

; Groupbox

TaskGB := MyGui.Add("GroupBox", "w200 h400 cWhite", "Tasks")
TaskGB.move(1400, 92, 130, 320)


; Top Right Buttons

ExitB := MyGui.Add("Picture", "w19 h-1", A_ScriptDir "\Icons\ExitButtonIcon.jpg")
ExitB.move(1525, 10, 20, 20)
ExitB.OnEvent("Click", ExitX)
MinimizeB := MyGui.Add("Picture", "w17.5 h-1", A_ScriptDir "\Icons\MinimizeButtonIcon.png")
MinimizeB.move(1400, 10, 20, 20)
MinimizeB.OnEvent("Click", MinimizeX)
ReloadB := MyGui.Add("Picture", "w17.5 h-1", A_ScriptDir "\Icons\ReloadButtonIcon.png")
ReloadB.move(1462, 10, 20, 20)
ReloadB.OnEvent("Click", ReloadX)

; MainMode Radio in Button

MainModes := MyGui.Add("Button", "w100 h40 cWhite", "Main Mode")
MainModes.move(1415, 120, 100, 30)
MainModes.OnEvent("Click", MainModesChoose)
MainModesChoose(*) {
    configFile := A_ScriptDir "\ModeSettings\mode_selection.txt"

    NewGui := Gui()
    NewGui.Show("w300 h230")
    WinActivate "AvTesting.ahk"
    NewGui.Opt("+ToolWindow -DPIScale -Caption")
    NewGui.BackColor := "0B1329"

    ; Save button
    ExitButton := NewGui.Add("Button", "w100 h40 cWhite", "Save")
    ExitButton.Move(120, 215, 90, 35)
    ExitButton.OnEvent("Click", SaveChoice)

    ; === Radio Buttons ===
    ; only the first radio declares the variable name (Choice) and Group
    BossRushR := NewGui.Add("Radio", "vChoice Group cWhite", "Boss Rush")
    BossRushR.Move(20, 20, 100, 40)

    ; subsequent radios should NOT reuse vChoice, just create them and keep references
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

    Something1R := NewGui.Add("Radio", "cWhite", "something1")
    Something1R.Move(130, 170, 100, 40)

    Something2R := NewGui.Add("Radio", "cWhite", "something1")
    Something2R.Move(230, 170, 100, 40)

    radios := [BossRushR, InfinitieR, DungeonR, LegendStageR, OdyseeyR, PortalR, RaidR, StoryR, WorldlineR, EventR, Something1R, Something2R]

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
TChallangeCB.SetFont("s11")

OChallangeCB := MyGui.Add("Checkbox", "w150 h40 cWhite", "Other Challange")
OChallangeCB.move(1410, 200, 90, 50)
OChallangeCB.SetFont("s11")

DailyChallangeCB := MyGui.Add("Checkbox", "w150 h40 cWhite", "Daily Challange")
DailyChallangeCB.move(1410, 240, 90, 50)
DailyChallangeCB.SetFont("s11")

WeeklyChallangeCB := MyGui.Add("Checkbox", "w150 h40 cffffff", "Weekly Challange")
WeeklyChallangeCB.move(1410, 280, 90, 50)
WeeklyChallangeCB.SetFont("s11")

BountyCB := MyGui.Add("Checkbox", "w150 h40 cWhite", "Bounty")
BountyCB.move(1410, 320, 90, 50)
BountyCB.SetFont("s11")

Rift := MyGui.Add("Checkbox", "w150 h40 cWhite", "Rift")
Rift.move(1410, 360, 90, 50)
Rift.SetFont("s11")

InstructionsGB := MyGui.Add("GroupBox", "w200 h400 cWhite", "Instructions" )
InstructionsGB.move(1400, 450, 135, 345)
; Maybe add sometime, InstructionsGB.Opt("+Center")

ReziseText := MyGui.Add("Text", "w150 h40 cWhite", "Press F1 to rezise Roblox")
ReziseText.Move(1415, 470, 110 , 60)
ReziseText.SetFont("bold")
ReziseText.SetFont("s11")

StartText := MyGui.Add("Text", "w150 h40 cWhite", "Press F2 to start the Macro")
StartText.Move(1415, 530, 110 , 60)
StartText.SetFont("bold")
StartText.SetFont("s11")

StopText := MyGui.Add("Text", "w150 h40 cWhite", "Press F3 to stop the Macro")
StopText.Move(1415, 590, 110 , 60)
StopText.SetFont("bold")
StopText.SetFont("s11")

RestartText := MyGui.Add("Text", "w150 h40 cWhite", "Press F4 to restart the Macro")
RestartText.Move(1415, 650, 110 , 60)
RestartText.SetFont("bold")
RestartText.SetFont("s11")

ShowText := MyGui.Add("Text", "w150 h40 cWhite", "Press F6 to Hide/Show the Macro")
ShowText.Move(1415, 725, 110 , 60)
ShowText.SetFont("bold")
ShowText.SetFont("s11")

MacroTXT := MyGui.Add("Text", "w300 h40 cWhite", "Macro")
MacroTXT.move(730, 22, 90, 30)
MacroTXT.SetFont("bold")
MacroTXT.SetFont("s12")
; Github button

GithubLink(*) {
    Run "www.github.com/Rapxi"
}

GithubDirect := MyGui.Add("Button", "w300 h40 cWhite", "Github")
GithubDirect.Move(200, 830, 85, 40)
GithubDirect.OnEvent("Click", GithubLink)
GithubDirect.SetFont("s12")
GithubDirect.SetFont("bold")


TeamsButton := MyGui.Add("Button", "w300 h40 cWhite", "Teams" ) 
TeamsButton.Move(35, 90, 120, 40) 
Teamsbutton.OnEvent("Click", TeamsGui)

TeamsGui(*) { 
    TeamGui := Gui() 
    ExitButton1 := TeamGui.add("Button", "w100 h50", "Save")
    ExitButton1.OnEvent("Click",(*)=> TeamGui.destroy())
    TeamGui.Show("w1050 h575")
    ExitButton1.Move(475, 55  0)

    Unit1GB := TeamGui.add("GroupBox", "w150 h500 cWhite", "Unit 1")
    Unit1GB.Move(25, 25)
    Unit1GB.SetFont("s12")
    Unit1GB.SetFont("Bold") 
    Unit1nametext := TeamGui.add("Text", "cWhite", "Unit name")
    Unit1nameedit := TeamGui.add("Edit")
    Unit1nametext.SetFont("S12")
    Unit1nametext.SetFont("bold")
    Unit1nametext.Move(50, 50, 100, 25)
    Unit1nameedit.Move(50, 75, 100, 25)
    Unit1placementtext := TeamGui.Add("Text", "cWhite", "Placements")
    Unit1placementddl := TeamGui.Add("Dropdownlist",, ["1", "2", "3", "4"])
    Unit1placementtext.Move(50, 150, 100, 25)
    Unit1placementddl.Move(50, 175, 100, 25)
    Unit1placementtext.SetFont("S12")
    Unit1placementtext.SetFont("bold")
    Unit1upgradetext := TeamGui.Add("Text", "cWhite", "Upgrades")
    Unit1upgradeDDL := TeamGui.Add("DropDownList",, ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10" ,"11", "12", "13", "14", "max"])
    Unit1upgradetext.Move(50, 250, 100 ,25)
    Unit1upgradeDDL.move(50, 275, 100 ,25)
    Unit1upgradetext.SetFont("S12")
    Unit1upgradetext.SetFont("bold")
    Unit1abilitytext := TeamGui.Add("Text", "cWhite", "Ability")
    Unit1abilityDDL := TeamGui.Add("Dropdownlist",, ["Nuke"]) ;More to come
    Unit1abilitytext.Move(50, 350, 100, 25)
    Unit1abilityDDL.Move(50, 375, 100, 25)
    Unit1abilitytext.SetFont("S12")
    Unit1abilitytext.SetFont("bold")
    Unit1prioritytext := TeamGui.Add("Text", "cWhite", "Priority")
    Unit1priorityDDL := TeamGui.Add("DropDownList",, ["First", "Last", "Strongest", "Weakest", "Bosses", "Closest"])
    Unit1prioritytext.move(50, 450, 100, 25)
    Unit1priorityDDL.Move(50, 475, 100, 25)
    Unit1prioritytext.SetFont("s12")
    Unit1prioritytext.SetFont("Bold")

    Unit2GB := TeamGui.add("GroupBox", "w150 h500 cWhite", "Unit 2")
    Unit2GB.Move(200, 25)
    Unit2GB.SetFont("s12")
    Unit2GB.SetFont("Bold") 
    Unit2nametext := TeamGui.add("Text", "cWhite", "Unit name")
    Unit2nameedit := TeamGui.add("Edit")
    Unit2nametext.SetFont("S12")
    Unit2nametext.SetFont("bold")
    Unit2nametext.Move(225, 50, 100, 25)
    Unit2nameedit.Move(225, 75, 100, 25)
    Unit2placementtext := TeamGui.Add("Text", "cWhite", "Placements")
    Unit2placementddl := TeamGui.Add("Dropdownlist",, ["1", "2", "3", "4"])
    Unit2placementtext.Move(225, 150, 100, 25)
    Unit2placementddl.Move(225, 175, 100, 25)
    Unit2placementtext.SetFont("S12")
    Unit2placementtext.SetFont("bold")
    Unit2upgradetext := TeamGui.Add("Text", "cWhite", "Upgrades")
    Unit2upgradeDDL := TeamGui.Add("DropDownList",, ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10" ,"11", "12", "13", "14", "max"])
    Unit2upgradetext.Move(225, 250, 100 ,25)
    Unit2upgradeDDL.move(225, 275, 100 ,25)
    Unit2upgradetext.SetFont("S12")
    Unit2upgradetext.SetFont("bold")
    Unit2abilitytext := TeamGui.Add("Text", "cWhite", "Ability")
    Unit2abilityDDL := TeamGui.Add("Dropdownlist",, ["Nuke"]) ;More to come
    Unit2abilitytext.Move(225, 350, 100, 25)
    Unit2abilityDDL.Move(225, 375, 100, 25)
    Unit2abilitytext.SetFont("S12")
    Unit2abilitytext.SetFont("bold")
    Unit2prioritytext := TeamGui.Add("Text", "cWhite", "Priority")
    Unit2priorityDDL := TeamGui.Add("DropDownList",, ["First", "Last", "Strongest", "Weakest", "Bosses", "Closest"])
    Unit2prioritytext.move(225, 450, 100, 25)
    Unit2priorityDDL.Move(225, 475, 100, 25)
    Unit2prioritytext.SetFont("s12")
    Unit2prioritytext.SetFont("Bold")

    Unit3GB := TeamGui.add("GroupBox", "w150 h500 cWhite", "Unit 3")
    Unit3GB.Move(375, 25)
    Unit3GB.SetFont("s12")
    Unit3GB.SetFont("Bold") 
    Unit3nametext := TeamGui.add("Text", "cWhite", "Unit name")
    Unit3nameedit := TeamGui.add("Edit")
    Unit3nametext.SetFont("S12")
    Unit3nametext.SetFont("bold")
    Unit3nametext.Move(400, 50, 100, 25)
    Unit3nameedit.Move(400, 75, 100, 25)
    Unit3placementtext := TeamGui.Add("Text", "cWhite", "Placements")
    Unit3placementddl := TeamGui.Add("Dropdownlist",, ["1", "2", "3", "4"])
    Unit3placementtext.Move(400, 150, 100, 25)
    Unit3placementddl.Move(400, 175, 100, 25)
    Unit3placementtext.SetFont("S12")
    Unit3placementtext.SetFont("bold")
    Unit3upgradetext := TeamGui.Add("Text", "cWhite", "Upgrades")
    Unit3upgradeDDL := TeamGui.Add("DropDownList",, ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10" ,"11", "12", "13", "14", "max"])
    Unit3upgradetext.Move(400, 250, 100 ,25)
    Unit3upgradeDDL.move(400, 275, 100 ,25)
    Unit3upgradetext.SetFont("S12")
    Unit3upgradetext.SetFont("bold")
    Unit3abilitytext := TeamGui.Add("Text", "cWhite", "Ability")
    Unit3abilityDDL := TeamGui.Add("Dropdownlist",, ["Nuke"]) ;More to come
    Unit3abilitytext.Move(400, 350, 100, 25)
    Unit3abilityDDL.Move(400, 375, 100, 25)
    Unit3abilitytext.SetFont("S12")
    Unit3abilitytext.SetFont("bold")
    Unit3prioritytext := TeamGui.Add("Text", "cWhite", "Priority")
    Unit3priorityDDL := TeamGui.Add("DropDownList",, ["First", "Last", "Strongest", "Weakest", "Bosses", "Closest"])
    Unit3prioritytext.move(400, 450, 100, 25)
    Unit3priorityDDL.Move(400, 475, 100, 25)
    Unit3prioritytext.SetFont("s12")
    Unit3prioritytext.SetFont("Bold")

    Unit4GB := TeamGui.add("GroupBox", "w150 h500 cWhite", "Unit 4")
    Unit4GB.Move(550, 25)
    Unit4GB.SetFont("s12")
    Unit4GB.SetFont("Bold") 
    Unit4nametext := TeamGui.add("Text", "cWhite", "Unit name")
    Unit4nameedit := TeamGui.add("Edit")
    Unit4nametext.SetFont("S12")
    Unit4nametext.SetFont("bold")
    Unit4nametext.Move(575, 50, 100, 25)
    Unit4nameedit.Move(575, 75, 100, 25)
    Unit4placementtext := TeamGui.Add("Text", "cWhite", "Placements")
    Unit4placementddl := TeamGui.Add("Dropdownlist",, ["1", "2", "3", "4"])
    Unit4placementtext.Move(575, 150, 100, 25)
    Unit4placementddl.Move(575, 175, 100, 25)
    Unit4placementtext.SetFont("S12")
    Unit4placementtext.SetFont("bold")
    Unit4upgradetext := TeamGui.Add("Text", "cWhite", "Upgrades")
    Unit4upgradeDDL := TeamGui.Add("DropDownList",, ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10" ,"11", "12", "13", "14", "max"])
    Unit4upgradetext.Move(575, 250, 100 ,25)
    Unit4upgradeDDL.move(575, 275, 100 ,25)
    Unit4upgradetext.SetFont("S12")
    Unit4upgradetext.SetFont("bold")
    Unit4abilitytext := TeamGui.Add("Text", "cWhite", "Ability")
    Unit4abilityDDL := TeamGui.Add("Dropdownlist",, ["Nuke"]) ;More to come
    Unit4abilitytext.Move(575, 350, 100, 25)
    Unit4abilityDDL.Move(575, 375, 100, 25)
    Unit4abilitytext.SetFont("S12")
    Unit4abilitytext.SetFont("bold")
    Unit4prioritytext := TeamGui.Add("Text", "cWhite", "Priority")
    Unit4priorityDDL := TeamGui.Add("DropDownList",, ["First", "Last", "Strongest", "Weakest", "Bosses", "Closest"])
    Unit4prioritytext.move(575, 450, 100, 25)
    Unit4priorityDDL.Move(575, 475, 100, 25)
    Unit4prioritytext.SetFont("s12")
    Unit4prioritytext.SetFont("Bold")

    Unit5GB := TeamGui.add("GroupBox", "w150 h500 cWhite", "Unit 5")
    Unit5GB.Move(725, 25)
    Unit5GB.SetFont("s12")
    Unit5GB.SetFont("Bold")
    Unit5nametext := TeamGui.add("Text", "cWhite", "Unit name")
    Unit5nameedit := TeamGui.add("Edit")
    Unit5nametext.SetFont("S12")
    Unit5nametext.SetFont("bold")
    Unit5nametext.Move(750, 50, 100, 25)
    Unit5nameedit.Move(750, 75, 100, 25)
    Unit5placementtext := TeamGui.Add("Text", "cWhite", "Placements")
    Unit5placementddl := TeamGui.Add("Dropdownlist",, ["1", "2", "3", "4"])
    Unit5placementtext.Move(750, 150, 100, 25)
    Unit5placementddl.Move(750, 175, 100, 25)
    Unit5placementtext.SetFont("S12")
    Unit5placementtext.SetFont("bold")
    Unit5upgradetext := TeamGui.Add("Text", "cWhite", "Upgrades")
    Unit5upgradeDDL := TeamGui.Add("DropDownList",, ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10" ,"11", "12", "13", "14", "max"])
    Unit5upgradetext.Move(750, 250, 100 ,25)
    Unit5upgradeDDL.move(750, 275, 100 ,25)
    Unit5upgradetext.SetFont("S12")
    Unit5upgradetext.SetFont("bold")
    Unit5abilitytext := TeamGui.Add("Text", "cWhite", "Ability")
    Unit5abilityDDL := TeamGui.Add("Dropdownlist",, ["Nuke"]) ;More to come
    Unit5abilitytext.Move(750, 350, 100, 25)
    Unit5abilityDDL.Move(750, 375, 100, 25)
    Unit5abilitytext.SetFont("S12")
    Unit5abilitytext.SetFont("bold")
    Unit5prioritytext := TeamGui.Add("Text", "cWhite", "Priority")
    Unit5priorityDDL := TeamGui.Add("DropDownList",, ["First", "Last", "Strongest", "Weakest", "Bosses", "Closest"])
    Unit5prioritytext.move(750, 450, 100, 25)
    Unit5priorityDDL.Move(750, 475, 100, 25)
    Unit5prioritytext.SetFont("s12")
    Unit5prioritytext.SetFont("Bold")

    Unit6GB := TeamGui.add("GroupBox", "w150 h500 cWhite", "Unit 6")
    Unit6GB.Move(900, 25)
    Unit6GB.SetFont("s12")
    Unit6GB.SetFont("Bold") 
    Unit6nametext := TeamGui.add("Text", "cWhite", "Unit name")
    Unit6nameedit := TeamGui.add("Edit")
    Unit6nametext.SetFont("S12")
    Unit6nametext.SetFont("bold")
    Unit6nametext.Move(925, 50, 100, 25)
    Unit6nameedit.Move(925, 75, 100, 25)
    Unit6placementtext := TeamGui.Add("Text", "cWhite", "Placements")
    Unit6placementddl := TeamGui.Add("Dropdownlist",, ["1", "2", "3", "4"])
    Unit6placementtext.Move(925, 150, 100, 25)
    Unit6placementddl.Move(925, 175, 100, 25)
    Unit6placementtext.SetFont("S12")
    Unit6placementtext.SetFont("bold")
    Unit6upgradetext := TeamGui.Add("Text", "cWhite", "Upgrades")
    Unit6upgradeDDL := TeamGui.Add("DropDownList",, ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10" ,"11", "12", "13", "14", "max"])
    Unit6upgradetext.Move(925, 250, 100 ,25)
    Unit6upgradeDDL.move(925, 275, 100 ,25)
    Unit6upgradetext.SetFont("S12")
    Unit6upgradetext.SetFont("bold")
    Unit6abilitytext := TeamGui.Add("Text", "cWhite", "Ability")
    Unit6abilityDDL := TeamGui.Add("Dropdownlist",, ["Nuke"]) ;More to come
    Unit6abilitytext.Move(925, 350, 100, 25)
    Unit6abilityDDL.Move(925, 375, 100, 25)
    Unit6abilitytext.SetFont("S12")
    Unit6abilitytext.SetFont("bold")
    Unit6prioritytext := TeamGui.Add("Text", "cWhite", "Priority")
    Unit6priorityDDL := TeamGui.Add("DropDownList",, ["First", "Last", "Strongest", "Weakest", "Bosses", "Closest"])
    Unit6prioritytext.move(925, 450, 100, 25)
    Unit6priorityDDL.Move(925, 475, 100, 25)
    Unit6prioritytext.SetFont("s12")
    Unit6prioritytext.SetFont("Bold")
    ;Add Radio for spotfinder
    

    ; 5 name, placement, upgrade, ability, priority
    ; 25, 100, 25, 100, 25, 100, 25, 100, 25, 100, 25, 100 ; 25 space between each slot
    ; 25, 75, 25, 75, 25, 75, 25, 75, 25, 75
    TeamGui.Opt("+ToolWindow -DPIScale -Caption") 
    TeamGui.BackColor := "0B1329" 
} 





F1:: {

    If WinExist("ahk_exe notepad.exe") { 
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
    else {
        MsgBox("Please Open Notepad")
    }
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
    ReloadX
    sleep 1000
}

F6:: {
    if WinActive("AvTesting.ahk")  {
        WinHide("AvTesting.ahk")
    }
    else ;if WinMinimize("ahk_class AvTesting.ahk") {
        ReloadX
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
