echo off
echo %1. %2: %3
echo %path%
if "%path%"=="" goto er98
pause
set red=sNet2010
if "%1"=="98" goto er98
if exist d:\bin\f7\f7.exe goto f7
goto fin
:er98
echo w98
\bin\f2\foxpro pelis
go to yarun
:f7
echo F7
d:\bin\f7\f7.exe pelis
:yarun

DEL *.BAK
rem DEL *.FXP
DEL FOXU*.*
rem net use z: \\home05\film /y
DEL KK*.*
del d.bat
del *.fxp
del *.tmp
del dir.txt
del *.ba 
rem solo primera vez,crea ficheros a actualizar despues
if exist *.zip goto actualiza

ECHO Creando Ficheros ZIP
rem del *.zip
rem pkzip PELIEXE peli.dbf /D -%red%

trata\pkzip peli -u peli.dbf -%red%

pause
goto fin

:actualiza
ECHO Actualizando ficheros...
echo Comprime programa ,menos peli.dbf,paux.dbf y peli.zip
trata\PKZIP PELIEXE *.* -xp???.* -%red% -p -u -t

echo comprime datos, solo bd
trata\PKZIP PELI peli.dbf -%red% -p -u -t


:fin
if "%1"=="98" goto theEND
set red=
rem xcopy peli*.zip \misdocs\"My DropBox" /D /y
trata\pkunzip  trata\peliexe -%red% Ini1.ba
echo %red%

pause
trata\pkzip peliexe  -%red% -u *.* -xini1.ba -xpeli.zip -xpeli.dbf

pause
ftp -n -s:ini1.ba|find /v"raf"
echo .>ini1.ba
d:
cd \
if not exist peli*.zip goto MALENVIO
del \peli*.zip
echo ok 
echo TRANSMISION EFECTUADA +++        
goto final
:MALENVIO   
echo =================================================                 
echo ATENCION.ENVIO NO REALIZADO.INTENTELO DESPUES ---            
echo =================================================                 
:final
echo close 
echo Finalizado programa de transmision ftp.
pause 
:TheEND
