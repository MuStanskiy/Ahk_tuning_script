#NoEnv
#Persistent
SetBatchLines -1

; --- Настройки ---
enabled := 1
currentHotkey := "Numpad5"
hue := 0
animationActive := true
isHovered := false
minimizeHover := false

; --- Версия программы ---
appVersion := "1.0.0"

; --- Анимация фона через PNG кадры ---
framePath := "C:\Users\MIXPC\Downloads\tuning_ahk_lovler\resources\"  ; папка с кадрами PNG
frames := []
frameIndex := 1
Loop, Files, %framePath%*.png
    frames.Push(A_LoopFileFullPath)

; --- Назначение хоткея ---
Hotkey, %currentHotkey%, Action, On

; --- GUI ---
Gui, -Caption +AlwaysOnTop +ToolWindow
Gui, Color, 1a1a1a
Gui, Font, s13 cWhite, Arial

; --- Picture control для фона ---
Gui, Add, Picture, x0 y0 w440 h400 vBGPic, % frames[1]

; --- Рамки ---
Gui, Add, Progress, x0 y0 w4 h400 BackgroundFF0000 Disabled vLeftBorder
Gui, Add, Progress, x436 y0 w4 h400 BackgroundFF0000 Disabled vRightBorder
Gui, Add, Progress, x0 y0 w440 h4 BackgroundFF0000 Disabled vTopBorder
Gui, Add, Progress, x0 y396 w440 h4 BackgroundFF0000 Disabled vBottomBorder

; --- Кнопки ---
Gui, Font, s13 Bold, Segoe UI
Gui, Add, Button, x30 y30 w380 h50 vToggleBtn gToggle, Включить/Выключить
Gui, Add, Button, x30 y100 w380 h50 vReassignBtn gReassign, Переназначить клавишу
GuiControl, +cWhite, ToggleBtn
GuiControl, +Background222222, ToggleBtn
GuiControl, +cWhite, ReassignBtn
GuiControl, +Background222222, ReassignBtn
WinSet, Region, 0-0 w380 h50 R15-15, ahk_id %ToggleBtn%
WinSet, Region, 0-0 w380 h50 R15-15, ahk_id %ReassignBtn%

; --- Индикаторы ---
Gui, Font, s13 cWhite, Arial
Gui, Add, Text, x30 y170 w380 h30 vStatusIndicator Center, ● AHK включен
GuiControl, +c00FF00, StatusIndicator
Gui, Add, Text, x30 y210 w380 h30 vCurrentKey Center, Текущая кнопка: Numpad5
GuiControl, +c00FFFF, CurrentKey

; --- Подпись ---
Gui, Font, s12 Italic, Arial
Gui, Add, Text, x30 y250 w380 h30 Center vSignature c8888FF, By Hasanov

; --- Версия программы (снизу слева) ---
Gui, Font, s11, Arial
Gui, Add, Text, x10 y370 w200 h20 vVersionLabel cWhite Left, Версия: %appVersion%

; --- Свернуть / Закрыть меню ---
Gui, Font, s12 Bold, Arial
Gui, Add, Progress, x30 y270 w380 h35 vMinimizeBg BackgroundFF0000 Disabled
Gui, Add, Text, x30 y270 w380 h35 vMinimizeBtn gMinimizeMenu Center +0x200 cFF0000 BackgroundTrans, Свернуть меню
GuiControl, Hide, MinimizeBg
Gui, Add, Progress, x30 y300 w380 h35 vExitBg BackgroundFF0000 Disabled
Gui, Add, Text, x30 y300 w380 h35 vExitBtn gExitAppFancy Center +0x200 cFF0000 BackgroundTrans, Закрыть меню
GuiControl, Hide, ExitBg

; --- Области для перемещения окна ---
Gui, Add, Text, x0 y0 w440 h270 BackgroundTrans gDragWindow
Gui, Add, Text, x0 y270 w30 h70 BackgroundTrans gDragWindow
Gui, Add, Text, x410 y270 w30 h70 BackgroundTrans gDragWindow

; --- Показать GUI ---
Gui, Show, w440 h400, AHK Меню
WinSet, Region, 0-0 w440 h400 R20-20, AHK Меню
WinSet, Transparent, 240, AHK Меню

; --- Кастомная иконка ---
WinGet, hWnd, ID, AHK Меню
exStyle := DllCall("GetWindowLong", "Ptr", hWnd, "Int", -20, "UInt")
exStyle |= 0x00040000
DllCall("SetWindowLong", "Ptr", hWnd, "Int", -20, "UInt", exStyle)
iconPath := "C:\Path\to\myicon.ico"  ; путь к иконке
hIcon := DllCall("LoadImage", "Ptr", 0, "Str", iconPath, "UInt", 1, "Int", 0, "Int", 0, "UInt", 0x10, "Ptr")
SendMessage := 0x80
SendMessage, SendMessage, hIcon, 0, , ahk_id %hWnd%
SendMessage, SendMessage, hIcon, 1, , ahk_id %hWnd%

; --- Двойной клик на панели задач для восстановления ---
OnMessage(0x0203, "WM_LBUTTONDBLCLK")
WM_LBUTTONDBLCLK(wParam, lParam, msg, hwnd) {
    WinGetTitle, winTitle, ahk_id %hwnd%
    if (winTitle = "AHK Меню") {
        WinRestore, ahk_id %hwnd%
        WinActivate, ahk_id %hwnd%
    }
}

; --- Таймеры ---
SetTimer, AnimateBorder, 50
SetTimer, CheckHover, 100
SetTimer, CheckButtonHover, 100
SetTimer, AnimateBG, 100  ; анимация фона
SetTimer, CheckForUpdates, -5000  ; проверка обновлений через 5 сек

; === Анимация фона через кадры PNG ===
AnimateBG:
    frameIndex := Mod(frameIndex, frames.MaxIndex()) + 1
    GuiControl,, BGPic, % frames[frameIndex]
Return

; === Проверка наведения на кнопки ===
CheckButtonHover:
    MouseGetPos, mouseX, mouseY, winID, ctrl
    WinGetPos, winX, winY, winW, winH, AHK Меню
    
    ; Проверяем наведение на кнопку "Включить/Выключить"
    toggleX := winX + 30, toggleY := winY + 30, toggleW := 380, toggleH := 50
    toggleHovered := (mouseX >= toggleX && mouseX <= toggleX + toggleW && mouseY >= toggleY && mouseY <= toggleY + toggleH)
    
    ; Проверяем наведение на кнопку "Переназначить клавишу"
    reassignX := winX + 30, reassignY := winY + 100, reassignW := 380, reassignH := 50
    reassignHovered := (mouseX >= reassignX && mouseX <= reassignX + reassignW && mouseY >= reassignY && mouseY <= reassignY + reassignH)
    
    ; Обработка кнопки "Включить/Выключить"
    if (toggleHovered) {
        GuiControl, +Background333333, ToggleBtn
        GuiControl, +c00FF00, ToggleBtn
    } else {
        GuiControl, +Background222222, ToggleBtn
        GuiControl, +cWhite, ToggleBtn
    }
    
    ; Обработка кнопки "Переназначить клавишу"
    if (reassignHovered) {
        GuiControl, +Background333333, ReassignBtn
        GuiControl, +c00FFFF, ReassignBtn
    } else {
        GuiControl, +Background222222, ReassignBtn
        GuiControl, +cWhite, ReassignBtn
    }
Return

; === Проверка наведения на кнопки "Закрыть" и "Свернуть" ===
CheckHover:
    MouseGetPos, mouseX, mouseY, winID, ctrl
    WinGetPos, winX, winY, winW, winH, AHK Меню
   
    ; "Закрыть меню"
    buttonX := winX + 30, buttonY := winY + 300, buttonW := 380, buttonH := 35
    newHovered := (mouseX >= buttonX && mouseX <= buttonX + buttonW && mouseY >= buttonY && mouseY <= buttonY + buttonH)
   
    if (newHovered != isHovered) {
        isHovered := newHovered
        if (isHovered) {
            GuiControl, +BackgroundFF0000, ExitBg
            GuiControl, Show, ExitBg
            GuiControl, +c87CEEB, ExitBtn
        } else {
            GuiControl, Hide, ExitBg
            GuiControl, +cFF0000, ExitBtn
        }
    }

    ; "Свернуть меню"
    minimizeX := winX + 30, minimizeY := winY + 270, minimizeW := 380, minimizeH := 35
    minimizeHovered := (mouseX >= minimizeX && mouseX <= minimizeX + minimizeW && mouseY >= minimizeY && mouseY <= minimizeY + minimizeH)
    
    if (minimizeHovered != minimizeHover) {
        minimizeHover := minimizeHovered
        if (minimizeHover) {
            GuiControl, +BackgroundFF0000, MinimizeBg
            GuiControl, Show, MinimizeBg
            GuiControl, +c87CEEB, MinimizeBtn
        } else {
            GuiControl, Hide, MinimizeBg
            GuiControl, +cFF0000, MinimizeBtn
        }
    }
Return

; === Перемещение окна ===
DragWindow:
    PostMessage, 0xA1, 2
Return

; === Анимация рамок и текста ===
AnimateBorder:
if (!animationActive)
    return
hue := Mod(hue + 5, 360)
HSVtoRGB(hue, 1, 1, r, g, b)
color := Format("0x{:02X}{:02X}{:02X}", r, g, b)
GuiControl, +Background%color%, LeftBorder
GuiControl, +Background%color%, RightBorder
GuiControl, +Background%color%, TopBorder
GuiControl, +Background%color%, BottomBorder

if (!isHovered) {
    pulseValue := 180 + Round(Sin(A_TickCount / 80) * 75)
    redColor := Format("0x{:02X}0000", pulseValue)
    GuiControl, +c%redColor%, ExitBtn
}

hue2 := Mod(hue + 180, 360)
HSVtoRGB(hue2, 0.8, 1, r2, g2, b2)
color2 := Format("0x{:02X}{:02X}{:02X}", r2, g2, b2)
GuiControl, +c%color2%, Signature
Return

Sin(x) {
    return DllCall("msvcrt\sin", "double", x, "double")
}

HSVtoRGB(H, S, V, ByRef R, ByRef G, ByRef B) {
    H := Mod(H, 360) / 60
    C := V * S
    X := C * (1 - Abs(Mod(H, 2) - 1))
    if (H >= 0 && H < 1)
        R := C, G := X, B := 0
    else if (H >= 1 && H < 2)
        R := X, G := C, B := 0
    else if (H >= 2 && H < 3)
        R := 0, G := C, B := X
    else if (H >= 3 && H < 4)
        R := 0, G := X, B := C
    else if (H >= 4 && H < 5)
        R := X, G := 0, B := C
    else
        R := C, G := 0, B := X
    M := V - C
    R := Round((R + M) * 255)
    G := Round((G + M) * 255)
    B := Round((B + M) * 255)
}

; === Вкл/Выкл ===
Toggle:
enabled := !enabled
Hotkey, %currentHotkey%, % (enabled ? "On" : "Off")
UpdateIndicator()
Return

; === Переназначение ===
Reassign:
animationActive := false
Gui, 2:Destroy
Gui, 2:-Caption +AlwaysOnTop +ToolWindow
Gui, 2:Color, 1a1a1a
Gui, 2:Font, s13 cWhite, Arial
Gui, 2:Add, Text, x25 y30 w470 h30 Center, Нажмите нужную клавишу...
Gui, 2:Show, w520 h90, Переназначение
WinSet, Region, 0-0 w520 h90 R15-15, Переназначение
ih := InputHook("L1")
ih.KeyOpt("{All}", "E")
ih.Start()
ih.Wait()
Gui, 2:Destroy
if (ih.EndKey = "")
{
    ShowNotification("Ошибка: клавиша не была нажата", "Red")
    animationActive := true
    Return
}
newKey := GetKeyName(ih.EndKey)
Hotkey, %currentHotkey%, Off
currentHotkey := newKey
Hotkey, %currentHotkey%, Action, On
if !enabled
    Hotkey, %currentHotkey%, Off
UpdateCurrentKey()
ShowNotification("Клавиша переназначена на: " . currentHotkey, "Green")
animationActive := true
Return

; === Action ===
Action:
SendInput,{Right}{Right}{Enter}
Sleep, 20
SendInput,{Up}{Right}{Enter}
Sleep, 20
SendInput,{Right}{Right}{Enter}
Sleep, 20
SendInput,{Up}{Right}{Enter}
Sleep, 20
SendInput,{Right}{Right}{Right}{Right}{Enter}{Right}{Enter}
Sleep, 20
SendInput,{Up}{Right}{Enter}
Sleep, 20
SendInput,{Right}{Right}{Enter} 
Sleep, 20
SendInput,{Up}{Up}{Right}{Enter}
Sleep, 20
SendInput,{Right}{Right}{Enter}
Sleep, 20
SendInput,{Up}{Right}{Enter}
Sleep, 20
SendInput,{Right}{Right}{Enter}
Sleep, 20
SendInput,{Up}{Right}{Enter}
Sleep, 20
SendInput,{Right}{Right}{Enter} 
Sleep, 20
SendInput,{Up}{Up}{Right}{Enter}
Sleep, 20
SendInput,{Right}{Right}{Enter}
Sleep, 20
SendInput,{Up}{Right}{Enter}
Sleep, 20
SendInput,{Right}{Right}{Enter}

Sleep, 300
mouseMove, 1834, 113
Sleep, 300
Click
Sleep, 300
mouseMove, 1771, 763
Sleep, 300
Click
Sleep, 300
mouseMove, 897, 565
Sleep, 300
Click
Return

; === Функции обновления ===
UpdateIndicator() {
    global enabled
    GuiControl,, StatusIndicator, % enabled ? "● AHK включен" : "● AHK выключен"
    color := enabled ? "00FF00" : "FF0000"
    GuiControl, +c%color%, StatusIndicator
}

UpdateCurrentKey() {
    global currentHotkey
    if (currentHotkey = "NumpadClear")
        displayKey := "Numpad5"
    else
        displayKey := currentHotkey
    text := "Текущая кнопка: " . displayKey
    GuiControl,, CurrentKey, %text%
}

ShowNotification(text, color:="White") {
    Gui, 3:Destroy
    Gui, 3:-Caption +AlwaysOnTop +ToolWindow
    Gui, 3:Color, 1a1a1a
    Gui, 3:Font, s13 Bold, Arial
    Gui, 3:Add, Progress, x0 y0 w500 h60 Background1a1a1a Disabled
    if (color="Red")
        Gui, 3:Add, Text, x25 y15 w450 h30 Center cRed, %text%
    else if (color="Green")
        Gui, 3:Add, Text, x25 y15 w450 h30 Center c00FF00, %text%
    else if (color="Yellow")
        Gui, 3:Add, Text, x25 y15 w450 h30 Center cFFFF00, %text%
    else
        Gui, 3:Add, Text, x25 y15 w450 h30 Center cWhite, %text%
    Gui, 3:Show, NoActivate xCenter y80 w500 h60
    WinSet, Region, 0-0 w500 h60 R15-15, ahk_class AutoHotkeyGUI
    SetTimer, CloseNotification, -2000
}
CloseNotification:
    Gui, 3:Destroy
Return

; === Красивое закрытие ===
ExitAppFancy:
animationActive := false
Loop, 3 {
    GuiControl, +BackgroundFF0000, ExitBg
    GuiControl, Show, ExitBg
    GuiControl, +c87CEEB, ExitBtn
    Sleep, 100
    GuiControl, Hide, ExitBg
    GuiControl, +cFF0000, ExitBtn
    Sleep, 100
}
ExitApp
Return

; === Свернуть меню ===
MinimizeMenu:
    WinMinimize, AHK Меню
Return

; === Проверка обновлений ===
CheckForUpdates:
    versionURL := "https://raw.githubusercontent.com/MuStanskiy/Ahk_tuning_script/refs/heads/main/version.txt"   ; <-- тут твой хостинг или GitHub raw
    scriptURL  := "https://raw.githubusercontent.com/MuStanskiy/Ahk_tuning_script/refs/heads/main/lovler_ahk_byhasanov.ahk"  ; <-- тут новый .ahk
    localFile  := A_ScriptFullPath

    ; Скачиваем файл с последней версией
    UrlDownloadToFile, %versionURL%, %A_Temp%\version.txt
    FileRead, latestVersion, %A_Temp%\version.txt
    latestVersion := Trim(latestVersion)

    ; Если версия новее
    if (latestVersion != "" && latestVersion != appVersion) {
        ShowNotification("Доступна новая версия: " . latestVersion, "Yellow")
        Sleep, 2000
        UrlDownloadToFile, %scriptURL%, %localFile%
        ShowNotification("Скрипт обновлён, перезапуск...", "Green")
        Sleep, 1500
        Run, %localFile%
        ExitApp
    }
Return

GuiClose:
ExitApp