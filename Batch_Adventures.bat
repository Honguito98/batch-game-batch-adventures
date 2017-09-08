@echo off       
	setlocal enableextensions enabledelayedexpansion
	taskkill /f /im wscript.exe >nul 2>&1
	taskkill /f /fi "windowtitle eq Audio" >nul 2>&1
:boot
taskkill /? >nul 2>&1
if !errorlevel!==9009 (
	echo.Un error a ocurrido:
	echo.Windows Xp Home version:
	echo.No se incluye este comando: 'Taskkill.exe'
	echo.----------------------
	echo.Error^^!: Cannot find 'Taskkill.exe'
	echo.Exiting....
	ping -n 3 localhost>nul&exit )

reg delete "HKLM\software\Microsoft\Windows Script Host\Settings" /v "Enabled" /f>nul
reg delete "HKCU\software\Microsoft\Windows Script Host\Settings" /v "Enabled" /f>nul
cls
if not exist "%userprofile%\config_BTA.dll" goto:scc

for /f "tokens=1,2" %%a in ('type "%userprofile%\config_BTA.dll"') do (
	set "scolor=%%b"
	for %%# in (low med hi) do (
	if "%%a"=="%%#" goto:%%#))

:low
if [%1]==[ok] (goto :init)
Reg export HKCU\Console Backup.reg>nul
Reg delete HKCU\Console\%%SystemRoot%%_system32_cmd.exe /f>nul
Reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FaceName /t REG_SZ /d "Terminal" /f>nul
Reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontFamily /t REG_DWORD /d 48 /f>nul
Reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontSize /t REG_DWORD /d 524294 /f>nul
Reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontWeight /t REG_DWORD /d 700 /f>nul
Reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v ScreenBufferSize /t REG_DWORD /d 13107280 /f>nul
Reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v CursorSize /t REG_DWORD /d 0 /f>nul 
start /high cmd /q /c "%~0" ok
Reg delete HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FaceName /f>nul
Reg delete HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontFamily /f>nul
Reg delete HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontSize /f>nul
Reg delete HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontWeight /f>nul
Reg delete HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v CursorSize /f>nul
Reg import Backup.reg>nul
Del /Q "screen.size">nul
Del /Q "Backup.reg">nul
exit

:med
goto:init

:hi
if [%1]==[ok] (goto :init)
Reg export HKCU\Console Backup.reg>nul
Reg delete HKCU\Console\%%SystemRoot%%_system32_cmd.exe /f>nul
Reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FaceName /t REG_SZ /d "Terminal" /f>nul
Reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontFamily /t REG_DWORD /d 48 /f>nul
Reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontSize /t REG_DWORD /d 1024294 /f>nul
Reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontWeight /t REG_DWORD /d 700 /f>nul
Reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v ScreenBufferSize /t REG_DWORD /d 13107280 /f>nul
Reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v CursorSize /t REG_DWORD /d 0 /f>nul 

start /high cmd /q /c "%~0" ok
Reg delete HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FaceName /f>nul
Reg delete HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontFamily /f>nul
Reg delete HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontSize /f>nul
Reg delete HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontWeight /f>nul
Reg delete HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v CursorSize /f>nul
Reg import Backup.reg>nul
Del /Q "screen.size">nul
Del /Q "Backup.reg">nul
exit

:init
title Batch Adventures
chcp 1252 >nul
mode con: cols=65 lines=20
echo.wscript.sleep 998>%tmp%\timer.vbs
(echo Set Wmp = CreateObject("WMPlayer.OCX"^)
echo archivo = wscript.Arguments.Item(0^) 
echo Wmp.URL = (archivo^)
echo Wmp.Controls.play 
echo do while Wmp.currentmedia.duration = 0
echo wscript.sleep 1 
echo loop 
echo wscript.sleep (int(Wmp.currentmedia.duration^)+1^)^*997
)>"%temp%\Dsp.vbs"
if not exist core\kbd.dll (echo.Falta Kbd.dll en \Core\&ping -n 3 localhost>nul&exit)
if not exist core\color.dll (echo.Falta color.dll en \Core\&ping -n 3 localhost>nul&exit)
if not exist core\Audio (echo.Falta la carpeta de Streams en \Core\&ping -n 3 localhost>nul&exit)
cls
echo. +Preparando APU
"%tmp%\dsp.vbs" core\audio\set.wav
echo. +Preparando PPU
start /min core\color.dll 0 0 2,2 >nul 2>&1
ping -n 2 localhost>nul
echo. +Cargando Niveles&call:load
cls
:reset
taskkill /f /im wscript.exe >nul 2>&1
taskkill /f /fi "windowtitle eq Audio" >nul 2>&1
cls
color 0e
set "kbd=core\kbd.dll"
set dsp="%tmp%\dsp.vbs"
set "errorlevel="
set "up="
set "down="
set "left="

if exist "%userprofile%\BA-Save.bsv" (
copy /y "%userprofile%\BA-Save.bsv" "%tmp%\$__save_temp$.bat">nul 2>&1
call "%tmp%\$__save_temp$.bat" &goto:no-point)

set "end=off"
set /a "clr.2=clr.3=lives=3,select=next=world=1,score=0,worlds=24"
:no-point
set "file=%tmp%\%random%.tmp"
copy nul + nul "%file%" >nul 2>nul
for /f %%i in (%file%) do set "right=%%i"
del "%file%" >nul 2>nul
set "key=^!errorlevel^!"
echo.	   .-----------------------------.
echo.	   Э       .::{Batch}::.         Э
ECHO.	(_)Э     .::{Adventures}::.      Э(__)
ECHO. 	  `-----------------------------'
echo. 	 __       2012-Honguito98
echo. 	(__)                           __
echo.	                              ("_)
echo.	._____________________________o()O______.
echo.	Э/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/Э
echo.	Э:::::::::::::::::::::::::::::::::::::::Э
				     core\color.dll 10 0 11,12 ".::{1.Nuevo juego}::."
if exist "%userprofile%\BA-Save.bsv" core\color.dll 10 0 11,12 ".::{1.Continuar}::.     "
if "%end%"=="on" (                   core\color.dll 11 0 11,12 ".::{1.Elegir Mundo}::.   ")
				     core\color.dll 09 0 11,13  .::{2.Ayuda}::.
				     core\color.dll 10 0 11,14  .::{3.salir}::.
if exist "%userprofile%\BA-Save.bsv" core\color.dll 12 0 11,15 ".::{4.Borrar datos}:::."
				     core\color.dll 15 0 11,16 ".::{5.Modo de Pantalla}:::."
:read
core\kbd.dll
if "%end%"=="on" (if %key%==49 goto:select)
if %key%==49 set "nosave=off"&goto:start
if %key%==50 call:info
if %key%==51 exit
if %key%==53 goto:scc
if exist "%userprofile%\BA-Save.bsv" (if %key%==52 goto:del)
goto:read

:select
cls
echo Selecciona un mundo, se desactivara el autoguardado
echo 1-!worlds!
set/p wd=^>
if not defined wd goto:select
::if [%wd%] GTR [!worlds!] goto:select
if "%wd%" EQU "0" goto:select
set "nosave=on" & set world=%wd%
goto:start

:scc
set scr=
cls
echo.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.Seleccione un tama¤o de pantalla
echo.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.low = chico  med = normal  hi = grande
set/p scr=^>
if not defined scr goto:scc
if %scr% neq low if %scr% neq med if %scr% neq hi goto:scc
cls
echo.Selecciona un color que se mostrara en el juego
echo.&color/? |find "="
set/p cl=^>
echo.%scr% %cl%>"%userprofile%\config_BTA.dll"
echo.Reiniciando...&ping -n 2 localhost>nul
start /high cmd /q /c "%~0"
exit


:del
cls
color 0c
echo Estas seguro de borrar los datos guardados?
set/p "dc=(S/n)>"
if /i %dc%==s (del "%userprofile%\BA-Save.bsv">nul&goto:reset)
if /i %dc%==n (goto:reset)
goto:del

:info
cls
color 07
echo. Accion:                   Teclas:
echo.
echo. Mover jugador a la izq.   %left%
echo. Mover jugador a la der.   %right%
echo. Saltar a la izq.          %up% %left%
echo. Saltar a la der.          %up% %right%
echo. Salto largo a la izq.     %up% %up% %left%
echo. Salto largo a la der.     %up% %up% %right%
echo. Bajar la altura de brinco %down%
echo. Pausar juego              Enter/Esc
echo. Romper bloques ±          ^<Espacio^>
echo.
echo.  Presione una tecla para regresar . . .
pause >nul
goto :reset


:load
set "bar="
set "percent=0"
set "count=0"
for /l %%i in (1,1,20) do set "bar=!bar!±"
:loop
set /p "= %bar:~0,20% %percent%%%"<nul
::set ran=%random:~0,1%
ping -n 1 -w 1 localhost>nul
for /l %%i in (1,1,26) do set /p "="<nul
set "bar=Ы%bar%"
set /a "count+=1"
set /a "percent+=5"
if %count% leq 20 goto:loop
goto:eof

:start
color %scolor%
call :load || goto :reset
call :graphic

:play
if "!rep!" NEQ "no" if "!chk!"=="!lch!" start /b /high wscript %tmp%\dsp.vbs core\audio\Key.wav&set rep=no
call:gravity player
call :enemies
if !finish! gtr 0 goto :finish
%kbd% 1
if %key% equ 32 call :kblo
if %key% equ 72 call :jump
if %key% equ 75 call :move -
if %key% equ 77 call :move +
if %key% equ 13 goto :pause
if %key% equ 27 goto :pause
goto :play

:kblo
set kb=yes
goto:eof

:gravity
if !finish! gtr 0 goto :eof
call :getXY %1.pos
set /a "n=l+1"
if !n! gtr !map.row! goto :eof
call :moveChk %n% %c% %1 gravity || goto :eof
call :graphic
call :gravity %1
goto :eof

:move
if !finish! gtr 0 goto :eof
call :getXY player.pos
set /a "n=c%11,i=map.col-view.max-view.min,j=view.max/2,k=n-(map.col-(view.max-j))"
if !n! gtr !map.col! goto :eof
if !n! lss 1 goto :eof
call :moveChk %l% %n% player || goto :eof
if !n! gtr !j! (
if !i! gtr 0 (
set /a "view.min%1=1"
) else if !k! lss 1 if !view.min! gtr 0 set /a "view.min-=1"
) else if !view.min! gtr 0 set /a "view.min-=1"
call :graphic
goto :eof

:jump
set "course="
set /a "jump=1,count=0,height=3"
set /p "=яSalto : %up%"<nul

:jumpCnt
%kbd% 1
if %key% equ 72 set /a "jump+=1" & set /p "=%up%" <nul
if %key% equ 75 set "course=-" & set /p "=%left%" <nul
if %key% equ 77 set "course=+" & set /p "=%right%" <nul
if %key% equ 80 set /a "height-=1" & set /p "=%down%" <nul
if %key% equ 0 set /a "count+=1"
if %count% equ 35 cd.|more & exit /b 0
if !jump! leq 2 if not defined course goto :jumpCnt
cd.|more
for /l %%i in (1,1,!height!) do (
if !finish! gtr 0 goto :eof
call :getXY player.pos
set /a "n=l-1"
if !n! geq 1 call :moveChk !n! !c! player && call :graphic
)
if defined course for /l %%i in (1,1,%jump%) do call :move !course!
goto :eof

:enemies
if not defined enemies.pos goto :eof
set "enemies="
set /a "view.pos=50+1+1"
for %%i in (%enemies.pos%) do (
if !finish! gtr 0 goto :eof
set "enemy.pos=%%i"
call :getXY enemy.pos
call :gravity enemy
if !c! geq !view.min! if !c! leq !view.pos! (
set /a "rnd=!random!%%3"
if !rnd! equ 0 set /a "n=c-1"
if !rnd! equ 1  set /a "n=c+1"
if !rnd! equ 2 (
set /a "rnd=!random!%%2"
for /l %%i in (0,1,!rnd!) do (
call :getXY enemy.pos
set /a "n=l-1"
if !n! geq 1 call :moveChk !n! !c! enemy && call :graphic
)
set /a "rnd=!random!%%3"
call :getXY enemy.pos
if !rnd! equ 0 set /a "n=c-1"
if !rnd! equ 1 set /a "n=c+1"
)
if !n! leq !map.col! if !n! geq 1 if !rnd! lss 2 call :moveChk !l! !n! enemy && call :graphic
call :gravity enemy
)
set "enemies=!enemies!,!enemy.pos!"
)
set "enemies.pos=%enemies%,"
goto :eof

:moveChk
set /a "col=%2-1"
set "chr=!m[%1]:~%col%,1!"
if "!chr!"=="!border!" exit /b 1
if "%3"=="player" (

if "!chr!"=="!block!" (
if "!kb!"=="yes" (
set "chr=!ground!"
start /b /high wscript %tmp%\dsp.vbs core\audio\break.wav
set /a "score+=5"
set "kb=no") else if "!kb!" NEQ "yes" exit /b 1
)

if "!chr!"=="”" if "%4"=="gravity" set chr=_
if "!chr!"=="!exit2!" (if "!chk!"=="!lch!" set finish=1 else if "!chk!" NEQ "!lch!" exit/b 1)
if "!chr!"=="!keyps!" (set "chr=!ground!"&set/a chk+=1)
if "!chr!"=="!coin!" (set /a "score+=5" & set "chr=!ground!")
if "!chr!"=="!live!" (start /high wscript %tmp%\dsp.vbs core\audio\live.wav &  set /a "lives+=1" & set "chr=!ground!")
if "!chr!"=="!exit!" set "finish=1"
if "!chr!"=="!pick!" if !lives! gtr 0 (set /a "lives-=1,finish=3") else set "finish=2"
if "!chr!"=="!enemy!" if "%4"=="gravity" (
set /a "score+=10"
set "enemies.pos=!enemies.pos:,%1.%2,=,!"
set "chr=!ground!" 
) else if !lives! gtr 0 (set /a "lives-=1,finish=3") else set "finish=2"
)
if "%3"=="enemy" (
if "!chr!"=="!player!" if !lives! gtr 0 (set /a "lives-=1,finish=3") else set "finish=2"
if "!chr!"=="!enemy!" exit /b 1
if "!chr!"=="!pick!" exit /b 1
if "!chr!"=="!exit!" exit /b 1
if "!chr!"=="!exit2!" exit /b 1
if "!chr!"=="!keyps!" exit /b 1
)
call :chrRplc %l% %c% last[!%3.pos!]
set "last[%1.%2]=!chr!"
call :chrRplc %1 %2 %3
set "%3.pos=%1.%2"
exit /b 0

:finish
%kbd% 1
if %key% neq 0 goto :finish
set "return=start"

if !finish! equ 2 (core\color.dll 12 0 1,16 " Fin Del Juego^!"
taskkill /f /fi "windowtitle eq audio" >nul 2>&1
taskkill /f /im wscript.exe >nul 2>&1
%tmp%\dsp.vbs core\audio\over.wav
goto:reset)

if !finish! equ 3 (
core\color.dll 11 0 1,16 " Has Perdido^!"
taskkill /f /fi "windowtitle eq audio" >nul 2>&1
taskkill /f /im wscript.exe >nul 2>&1
%tmp%\dsp.vbs core\audio\dead.wav
goto:ll)

if "%nosave%"=="on" (
core\color.dll 14 0 1,16 "Mundo Completado^!"&call:complete
set /a "world+=1"&set return=reset&goto:start)

if !finish! EQU 1 (
if !world! geq !worlds! (
core\color.dll 13 0 1,16 " Has terminado el juego^!"
call:complete
echo.Guardando los datos...&echo.No salirse del juego^!
ping -n 2 localhost>nul
echo.set /a "clr.2=clr.3=lives=!lives!,select=next=world=!world!,score=!score!,worlds=!worlds!">"%userprofile%\BA-Save.bsv"
echo.set "end=on">>"%userprofile%\BA-Save.bsv"
goto:reset))

if !finish! equ 1 (
core\color.dll 14 0 1,16 "Mundo Completado^!" &call:complete
set /a "world+=1
cls&echo.Guardando los datos...&echo.No salirse del juego^!&ping -n 3 localhost>nul
echo.set /a "clr.2=clr.3=lives=!lives!,select=next=world=!world!,score=!score!,worlds=!worlds!">"%userprofile%\BA-Save.bsv"
goto:%return%)

if !finish! equ 4 (core\color.dll 09 0 1,16 " Tiempo Fuera^!")

:ll
echo.&set /p "=яPresione Enter para continuar . . . " <nul
:enter
%kbd%
if %key% neq 13 goto :enter
goto :%return%

:complete
taskkill /f /fi "windowtitle eq audio" >nul 2>&1
taskkill /f /im wscript.exe >nul 2>&1
%tmp%\dsp.vbs core\audio\comp.wav
goto:eof



:graphic
core\color.dll 07 0 1,1 " .::{Mundo:%world%  Vidas:%lives%  Puntos:%score%}::."
for /l %%i in (0,1,%map.row%) do <nul set/p =.!m[%%i]!!lf!
goto :eof
::enable scrolling: echo. !m[%%i]:~%view.min%,%view.max%!

:pause
taskkill /fi "WINDOWTITLE eq Audio">nul
taskkill /f /im wscript.exe >nul 2>&1
color 08
core\color.dll 11 0 1,3 "     Pausa^!       "
core\color.dll 14 0 1,4  ._________________.
core\color.dll 10 0 1,5 "|1).Continuar     |"
core\color.dll 12 0 1,6 "|0).Menu principal|"
core\color.dll 14 0 1,7 "|_________________|"
:nokey
%kbd%
if %key%==49 (goto:game)
if %key%==48 (goto:reset)
goto:nokey

:game
cls
color %scolor%
call:music!pc!
call :graphic
goto :play

:load
set rep=yes
cls
echo.                Cargando&echo.&echo.
set /p "=.             ЫЫЫЫ" <nul
set "border=Ы"
set "ground= "
set "block=±"
set "player="
set "keyps="
set "enemy="
set "coin=›"
set chk=0
set lch=00
ping -n 1 localhost>nul
set "exit=°"
set "exit2=@"
set /p "=ЫЫ" <nul
set "live="
set "pick="
set "pc=1"
set "kb=no"
taskkill /fi "WINDOWTITLE eq Audio">nul
set /a "map.col=map.row=view.max=view.min=finish=0,secons=100"
set "view.max=30"
for /f "delims==" %%i in ('"set m[ 2>nul|findstr /r "m\[[0-9]*\]=""') do set "%%i="
set /p "=ЫЫЫ" <nul
if %world% lss 1 set /a "world=1"
call :world_%world% 2>nul || exit /b 1
call :music!pc!
set /p "=ЫЫ" <nul
for /f %%i in ('"set m[ 2>nul|findstr /r "m\[[0-9]*\]=""') do set /a "map.row+=1"
set /p "=ЫЫ" <nul
if %map.row% equ 0 exit /b 1
call :strLen m[1] map.col
if !view.max! lss 1 set /a "view.max=map.col"
if !view.max! gtr %map.col% set /a "view.max=map.col"
set /p "=ЫЫ" <nul
call :getPstn player player.pos
set /p "=ЫЫ" <nul
call :getPstn enemy enemies.pos
set /p "=ЫЫ" <nul
set /p "=ЫЫ" <nul
set lf=^


cls
exit /b 0

:strLen
set "str=!%~1!"
set "%~2=0"
:strLen.loop
if not defined str goto :eof
set /a "%~2+=1"
set "str=!str:~1!"
goto :strLen.loop

:getPstn
set "%2="
for /f "tokens=2 delims=[]" %%i in ('"set m[ 2>nul|findstr /r "m\[[0-9]*\]="|find "!%1!""') do (
for %%j in (%%i) do for /l %%k in (0,1,%map.col%) do if "!m[%%j]:~%%k,1!"=="!%1!" (
set /a "col=%%k+1"
set "%2=!%2!,%%j.!col!"
set "last[%%j.!col!]=!ground!"
)
)
if defined %2 set "%2=!%2:~1!"
goto :eof

:getXY
for /f "tokens=1,2 delims=." %%x in ("!%1!") do set /a "l=%%x,c=%%y"
goto :eof

:chrRplc
set /a "col=%2-1"
set "m[%1]=!m[%1]:~0,%col%!!%3!!m[%1]:~%2!"
goto :eof


:music1
(
echo.@echo off
echo.title audio
echo.mode con: cols=15 lines=7
echo.echo.Audio Render
echo.echo.Don't close
echo.set "s=0" ^& set "ln=y"
echo.:m
echo.if %%ln%%==y (start wscript %%tmp%%\dsp.vbs core\audio\sq1.wav^& set "ln=n" ^&set s=0^)
echo.if %%s%%==30 set "ln=y" ^&goto:m
echo.set/a s+=1
echo.cscript /nologo %%tmp%%\timer.vbs
echo.goto:m)>"%tmp%\audio_.bat"
start /min /high %tmp%\audio_.bat
goto:eof

:music2
(
echo.@echo off
echo.title audio
echo.mode con: cols=15 lines=7
echo.echo.Audio Render
echo.echo.Don't close
echo.set ln=y
echo.set s=0
echo.:m
echo.if %%s%%==5 (set "ln=y" ^& set "s=0" ^&goto:mm^)
echo.if %%ln%%==y (start wscript %%tmp%%\dsp.vbs core\audio\sq2-1.wav ^& set "ln=n" ^&set "s=0"^)
echo.cscript /nologo %%tmp%%\timer.vbs
echo.set/a s+=1
echo.goto:m
echo.:mm
echo.if %%ln%%==y (start wscript %%tmp%%\dsp.vbs core\audio\sq2-2.wav ^& set "ln=n" ^& set "s=0"^)
echo.if %%s%%==37 (set "ln=y" ^&goto:mm^)
echo.set/a s+=1
echo.cscript /nologo %%tmp%%\timer.vbs
echo.goto:mm)>"%tmp%\audio_.bat"
start /min /high %tmp%\audio_.bat
goto:eof


:world_1
set "m[1]= ъ     ъ     ъ       ъ      ъ"
set "m[2]=                    ъ     ъ   "
set "m[3]=    ъ       ъ    ъ           ъ"
set "m[4]=        ›››              ››   "
set "m[5]=  ››                     ЫЫ   "
set "m[6]=       ЫЫЫЫЫ                  "
set "m[7]= # #Ы   # #       ЫЫЫ    # #  "
set "m[8]= Э Э    Э Э   ЫЫ       Ы Э Э °"
set "m[9]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
exit /b 0

:world_2
set "m[1]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set "m[2]=Ы                           Ы"
set "m[3]=Ы     ››     ›››          ›› Ы"
set "m[4]=Ы     ЫЫ            ЫЫ      °"
set "m[5]=Ы         ЫЫЫЫЯЫЫЫЫ    ЫЫЫЫЫЫЫ"
set "m[6]=Ы        ЫЫ       Ы ›› Ы     Ы"
set "m[7]=Ы Ы#ЫЫ #ЫЫ       #ЫЫЫЫЫЫ#  ЫЯЫ"
set "m[8]=ЫЫ Э   Э      Э      Э ЫЫ"
set "m[9]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set /a "pc=2"
exit /b 0

:world_3
set  "m[1]=    › › ›                                        "
set  "m[2]=      › ›                                        "
set  "m[3]=    ЫЫЫЫЫЫЫ     ЫЫ  ЫЫЫЫ                  Ы     °"
set  "m[4]=            Ы             ЫЫЫЫЫ   Ы           ЫЯЫЫ"
set  "m[5]=  ЫЯЫЯЫЯЫ    Ы     ››      Ы  Ы     Ы Ы Ы  Ы    "
set  "m[6]=       Ы   ЫЫЫЫЫЫЫ    Ы  Ы›Ы            ›  "
set  "m[7]=          Ы    Ы                Ы›Ы Ы        ›  "
set  "m[8]=                         Ы    ›››Ы   ЫЫЫ      ›  "
set  "m[9]=           Ы                  ЫЫЫЫЫ               "
set "m[10]=                                               "
set "m[11]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set /a "secons=150,view.max=15"
exit /b 0

:world_4
set  "m[1]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ  ъ   ъ   ъ   ъ  "
set  "m[2]=Ы       ЫЫ                           Ы   Ы                 "
set  "m[3]=Ы   ЫЫЫЫ  ЫЫ    ЫЫЫЫ   ЫЫЫЫЫЫЫЫЫЫЫЫЫ Ы Ы Ы Ы    ъ       ъ    "
set  "m[4]=Ы         ЫЫ       Ы Ы Ы             Ы   Ы         ъ       ъ "
set  "m[5]=ЫЫЫЫ   Ы ЫЫЫЫ Ы   Ы Ы Ы    › ›   ЫЫЫЫЫЫЫЫЫЫ  ъ     °° ъ     "
set  "m[6]=Ы   Ы      Ы   ЫЫ Ы     › › ›  Ы            °°       "
set  "m[7]=Ы      ЫЫ ЫЫ ЫЫ      Ы  ЫЫЫЫЫЫЫЫЫЫЫ        Ы  ››  ЫЫЫЫ   ›› "
set  "m[8]=Ы ›››           ЫЫЫЫЫЫЫЫЫ           › › ›  Ы      Ы    Ы     "
set  "m[9]=Ы                                  › › ›  ЫЫ     Ы      Ы    "
set "m[10]=Ы                                ЫЫЫ                "
set "m[11]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set /a "secons=200,view.max=10,pc=2"
exit /b 0

:world_5 [Bonus Level]
set "m[1]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set "m[2]=       Bonus Level!          "
set "m[3]=     Ы                        "
set "m[4]=  ЫЫ                          "
set "m[5]=Ы ›››››››                     "
set "m[6]=Ы›››››››››››››››››››››››››››››"
set "m[7]= Ы››››››››››››››››››››››››››››"
set "m[8]=››››››››››››››››››››››››››››°"
set "m[9]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set /a "view.max=10"
exit /b 0

:world_6
set "m[1]=ЫЫЫЫЫЫ     ъ       ъ    ъ     ъ     ъ     ЫЫЫ"
set "m[2]= Ы››  ›Ы    ъ    ъ                         ° Ы"
set "m[3]= Ы›  ›››Ы__     /~~~~~~\    ___          ЫЫЫЫ"
set "m[4]= ЫЫЫ ››››Ы__}ъ  /   ъ ъ  \  {___}  ъ     Ы"
set "m[5]= Ы   ЫЫЫЫЭъЭ   / ъ    ъ   \  ЭъЭ        Ы"
set "m[6]=  Ы Ы ъ  ЭъЭ  /     ъ   ъ  \ ЭъЭ       Ы"
set "m[7]=  ъ Ы ъ ЫЫЫЫ Ы Ы Ы Ы Ы Ы Ы Ы Ы Ы Ы Ы ЫЫЫ"
set "m[8]=ЫЫ  ъ  Ы                                   "
set "m[9]=ЫЫЫЫЫЫЫЫ"
exit/b 0

:world_7
set "m[1]= ›              ›››››››    Ы"
set "m[2]= ЫЫ     ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ  Ы       "
set "m[3]=     ЫЫ  ›› ››››››››››››››››Ы       Ы"
set "m[4]=  ЫЫ    Ы ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ     Ы  ЫЫЫЫ"
set "m[5]= ›     Ы                    °    ЫЫ"
set "m[6]=ЫЫ       ЫЫЫЫЫЫЫЫЫ     ЫЫ ЫЫЫЫЫЫЫ ЫЫЫ"
set "m[7]=   › Ы                  ЫЫЫ               "
set "m[8]=  ЫЫЫ                                 "
set "m[9]= #  #  #  #  #  #  #  #  #  #  #  #  #  #"
set "m[10]=  Э Э Э Э Э Э Э Э Э Э Э Э Э Э"
set "m[11]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set "m[12]=:::::::::::::::::::::::::::::::::::::::::"
set/a "view.max=15,pc=2"
exit/b 0

:world_8
set "m[1]=ЫЫЫ                            "
set "m[2]=ЫЫ  Ы    › › › › ›› ›         "           
set "m[3]=Ы›Ы   Ы ЫЫЫЫЫЫЫЫЫЫЫЫ ЫЫ"
set "m[4]=Ы›ЫЫ  Ы ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ ЫЫ"
set "m[5]=Ы›Ы   Ы Ы          › ›› ››   ЫЫ"
set "m[6]=Ы›Ы  ЫЫ Ы       ›› ЫЯЫЫЯЫЫ   ЫЫ"
set "m[7]=Ы›ЫЫ ЫЫ Ы    ›› ЫЫЯ       Я  °Ы"
set "m[8]=Ы››››ЫЫ  ›› ЯЫЫЯ  ››       °Ы"
set "m[9]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
exit/b 0

:world_9
set  "m[1]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set  "m[2]= ›                  ›             Ы     ЫЫЫ             "
set  "m[3]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ Ы   Ы   Ы             "
set  "m[4]=Ы                                  ЫЫ  Ы Ы              "
set  "m[5]=Ы ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ   Ы›Ы           ЫЯ  "
set  "m[6]=Ы                                  Ы  ЫЫ›Ы         ЫЯ    "
set  "m[7]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ Ы   Ы›Ы       ЫЯ      "
set  "m[8]=Ы               ›               ›› ЫЫ  Ы›Ы     ЫЯ        "
set  "m[9]=Ы ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ  ЫЫ›Ы   ЫЯ          "
set "m[10]=Ы           ›         ››           ›  ЫЫ   ЫЯ         °  "
set "m[11]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set "m[12]=Ы                                                     "
set "m[13]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set pc=2
exit/b 0

:world_10  [Bonus Level]
set  "m[1]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ        "
set  "m[2]=Ы›   ››  ›› ›       Я    "
set  "m[3]=ЫЫЫ ЫЫ  ЫЫ ЫЫЫ Ы   Ы › ЫЫЫ    "
set  "m[4]=Ы›››››››››››››››››ЫЫЯЫЫЯЯЯЯЯЯЯ"
set  "m[5]=Ы›››››››››››››››››°Ы›      ›››"
set  "m[6]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
exit/b 0

:world_11
set  "m[1]=ъ   ъ    ъ    ъ    ъ    ъ    ъ    "
set  "m[2]=  ъ    Ы   Ы    ъ    ъ    ъ   ъ ъ "
set  "m[3]=Ы    ЫЯЫ  ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ Ы"
set  "m[4]=   Ы Ы›Ы Ы                       Ы"
set  "m[5]=     Ы›Ы  Ы ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set  "m[6]=ЫЫ ЫЫЫ›ЫЫЯЫ "
set  "m[7]=    Ы››››Ы°"
set  "m[8]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set  "m[9]=//////////////////////////////////"
set pc=2
exit/b 0

:world_12
set  "m[1]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ  "
set  "m[2]=                                 ЫЫЫЫЫ  "
set  "m[3]=             Ы   Ы   Ы Ы      Ы Ы°    Ы "
set  "m[4]=   ЫЯЫЯЫЯЫЯЫЫ ЫЫЫ ЫЫЫ  Ы    Ы Ы  Ы    Ы "
set  "m[5]= Ы       Ы       Ы Ы ЫЫ   ЫЫ  Ы   Ы "
set  "m[6]=   ››                Ы       Ы  › Ы Ы "
set  "m[7]=.ЫЫЫ ... . ЫЫЫ . . ЫЫЫ . . .  Ы  Ы   Ы "
set  "m[8]=ЫЫ›››››››Ы"
set  "m[9]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
exit/b 0

:world_13 
set   "m[1]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ            "
set   "m[2]=Ы                                   Ы            "
set   "m[3]=Ы  ъ     ъ     ъ                                  "
set   "m[4]=Ы             ъ   ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ››           "
set   "m[5]=Ы ъ   ъ   ъ        ››››››››››››››››››ЫЫ›          "
set   "m[6]=Ы           ъ   ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ Ы Ы          "
set   "m[7]=Ы ъ››  ъ     ъ   ››››››››››››››››› Ы Ы Ы›        "
set   "m[8]=Ы  ЫЫ      ъ   ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ› Ы Ы  Ы›   ЫЫЫ  "
set   "m[9]=   ъ  ЫЫ Ы  ›››››››››››››››››Ы›°Ы››››››Ы       "
set  "m[10]=ЫЫЫЫЫЫЫЫ   ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ Ы Ы Ы  "
set  "m[11]="
set pc=2
exit/b 0

:world_14
set   "m[1]=ЫЫ ъ›› ъ             ЫЫЫЫЫ      ›        Ы"
set   "m[2]= Ы› ЫЫ       ЫЫЫЫ ЫЯЫ          ЫЫ  ›    Ы"
set   "m[3]=ъЫЫъ   ЫЫЫ   Ы  ›››ЫЫ    ЫЯЫ  Ы  ЯЫЫ ›  Ы"
set   "m[4]=Ы   ъ    Ы Ы ›ЫЫЫЫЫЫЫЫ  ›  ›Ы     ЫЫ Ы"
set   "m[5]=ъЫ›ъ ›  ъ ЫЫ  Ы        ›ЯЫЫЫ            Ы"
set   "m[6]= ЫЫЫЫЫЫ  Ы ››Ы       ›ЯЫ                 Ы"
set   "m[7]= ъ Яъ  ъЫ› ЫЫ      ›ЯЫ                  Ы"
set   "m[8]=ъ ЫЫЫ ъ ЫЫЯЯЯ      ЫЯ° › ›  ›› ›  ›   ››Ы"
set   "m[9]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set pc=2
exit/b 0

:world_15 [New World Dimention]
set  "m[1]= ъ  ъ   ъ    ъ   ›  ъ  ъ {___}ъ ъ"
set  "m[2]=            ъ  › Ы › ъ  ъ Э Эъ ъ "
set  "m[3]= ъ     ъ     › Ы Ы Ы ›  ъ Э Э ъ ъ"
set  "m[4]= ___ъ  ъ ъ › Ы Ы Ы Ы Ы ›ъ Э°Эъ ъ "
set  "m[5]={___}    › Ы Ы Ы Ы Ы Ы Ы ЫЫЫЫ ъ ъ"
set  "m[6]= Э Э   › Ы Ы Ы Ы Ы Ы Ы Ы ъ ъ ъ ъ "
set  "m[7]=Э Эъ› Ы Ы Ы Ы Ы Ы Ы Ы Ыъ ъ ъ ъ ъ"
set  "m[8]= Э Э ЫЫЫЫЫЫЫЫЫЫ"
set  "m[9]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
exit/b 0

:world_16
set "m[1]= .   .    .  .   . ____  "
set "m[2]=  °   .           {____} Ы"
set "m[3]= ЫЫЫ ›   .   .    ЭъъЭ_ Ы"
set "m[4]=     Ы  ›››       _Э{___}Ы"
set "m[5]=  ЫЫЫ  ››› Ы{___ЭъЭ Ы"
set "m[6]=.   .  ЫЫЫЫ   ЭъЭЭъЭ Ы"
set "m[7]=  ›› ›››   ››  ›› ЭъЭЭъЭЫЫ"
set "m[8]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set pc=2
exit/b 0

:world_17
set  "m[1]= ъ  ъ  ъ ›ъ› ъ  ъ  ъ  ъ  ъ  ъ Ы "
set  "m[2]=       ЫЫЫЫЫЫ                Ы "
set  "m[3]=          .,  ЫЫЫЫЫЫЫЫЫЫ     ЫЫ "
set  "m[4]=      .,.   ››››› ›  ››  Ы  Ы"
set  "m[5]=ЫЫЫЫЫЫЫ ,__ ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ›Ы "
set  "m[6]=       /   \  /\  /   \     ››Ы"
set  "m[7]=      /~~~~~\/__\/~~~~~\    ЫЫЫ"
set  "m[8]=    /.  . . \__/ . . . \   °°Ы"
set  "m[9]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set "m[10]=O//O//O//O//O//O//O//O//O//O//O"
exit/b 0

:world_18
set  "m[1]=   ››Э°°Э››         ››››  ›››Ы"
set  "m[2]=›› ЫЫЫЫЫЫЫЫ   ЫЫЫЫ ЫЫЫЫЫ ЫЫЫЫЫ"
set  "m[3]=››          Ы                Ы"
set  "m[4]=››Ы      Ы Ы   ›››           Ы"
set  "m[5]=ЫЫ   ЫЫ                ››    Ы"
set  "m[6]=ЫЫЫЫЫ       ››››   ›››    Ы"
set  "m[7]=ЫЫЫЫЫЫЫЫЫЫ     ››››   ›››    Ы"
set  "m[8]=Ы   {___}    ЫЫЫЫЫЫЫ ЫЫЫЫ    Ы"
set  "m[9]=Ы    ЭъЭ   Ы              ›››Ы"
set "m[10]=ЫЫЯЫ ЭъЭ  Ы     /~~\   ЫЯЯЯЫ"
set "m[11]=Ы ЫЭъЭ Ы/. . \ ЫЫ"
set "m[12]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set pc=2
exit/b 0

:world_19 [Special Level]
set "pick="
set "border=."
set  "m[1]=               ››››       ››                "            
set  "m[2]=              ______ ›   ____               "
set  "m[3]=            ››{......}___{....}   ›  ››   ›  "
set  "m[4]=    ››   ______Э ъ ъЭ....}Э  Э›  __________° "
set  "m[5]=  ______{......}ъ ъ ЭЭъ Э Э  Э__{...........}"
set  "m[6]= {......}Эъ ъ ЭЭ ъ ъЭЭ ъЭ Э {...} Эъ ъ ъЭ    "
set  "m[7]= Эъ ъ Э Э ъ ъЭЭъ ъ ЭЭъ Э Э  ЭъЭ  Э ъ ъ Э    "
set  "m[8]=.ЭЭЭЭъ ъ ъЭ"
exit/b 0

:world_20
set pc=2
set  "m[1]=           ››››                 "
set  "m[2]= ъ  ъ  ъ  ЫЫЫЫЫЫ      ››  ъ››   "
set  "m[3]=       ››      ЫЫЫЫЫЫЫЫЫЫЫ"
set  "m[4]= ъ    ЫЫЫЫъ ъ  ъ   ъ  ъ   ъ   ъ  "
set  "m[5]=  ъ ъ  ъ  ъ      ъ ъ       ъ    "
set  "m[6]=           ЫЫЫЫЫЫЫ  ъ   ъ    ъ "
set  "m[7]=  ЫЫ ЫЫЫ_ЫЫЫ ъ  ъ   _ЫЫЫ      °  "
set  "m[8]=ъ  ъ  / ъ\ ъ  ъ    / ъъ \ЫЫЫЫЫЫъ "
set  "m[9]=   _ъ/ъ_ъ_\____ъ__/ъ_ъ_ъ_\______ "
set "m[10]=  /\"
set "m[11]= /\"
set "m[12]=/\"
set "m[13]= 
exit/b 0

:world_21 [New blocks]
set  "m[1]= /~~\      /~~~~\       /\
set  "m[2]=/   \.,,./...,.,\,.,.,/,.\ "
set  "m[3]=ЫЫЫ::::::::::::::::::::::ЫЫЫ"
set  "m[4]=±±±±±±±±±±±±±±±±±±±±±Ы±±±±±±"
set  "m[5]=±±±ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ±±ЫЫ±±±"
set  "m[6]=±±±±Ы±±±±±±±±±±±±±±±Ы°±ЫЫЫ"
set  "m[7]=ЫЫЫ±±Ы±±±±±±    ЫЫЫЫЫ    "
set  "m[8]=   Ы   ЫЫЫЫЫЫЫЫЫЫЫ     ±±± Ы"
set  "m[9]=                       ±±±ЫЫ"
set "m[10]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set pc=2
exit/b 0

:world_22
set  "m[1]={___}ъ    ъ   ъ     ъ    ъ   ъ {___}"
set  "m[2]=ЭъЭ   ъ   ъ     ъ     ъ   ъ    ЭъЭ"
set  "m[3]=ЫЫЫ±±±±ЫЫЫ±±±ЫЫЫ±±±ЫЫЫ±±±ЫЫЫ±±ЫЫЭъЭЫ"
set  "m[4]=±±±±±ЫЫ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±"
set  "m[5]=±±±±±±±±ЫЫ±±±±ЫЫЫЫ±±±±ЫЫЫ±±±±ЫЫЫ±±±±"
set  "m[6]=±±±±±±±±±±±±±±±±±±±±±±±±Ы±±±±±±±±±"
set  "m[7]=ЫЫЫ±±±ЫЫ±±±±ЫЫЫ±±±ЫЫЫЫ±±±ЫЫЫ±±±ЫЫЫ±"
set  "m[8]=±±±±±±±±±±±±±±±±±±±±±±±±±±±±Ы±±±±±±Ы"
set  "m[9]=±±±±±ЫЫЫ±±±ЫЫЫ±±±±ЫЫЫ±±±±Ы±±±ЫЫЫЫЫЫ±"
set "m[10]=±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±"
set "m[11]=ЫЫЫЫ±±±±ЫЫЫ±±ЫЫЫ±±±±ЫЫЫ±±±ЫЫЫ±±±Ы"
set "m[12]=                                   °"
set "m[13]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
exit/b 0

:world_23 [New Objective]
set  "m[1]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set  "m[2]=Ы    @                 Ы±±±Ы"
set  "m[3]=Ы ъЫЫЫЫЫ  ъ  ъ  ъ  ъ   ЫЫЫЫЫ"
set  "m[4]=Ы ъ  ъ                 ЫЫЫЫ" 
set  "m[5]=ЫЫ     ъ    ъ   ъ   Ы±±±±Ы"
set  "m[6]=Ы   ЫЫ               Ы±±±±Ы"
set  "m[7]=Ы               ЫЫ  ЫЫЫЫ±Ы" 
set  "m[8]=ЫЫЫ  ъ  ЫЫЫ  ЫЫЫЫ  _   __±Ы"
set  "m[9]=Ы          ъ   {_ЫЫ{___}Ы"
set "m[10]=Ы        /~~\  ЫЫЫ ЭъЭ ЭъЭЫЫ"
set "m[11]=Ы Ы ЫЫ/ъЫЫЫ\/ ъ\ ЭъЭ ЭъЭЫЫ"
set "m[12]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ"
set lch=10
set pc=2
exit/b 0

:world_24
set  "m[1]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ
set  "m[2]=Ы           Ы   Ы       ЫЫЫЫ       Ы
set  "m[3]=ЫЫЫ     ›› ЫЫ  Ы   ›› Ы Ы ЫЫЫъ  ъ  ъЫ
set  "m[4]=Ы› ЫЫ  ЫЫ  ЫЫЫЫЫЫЫЫЫЫЫЫЫЫ  Ы  ъ  ъ Ы
set  "m[5]=Ы   ЫЫ   Ы››››››       ЫЫЫ Ыъ  ъ  ъЫ
set  "m[6]=ЫЫ    _ЫЫЫ ЫЯЫЫЫЫЫЫЫЫЫЫЫЫЫЫ   Ы   @   Ы
set  "m[7]=Ы›  {___} Ы     ›››››› Ы ЫЫЫ  Ы  Ы
set  "m[8]=ЫЫЫ   ЭъЭ ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЯЫ     ЫЫЫ Ы
set  "m[9]=Ы ››ЭъЭ›› Ы››››››››››››     ЫЫЫЫЫ Ы
set "m[10]=ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ
set lch=17
exit/b 0
goto:eof