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
echo.	   �       .::{Batch}::.         �
ECHO.	(_)�     .::{Adventures}::.      �(__)
ECHO. 	  `-----------------------------'
echo. 	 __       2012-Honguito98
echo. 	(__)                           __
echo.	                              ("_)
echo.	._____________________________o()O______.
echo.	�/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/�
echo.	�:::::::::::::::::::::::::::::::::::::::�
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
echo.Seleccione un tama�o de pantalla
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
echo. Romper bloques �          ^<Espacio^>
echo.
echo.  Presione una tecla para regresar . . .
pause >nul
goto :reset


:load
set "bar="
set "percent=0"
set "count=0"
for /l %%i in (1,1,20) do set "bar=!bar!�"
:loop
set /p "= %bar:~0,20% %percent%%%"<nul
::set ran=%random:~0,1%
ping -n 1 -w 1 localhost>nul
for /l %%i in (1,1,26) do set /p "="<nul
set "bar=�%bar%"
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
set /p "=�Salto : %up%"<nul

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

if "!chr!"=="�" if "%4"=="gravity" set chr=_
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
echo.&set /p "=�Presione Enter para continuar . . . " <nul
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
set /p "=.             ����" <nul
set "border=�"
set "ground= "
set "block=�"
set "player="
set "keyps="
set "enemy="
set "coin=�"
set chk=0
set lch=00
ping -n 1 localhost>nul
set "exit=�"
set "exit2=@"
set /p "=��" <nul
set "live="
set "pick="
set "pc=1"
set "kb=no"
taskkill /fi "WINDOWTITLE eq Audio">nul
set /a "map.col=map.row=view.max=view.min=finish=0,secons=100"
set "view.max=30"
for /f "delims==" %%i in ('"set m[ 2>nul|findstr /r "m\[[0-9]*\]=""') do set "%%i="
set /p "=���" <nul
if %world% lss 1 set /a "world=1"
call :world_%world% 2>nul || exit /b 1
call :music!pc!
set /p "=��" <nul
for /f %%i in ('"set m[ 2>nul|findstr /r "m\[[0-9]*\]=""') do set /a "map.row+=1"
set /p "=��" <nul
if %map.row% equ 0 exit /b 1
call :strLen m[1] map.col
if !view.max! lss 1 set /a "view.max=map.col"
if !view.max! gtr %map.col% set /a "view.max=map.col"
set /p "=��" <nul
call :getPstn player player.pos
set /p "=��" <nul
call :getPstn enemy enemies.pos
set /p "=��" <nul
set /p "=��" <nul
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
set "m[1]= �     �     �       �      �"
set "m[2]=                    �     �   "
set "m[3]=    �       �    �           �"
set "m[4]=        ���              ��   "
set "m[5]=  ��                     ��   "
set "m[6]=       �����                  "
set "m[7]= # #�   # #       ���    # #  "
set "m[8]= � �    � �   ��       � � � �"
set "m[9]=������������������������������"
exit /b 0

:world_2
set "m[1]=������������������������������"
set "m[2]=�                           �"
set "m[3]=�     ��     ���          �� �"
set "m[4]=�     ��            ��      �"
set "m[5]=�         ���������    �������"
set "m[6]=�        ��       � �� �     �"
set "m[7]=� �#�� #��       #������#  ���"
set "m[8]=�� �   �      �      � ��"
set "m[9]=������������������������������"
set /a "pc=2"
exit /b 0

:world_3
set  "m[1]=    � � �                                        "
set  "m[2]=      � �                                        "
set  "m[3]=    �������     ��  ����                  �     �"
set  "m[4]=            �             �����   �           ����"
set  "m[5]=  �������    �     ��      �  �     � � �  �    "
set  "m[6]=       �   �������    �  ۛ�            �  "
set  "m[7]=          �    �                ۛ� �        �  "
set  "m[8]=                         �    ����   ���      �  "
set  "m[9]=           �                  �����               "
set "m[10]=                                               "
set "m[11]=��������������������������������������������������"
set /a "secons=150,view.max=15"
exit /b 0

:world_4
set  "m[1]=��������������������������������������������  �   �   �   �  "
set  "m[2]=�       ��                           �   �                 "
set  "m[3]=�   ����  ��    ����   ������������� � � � �    �       �    "
set  "m[4]=�         ��       � � �             �   �         �       � "
set  "m[5]=����   � ���� �   � � �    � �   ����������  �     �� �     "
set  "m[6]=�   �      �   �� �     � � �  �            ��       "
set  "m[7]=�      �� �� ��      �  �����������        �  ��  ����   �� "
set  "m[8]=� ���           ���������           � � �  �      �    �     "
set  "m[9]=�                                  � � �  ��     �      �    "
set "m[10]=�                                ���                "
set "m[11]=������������������������������������������������������������"
set /a "secons=200,view.max=10,pc=2"
exit /b 0

:world_5 [Bonus Level]
set "m[1]=������������������������������"
set "m[2]=       Bonus Level!          "
set "m[3]=     �                        "
set "m[4]=  ��                          "
set "m[5]=� �������                     "
set "m[6]=ۛ����������������������������"
set "m[7]= ۛ���������������������������"
set "m[8]=�����������������������������"
set "m[9]=������������������������������"
set /a "view.max=10"
exit /b 0

:world_6
set "m[1]=������     �       �    �     �     �     ���"
set "m[2]= ۛ�  ��    �    �                         � �"
set "m[3]= ��  ����__     /~~~~~~\    ___          ����"
set "m[4]= ��� �����__}�  /   � �  \  {___}  �     �"
set "m[5]= �   �������   / �    �   \  ���        �"
set "m[6]=  � � �  ���  /     �   �  \ ���       �"
set "m[7]=  � � � ���� � � � � � � � � � � � � ���"
set "m[8]=��  �  �                                   "
set "m[9]=��������"
exit/b 0

:world_7
set "m[1]= �              �������    �"
set "m[2]= ��     �������������������  �       "
set "m[3]=     ��  �� �����������������       �"
set "m[4]=  ��    � �������������������     �  ����"
set "m[5]= �     �                    �    ��"
set "m[6]=��       ���������     �� ������� ���"
set "m[7]=   � �                  ���               "
set "m[8]=  ���                                 "
set "m[9]= #  #  #  #  #  #  #  #  #  #  #  #  #  #"
set "m[10]=  � � � � � � � � � � � � � �"
set "m[11]=�����������������������������������������"
set "m[12]=:::::::::::::::::::::::::::::::::::::::::"
set/a "view.max=15,pc=2"
exit/b 0

:world_8
set "m[1]=���                            "
set "m[2]=��  �    � � � � �� �         "           
set "m[3]=ۛ�   � ������������ ��"
set "m[4]=ۛ��  � �������������������� ��"
set "m[5]=ۛ�   � �          � �� ��   ��"
set "m[6]=ۛ�  �� �       �� �������   ��"
set "m[7]=ۛ�� �� �    �� ���       �  ��"
set "m[8]=ۛ�����  �� ����  ��       ��"
set "m[9]=����������������������"
exit/b 0

:world_9
set  "m[1]=���������������������������������������������������������"
set  "m[2]= �                  �             �     ���             "
set  "m[3]=���������������������������� �   �   �             "
set  "m[4]=�                                  ��  � �              "
set  "m[5]=� �������������������������������   ۛ�           ��  "
set  "m[6]=�                                  �  �ۛ�         ��    "
set  "m[7]=������������������������������ �   ۛ�       ��      "
set  "m[8]=�               �               �� ��  ۛ�     ��        "
set  "m[9]=� ����������������������������  �ۛ�   ��          "
set "m[10]=�           �         ��           �  ��   ��         �  "
set "m[11]=������������������������������������������"
set "m[12]=�                                                     "
set "m[13]=���������������������������������������������������������"
set pc=2
exit/b 0

:world_10  [Bonus Level]
set  "m[1]=����������������������        "
set  "m[2]=ۛ   ��  �� �       �    "
set  "m[3]=��� ��  �� ��� �   � � ���    "
set  "m[4]=ۛ����������������������������"
set  "m[5]=ۛ�����������������ۛ      ���"
set  "m[6]=������������������������������"
exit/b 0

:world_11
set  "m[1]=�   �    �    �    �    �    �    "
set  "m[2]=  �    �   �    �    �    �   � � "
set  "m[3]=�    ���  ����������������� �"
set  "m[4]=   � ۛ� �                       �"
set  "m[5]=     ۛ�  � ��������������������"
set  "m[6]=�� ��ۛ���� "
set  "m[7]=    ۛ�����"
set  "m[8]=����������������������������������"
set  "m[9]=//////////////////////////////////"
set pc=2
exit/b 0

:world_12
set  "m[1]=��������������������������������������  "
set  "m[2]=                                 �����  "
set  "m[3]=             �   �   � �      � ۰    � "
set  "m[4]=   ���������� ��� ���  �    � �  �    � "
set  "m[5]= �       �       � � ��   ��  �   � "
set  "m[6]=   ��                �       �  � � � "
set  "m[7]=.��� ... . ��� . . ��� . . .  �  �   � "
set  "m[8]=�ۛ�������"
set  "m[9]=����������������������������������������"
exit/b 0

:world_13 
set   "m[1]=��������������������������������������            "
set   "m[2]=�                                   �            "
set   "m[3]=�  �     �     �                                  "
set   "m[4]=�             �   ������������������ۛ�           "
set   "m[5]=� �   �   �        �������������������ۛ          "
set   "m[6]=�           �   �������������������� � �          "
set   "m[7]=� ���  �     �   ����������������� � � ۛ        "
set   "m[8]=�  ��      �   �����������������ۛ � �  ۛ   ���  "
set   "m[9]=   �  �� �  �����������������ۛ�ۛ������       "
set  "m[10]=��������   ���������������������������� � � �  "
set  "m[11]="
set pc=2
exit/b 0

:world_14
set   "m[1]=�� ��� �             �����      �        �"
set   "m[2]= ۛ ��       ���� ���          ��  �    �"
set   "m[3]=����   ���   �  �����    ���  �  ��� �  �"
set   "m[4]=�   �    � � ���������  �  ��     �� �"
set   "m[5]=�ۛ� �  � ��  �        �����            �"
set   "m[6]= ������  � ���       ���                 �"
set   "m[7]= � ��  �ۛ ��      ���                  �"
set   "m[8]=� ��� � �����      �߰ � �  �� �  �   ���"
set   "m[9]=���������������������������������"
set pc=2
exit/b 0

:world_15 [New World Dimention]
set  "m[1]= �  �   �    �   �  �  � {___}� �"
set  "m[2]=            �  � � � �  � � �� � "
set  "m[3]= �     �     � � � � �  � � � � �"
set  "m[4]= ___�  � � � � � � � � �� ݰ�� � "
set  "m[5]={___}    � � � � � � � � ���� � �"
set  "m[6]= � �   � � � � � � � � � � � � � "
set  "m[7]=� ��� � � � � � � � � �� � � � �"
set  "m[8]= � � ����������"
set  "m[9]=���������������������������������"
exit/b 0

:world_16
set "m[1]= .   .    .  .   . ____  "
set "m[2]=  �   .           {____} �"
set "m[3]= ��� �   .   .    ����_ �"
set "m[4]=     �  ���       _�{___}�"
set "m[5]=  ���  ��� �{___��� �"
set "m[6]=.   .  ����   ������ �"
set "m[7]=  �� ���   ��  �� ��������"
set "m[8]=�������������������������"
set pc=2
exit/b 0

:world_17
set  "m[1]= �  �  � ��� �  �  �  �  �  � � "
set  "m[2]=       ������                � "
set  "m[3]=          .,  ����������     �� "
set  "m[4]=      .,.   ����� �  ��  �  �"
set  "m[5]=������� ,__ ����������������ۛ� "
set  "m[6]=       /   \  /\  /   \     ���"
set  "m[7]=      /~~~~~\/__\/~~~~~\    ���"
set  "m[8]=    /.  . . \__/ . . . \   ���"
set  "m[9]=�������������������������������"
set "m[10]=O//O//O//O//O//O//O//O//O//O//O"
exit/b 0

:world_18
set  "m[1]=   ��ݰ�ݛ�         ����  ����"
set  "m[2]=�� ��������   ���� ����� �����"
set  "m[3]=��          �                �"
set  "m[4]=���      � �   ���           �"
set  "m[5]=��   ��                ��    �"
set  "m[6]=�����       ����   ���    �"
set  "m[7]=����������     ����   ���    �"
set  "m[8]=�   {___}    ������� ����    �"
set  "m[9]=�    ���   �              ����"
set "m[10]=���� ���  �     /~~\   �����"
set "m[11]=� ���� �/. . \ ��"
set "m[12]=������������������������������"
set pc=2
exit/b 0

:world_19 [Special Level]
set "pick="
set "border=."
set  "m[1]=               ����       ��                "            
set  "m[2]=              ______ �   ____               "
set  "m[3]=            ��{......}___{....}   �  ��   �  "
set  "m[4]=    ��   ______� � ��....}�  ݛ  __________� "
set  "m[5]=  ______{......}� � ��� � �  �__{...........}"
set  "m[6]= {......}�� � �� � ��� �� � {...} �� � ��    "
set  "m[7]= �� � � � � ���� � ��� � �  ���  � � � �    "
set  "m[8]=.����� � ��"
exit/b 0

:world_20
set pc=2
set  "m[1]=           ����                 "
set  "m[2]= �  �  �  ������      ��  ���   "
set  "m[3]=       ��      �����������"
set  "m[4]= �    ����� �  �   �  �   �   �  "
set  "m[5]=  � �  �  �      � �       �    "
set  "m[6]=           �������  �   �    � "
set  "m[7]=  �� ���_��� �  �   _���      �  "
set  "m[8]=�  �  / �\ �  �    / �� \������� "
set  "m[9]=   _�/�_�_\____�__/�_�_�_\______ "
set "m[10]=  /\"
set "m[11]= /\"
set "m[12]=/\"
set "m[13]= 
exit/b 0

:world_21 [New blocks]
set  "m[1]= /~~\      /~~~~\       /\
set  "m[2]=/   \.,,./...,.,\,.,.,/,.\ "
set  "m[3]=���::::::::::::::::::::::���"
set  "m[4]=���������������������۱�����"
set  "m[5]=��������������������۱��۱��"
set  "m[6]=����۱��������������۰����"
set  "m[7]=��۱�۱�����    �����    "
set  "m[8]=   �   �����������     ��� �"
set  "m[9]=                       �����"
set "m[10]=����������������������������"
set pc=2
exit/b 0

:world_22
set  "m[1]={___}�    �   �     �    �   � {___}"
set  "m[2]=���   �   �     �     �   �    ���"
set  "m[3]=��۱�����۱����۱����۱����۱�������"
set  "m[4]=������۱����������������������������"
set  "m[5]=���������۱������۱�����۱�����۱���"
set  "m[6]=������������������������۱��������"
set  "m[7]=��۱���۱�����۱�����۱����۱����۱"
set  "m[8]=����������������������������۱������"
set  "m[9]=�������۱����۱�����۱���۱�������۱"
set "m[10]=�����������������������������������"
set "m[11]=���۱�����۱���۱�����۱����۱���"
set "m[12]=                                   �"
set "m[13]=������������������������������������"
exit/b 0

:world_23 [New Objective]
set  "m[1]=����������������������������"
set  "m[2]=�    @                 ۱���"
set  "m[3]=� ������  �  �  �  �   �����"
set  "m[4]=� �  �                 ����" 
set  "m[5]=��     �    �   �   ۱����"
set  "m[6]=�   ��               ۱����"
set  "m[7]=�               ��  ���۱�" 
set  "m[8]=���  �  ���  ����  _   __��"
set  "m[9]=�          �   {_��{___}�"
set "m[10]=�        /~~\  ��� ��� �����"
set "m[11]=� � ��/����\/ �\ ��� �����"
set "m[12]=����������������������������"
set lch=10
set pc=2
exit/b 0

:world_24
set  "m[1]=���������������������������������������
set  "m[2]=�           �   �       ����       �
set  "m[3]=���     �� ��  �   �� � � ����  �  ��
set  "m[4]=ۛ ��  ��  ��������������  �  �  � �
set  "m[5]=�   ��   ۛ�����       ��� ��  �  ��
set  "m[6]=��    _��� ����������������   �   @   �
set  "m[7]=��  {___} �     ������ � ���  �  �
set  "m[8]=���   ��� �����������������     ��� �
set  "m[9]=� ����ݛ� �������������     ����� �
set "m[10]=����������������������������������
set lch=17
exit/b 0
goto:eof