
@echo off 
echo Pulsa [control+Inter] para abortar la transmision
echo Iniciando transmision Backup...
ftp -n -s:ini1.ba|find /v"raf"
echo .>ini1.ba
echo FIN TRANSMISION  +++        
goto fin
:MALENVIO   
echo ATENCION.ENVIO NO REALIZADO.INTENTELO DESPUES ---            
:fin
echo close 
echo Finalizado programa de transmision ftp.
pause 
