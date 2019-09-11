@echo off
mode 20,5
color 0a
title Colorblind Helper - By Alex

cd "%USERPROFILE%\Documents"
if NOT EXIST %cd% (
    mode 110,20
    color 04
    echo ERROR!
    echo There is a space in the file path %cd%.
    echo This will not work with the colorblind helper.
    echo To fix this, you must change you username, 
    echo %USERNAME% to something without a space in it.
    pause >nul
    exit
)

if NOT EXIST colorblindtmp (mkdir colorblindtmp)
cd colorblindtmp

:reset
if EXIST rtempcolor.bat (del rtempcolor.bat)
if EXIST gtempcolor.bat (del gtempcolor.bat)
if EXIST btempcolor.bat (del btempcolor.bat)

if NOT EXIST tmp.ps1 (call :writetofile)

powershell %cd%\tmp.ps1
cls
call rtempcolor.bat
call gtempcolor.bat
call btempcolor.bat
call postempcolor.bat
cls

set /a randg=%r% - %g%
set /a randb=%r% - %b%
set /a gandb=%g% - %b%

echo Cursor: %pos%
echo RGB: (%r%,%g%,%b%)
echo.. . . . . . . . . .

set colorname=Unknown

if %gandb% LEQ 20 if %gandb% GEQ -20 if %g% GTR %r% if %b% GTR %r% (set colorname=Aqua)
if %randg% LEQ 5 if %randg% GEQ -5 if %r% GTR %b% if %g% GTR %b% (set colorname=Dark Yellow)
if %r% GTR %g% if %randg% LEQ 5 if %randg% GEQ -5 if %r% GTR %b% if %g% GTR %b% (set colorname=Brown)

if %r% GTR %b% if %r% GTR %g% (set colorname=Red)
if %randg% GEQ 50 if %randb% GEQ 50 if %r% GTR %b% if %r% GTR %g% if %g% GEQ 90 if %b% GEQ 90 (set colorname=Pink)
if %b% LEQ 20 if %r% GTR %g% if %randg% LEQ 5 if %randg% GEQ -5 if %r% GTR %b% if %g% GTR %b% (set colorname=Brown)
if %b% GTR %r% if %b% GTR %g% (set colorname=Blue)
if %randb% GEQ -10 if %r% GEQ 110 if %b% GEQ 230 if %g% GEQ 110 (set colorname=Light Purple)
if %r% GEQ 20 if %b% GTR %r% if %b% GTR %g% (set colorname=Blue-Purple)
if %r% GEQ 20 if %b% GTR %r% if %b% GTR %g% (set colorname=Purple)
if %randb% LEQ -20 if %b% GTR %g% if %b% GTR %r% if %gandb% LEQ -20 (set colorname=Blue)
if %gandb% GEQ -50 if %randb% GEQ -50 if %gandb% LEQ -10 if %randb% LEQ -10 if %b% GTR %r% if %b% GTR %g% (set colorname=Faint Blue)
if %randg% LEQ 10 if %randg% GEQ -10 if %randb% LEQ -60 if %r% GEQ 110 if %b% GEQ 230 if %g% GEQ 110 (set colorname=Light Blue)
if %randg% LEQ -10 if %gandb% GEQ -50 if %randb% GEQ -50 if %gandb% LEQ -10 if %randb% LEQ -10 if %b% GTR %r% if %b% GTR %g% (set colorname=Faint Aqua)

if %g% GTR %r% if %g% GTR %b% (set colorname=Green)
if %b% LEQ 70 if %r% LEQ 70 if %r% GEQ 30 if %b% GEQ 30 if %r% GTR %g% if %b% GTR %g% if %g% LEQ 27 (set colorname=Dark Purple)
if %r% GEQ 100 if %b% GEQ 100 if %r% GTR %g% if %b% GTR %g% if %g% LEQ 90 (set colorname=Purple)
if %b% GEQ %g% if %g% GTR %r% if %b% GTR %r% if %g% GEQ 128 if %r% LEQ 90 (set colorname=Aqua)
if NOT %gandb% LEQ 20 if NOT %gandb% GEQ -20 if %b% GTR %r% if %b% GTR %g% (set colorname=Blue)

if %r% GEQ %g% if %g% GTR %b% if %r% GTR %b% if %g% GEQ 128 if %b% LEQ 90 (set colorname=Yellow)
if %g% LSS 200 if %g% GEQ 60 if %r% GTR %g% if %g% GTR %b% if %r% GTR %b% if %g% LEQ 160 if %g% GEQ 83 if %b% LEQ 90 (set colorname=Orange)

if %randg% LEQ 10 if %randg% GEQ -10 if %randb% LEQ 10 if %randb% GEQ -10 if %gandb% LEQ 10 if %gandb% GEQ -10 (set colorname=Gray)
if %r% EQU %g% if %g% EQU %b% (set colorname=Gray)
if %r% GEQ 240 if %g% GEQ 240 if %b% GEQ 240 (set colorname=White)
if %r% LEQ 30 if %g% LEQ 30 if %b% LEQ 30 (set colorname=Black)

echo:Color: %colorname%
goto reset

:: ---------------------------------------
:writetofile
echo:Add^-Type ^-AssemblyName System.Windows.Forms>>tmp.ps1
echo:$X ^= ^[System.Windows.Forms.Cursor^]::Position.X>>tmp.ps1
echo:$Y ^= ^[System.Windows.Forms.Cursor^]::Position.Y>>tmp.ps1
echo:Write-Output "X:$X,Y:$Y" ^| Out-File -FilePath .\postempcolor.bat>>tmp.ps1
echo:(get-content %cd%\postempcolor.bat) ^| foreach ^{ ^'set pos=' + $_  ^} ^| set-content %cd%\postempcolor.bat>>tmp.ps1
echo:   ^ $map ^= ^[System.Drawing.Rectangle^]::FromLTRB^($X, $Y, $X + 1, $Y + 1^)>>tmp.ps1
echo:    ^$bmp ^= New-Object System.Drawing.Bitmap(1,1)>>tmp.ps1
echo:    ^$graphics ^= ^[System.Drawing.Graphics^]::FromImage($bmp)>>tmp.ps1
echo:    ^$graphics.CopyFromScreen^(^$map.Location, ^[System.Drawing.Point^]::Empty, $map.Size^)>>tmp.ps1
echo:    ^$pixel ^= ^$bmp.GetPixel(0,0)>>tmp.ps1
echo:    ^$red ^= $pixel.R>>tmp.ps1
echo:    ^$green ^= $pixel.G>>tmp.ps1
echo:    ^$blue ^= $pixel.B>>tmp.ps1
echo:    ^$result ^= New-Object psobject>>tmp.ps1
echo:    if ^(^$PSCmdlet.ParameterSetName -eq ^'None^'^) ^{>>tmp.ps1
echo:        $result ^| Add-Member -MemberType NoteProperty -Name "X" -Value $(^[System.Windows.Forms.Cursor^]::Position).X>>tmp.ps1
echo:        $result ^| Add-Member -MemberType NoteProperty -Name "Y" -Value $(^[System.Windows.Forms.Cursor^]::Position).Y>>tmp.ps1
echo:    ^}>>tmp.ps1
echo:    $result ^| Add-Member -MemberType NoteProperty -Name "Red" -Value $red>>tmp.ps1
echo:    $result ^| Add-Member -MemberType NoteProperty -Name "Green" -Value $green>>tmp.ps1
echo:    $result ^| Add-Member -MemberType NoteProperty -Name "Blue" -Value $blue>>tmp.ps1

echo:echo $pixel.R ^| Out-File -FilePath .\rtempcolor.bat>>tmp.ps1
echo:(get-content %cd%\rtempcolor.bat) ^| foreach ^{ ^'set /a r=' + $_  ^} ^| set-content %cd%\rtempcolor.bat>>tmp.ps1

echo:echo $pixel.G ^| Out-File -FilePath .\gtempcolor.bat>>tmp.ps1
echo:(get-content %cd%\gtempcolor.bat) ^| foreach ^{ ^'set ^/a g=^' + $_  ^} ^| set-content %cd%\gtempcolor.bat>>tmp.ps1

echo:echo $pixel.B ^| Out-File -FilePath .\btempcolor.bat>>tmp.ps1
echo:(get-content %cd%\btempcolor.bat) ^| foreach ^{ ^'set ^/a b=^' + $_  ^} ^| set-content %cd%\btempcolor.bat>>tmp.ps1

goto:eof