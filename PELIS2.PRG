*fic:PELIS.PRG  para tratar la bd de peliculas peli.dbf 
*PELICOMB.PRG   ,combinaciones para calcular sumas de tama¤os
*PELIBUS.PRG    ,para buscar peliculas 
*PELISUMA.PRG   , para mover \film a .. las que sumen sobre 4700 MB
*PELIMETE.PRG   , para meter un dir.txt en b.d. directo
*PELIMENT.PRG   , idem version xp profesional
* Primera version Dic.2005
* version julio 2007, encripta, intro para acabar combinaciones
* version Ene 2010, busca en bd pelicula.dbf
SELE 1
SET SAFE OFF
set dele on
USE PAUX alias auxi && *USE AUXI
if upper(sonido)='N'
 set bell off
else
 set bell on
endif
if vers()="Visual"  && si vfp no preguntes compatibilidad bd
 set cpdial off
endif
m_kk=0
acce"Clave:"to que
if que<>chr(65+32)+chr(97) &&'aa'
 do salir
endif
set echo off
*set cons off
do miprog
do salir
function w && write encriptado
parameter v_i
r_i=v_i
return r_i
*endfunc
************************************
function r && read encriptado
parameter v_i
r_i=v_i
return r_i
*endfunc
************************************
proce salir
 quit
return
proce miprog
m_bdp2=rtrim(auxi->ctedir)+"peli"
DO WHILE .T.
 SET FORMAT TO PELIS
 READ
 v_tec=upper(auxi->s_n)
DO CASE && HSBKMALOPN
 CASE v_tec='H'
  do lah
 CASE v_tec='S'
  do mandaftp   && solo se manda se se modifico
  do salir
 CASE v_tec='B'
  DO PELIBUS
 CASE v_tec='K'
  do lak
 CASE v_tec='M' &&HAZ DIR Y METELO EN BD
  do lam
 CASE v_tec='A' &&AGRUPAR
  DO PELISUMA
 CASE v_tec='C'
  DO configura
 CASE v_tec='F'
  DO modiftp
 CASE v_tec='L'
  SELE 2
  USE (m_bdp2) alias pelis
  set cons off
  REPO FORM PELIS TO FILE KK.TXT
  do ver with "KK.TXT"
 CASE v_tec='O'
  SELE 2
  USE (m_bdp2) alias pelis
  INDE ON DVD TO KK1
  set cons off
  REPO FORM PELISA TO FILE KK1.TXT
  do ver with "KK1.TXT"
 CASE v_tec='P'
  acce "listado por orden dvd >0. Sigo(s/n)" to que
  if upper(que)<>'N'
   SELE 2
   USE (m_bdp2) alias pelis
   INDE ON DVD TO KK1
   set cons off
   REPO FORM PELISA for dvd>0 TO FILE KK1.TXT
   do ver with "KK1.TXT"
  endif
 CASE v_tec='N'
  SELE 2
  USE (m_bdp2) alias pelis
  inde on NOMBRE to kk
  set cons off
  REPO FORM PELIS TO FILE KK.TXT
  do ver with "KK.TXT"
ENDCASE
set cons on
ENDDO
return
proce lah
  SELE 2
*  use
  SELECT r(DVD),r(TIP),r(OCUPA),r(NOMBRE),r(ES),r(SEHIZO) from peli
  brow
*  use
* USE PELIS
  go bott
*  brow field r(DVD),r(TIP),r(OCUPA),r(NOMBRE),r(ES),r(SEHIZO) && encriptado
return
* aqui no llegamos nunca
proce configura
sele 1
use paux alias auxi
edit
return
* aqui no llegamos nunca
proce lak
  sele 3
  m_bdp=rtrim(auxi->ctedir)+"pelicula"
  use (m_bdp) && proviene de tabla mdb titolo, graba excel,
  @ 0,0 clear to 24,79 && en excel cambia campo a tama¤o 254, y grab dbase4
  @2,2 say " BUSCAR EN B.D. pelicula.dbf"
  @3,1 say "Nom:" get auxi->despro
  read
  m_nom=upper(rtrim(ltrim(auxi->despro)))
  loca for m_nom$TITOLO
  brow  title '^w da detalles'
  ?readkey()
  if readkey()=270 && ^w
   list next 1
   ? "Asunto:"
   ? Descrizion
  endif
  wait "intro"  

return
 proce lam
   sele 2
   USE (m_bdp2) alias pelis
   go bott
   do while dvd=0
    skip -1
   enddo
   m_ult=DVD
   sele 1
   repla numdvd with m_ult+1
     if os()="DOS 05.00" && Windows xp"  && nov-2005
      v_prg="peliment"
     else &&antes
      v_prg="pelimete"
     endif
*   repla des with v_prg
  clear
  set form to meter
  read
*set step on
  if upper(auxi->s_n)<>'S' && no seguir
   return
  endif
  if upper(auxi->s_n1)='S' 
   m_fr=" dir "+rtrim(auxi->descd)+">dir.txt"
   set print to d.bat
   set print on
   ?"rem ejecuta d [intro]"
   ?m_fr
   ?"edit dir.txt"
   set print off
   set print to
   run type d.bat
   run "dir >dir2.txt"
   acce"intro" to que
   M_FRA="command"
   run &M_FRA
*   RUN "EDIT DIR.TXT" && metido en d.bat
  endif
    DO PELIMETE with "dir.txt","peli",37,23,13

  brow
 return
***********************************************************************
proce ver && visualiza fichero .txt desde vfp
para v_fic
modi comm (v_fic)
return && **********************************************************
proce mandaftp  && mira si hay que mandar por ftp
if auxi->depura='S'
 susp
endif
if versi()='FoxPro 2.6'
 return
endif
*sele pelis && bd a hacer bakup
*use && zona libre
dime mdir(1) && array recibe dir fic. nombre,tamaño,fecha hora, tipo "A"
m_1=rtrim( auxi->des)+"\peli."
m_c=m_1+"dbf" &&
m_z=m_1+"zip"
adir (mdir,m_c, "S") && llena matriz con fic. que cumplan m_c
m_hay=alen(mdir) && matriz
* cada reg. tiene 5 entradas m_hay/5
if  m_hay<5 && existe 4 regis. por fichero
* do aviso with "Sin ficheros *.dis para hacer.",.f.
 return
endif
v_fec= Mdir(1,3)
v_time= Mdir(1,4)
if auxi->fecold<v_fec .and. auxi->horold<v_time && hubo cambios
 m_r="PKZIP "+m_z+" "+m_c+" -SPillo.2010 -p -u -t"
 run &M_r
 do envioftp
 repla auxi->fecold with v_fec,  auxi->horold with v_time
endif
return
proce envioftp
m_ult="peli*.zip"
m_di= rtrim(auxi->des)
v_posuni=at(":",m_di) && sera 3
v_unidad= substr(m_di,1,v_posuni) && "d:"
set print to ini1.bat
set print on
* cuando haya .dis pasa ,todos los .dis , .inc y los .mod a copia
?"@echo off"
?"echo Pulsa [control+Inter] para abortar la transmision"
?"echo Iniciando transmision Backup..."
?'ftp -n -s:ini1.ba|find /v"'+substr( encri(auxi->claveftp),1,3)+'"'
?"echo .>ini1.ba"
? v_unidad && me cambio a letra de unidad desde donde hago el ftp 
?"cd \"
?"if not exist "+m_ult+" goto MALENVIO"
?"del \"+m_ult
* si se recibio ultimo se mueven los transmitidos y se borra el ult.recibido
?"echo ok"
?"echo TRANSMISION EFECTUADA +++"
?"goto fin"

?":MALENVIO"
?"echo ================================================="
?"echo ATENCION.ENVIO NO REALIZADO.INTENTELO DESPUES ---"
?"echo ================================================="
?":fin"
?"echo close"
?"echo Finalizado programa de transmision ftp."
?"pause"
set print off
set echo off
set print to

set console off
set prin to ini1.ba
set print on
?"open "+trim(auxi->dirftp) && "172.18.96.100"
?"user "+rtrim(auxi->usuftp) &&CORFAR321
? rtrim( encri(auxi->claveftp) ) &&be10
?"promp"
?"bina"
?"quote pwd"
?"lcd"
?"status"
?"lcd "+ left(m_di,len(m_di)-1) && e:\recetaxxi tenia | al final
*if v_haydis  && si hay fic.  transmitelos
 ?"mput peli.zip"
*endif

?"lcd \"
?"mget peli.zip"
* intento recoger el fichero del servidor ftp->parar saber si envio fue ok"
?"bye"
set print off
set echo on
set console on
set print to
!"ini1.bat"      && ejecuta fichero bat que usa ini1.ba usado por ftp.exe
!"del ini1.b*"   && borra fichero ini1*.* usados para trasnmision
return && ****************************************

proce modiftp && la 1¦ vez, da aviso pero pone bien o JODE lockftp
* modificar campos para ftp al COF
*do testcalvo with v_paso
   sele 1   
   M_I=SYS(2020) && default disk si
   repla auxi->verftp with encri(auxi->claveftp )
   set format to ftpread
   READ
   if m_i<>auxi->lockftp
     wait windows " Problemas al actualizar datos ftp" 
   else
     repla auxi->claveftp with encri(auxi->verftp)
     repla auxi->verftp with ' ' 
   endif
   repla auxi->lockftp with m_i
return && ***************************************
function bitxor2 && xor de 2 binary en string 00,11->0 01,10->1
param n1,n2
v_q=0
v_s=''
k= 1
do while k<= len(n1)
 v_p= iif( substr(n1,k,1) = substr(n2,k,1), '0', '1' )
 v_s= v_s +v_p
 v_q= 2*v_q + val(v_p) &&
 k= k+1
enddo
return v_q &&*****************************************
function encri && encripta y desencripta 
para v_p1 &&,v_p2  && bitxor
m_kao=sys(2023)
v_p2=sys(2022)+sys(2020)
v_p3=''
for v_k=1 to 9 step 1
 v_nio1= asc( substr(v_p1,v_k,1))
 v_nio2= asc( substr(v_p2,v_k,1)) 
 v_nini= bitxor(v_nio1,v_nio2)
 v_p3=v_p3 +chr(v_nini)

* v_n1=Dtob(v_nio1)
* v_n2=Dtob(v_nio2)
* v_ni= bitxor2( v_n1,v_n2)

endfor
return v_p3 && *********************************************

Function Dtob()   && decimal to binary
LPARA mdec&&
mnlen=8
tempdec=mdec
mnbin=''
DO while tempdec>0
  mnbin=str(mod(tempdec,2),1)+mnbin
  tempdec=int(tempdec/2)
ENDDO
mnbin=padl(mnbin,mnlen,'0')
RETURN mnbin

