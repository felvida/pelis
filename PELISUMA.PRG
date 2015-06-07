* programa que genera un fichero .bat para mover los fic. de un directorio
* a .., siempre que la suma de lo que ocupan en bytes su suma sea < kte
SET FORMAT TO
set talk off
set echo off

kte=4702*1000000  && 4,7gigas
CLEAR
@ 1,63 say "pelisuma.prg  "
@ 2,2 SAY "Empiezo a agupar desde :" GET AUXI->col
@ 3,3 SAY " pelis en dir:" GET AUXI->DES
@ 4,3 SAY "(opcional) pelis en dir2:" GET AUXI->DES2
@ 6,3 SAY " tope de cabida DVD:" GET kte
@ 5,2 say "dir sin \ final,(dir2 en blanco no hace nada)"
@ 8,0 say "genera kk.bat,(^c) que mueve pelis al dir .. "
READ
?kte
dime combi[20]
*combi[1]=0
* meter listado de dir en pelis.dbf
v_dir=trim(AUXI->DES)
m_fra=" dir "+v_dir+" >kkdir.txt"
run &m_fra
copy file modpelis.dbf to kkpeli.dbf
do pelimete with "kkdir.txt","kkpeli",1,13,12
v_dir2=trim(AUXI->DES2)
if ''<>v_dir2
 repla sehizo with "1" all
 m_fra=" dir "+v_dir2+" >kkdir2.txt"
 run &m_fra
 do pelimete with "kkdir2.txt","kkpeli",1,13,12
 repla sehizo with "2" for sehizo<>'1'
endif
* le falta el .
sele kkpeli
sort on ocupa to kkpelis
use kkpelis alias kkpeli
set cons on && no sale sin lo pones
list FIEL OCUPA,ltrim(NOMBRE) to kktmp.txt
list fiel ocupa,ltrim(nombre)
********************************
* pte que como estan por orden ,cuando las combinaciones son de numeros
*posteriores se descarten si son superiores a kte, ya que no sirven
******************************** +++
*repla NOMBRE with substr(NOMBRE,1,8)+'.'+substr(NOMBRE,10,3)  all
* si lo pones falla akira.avi
* ahora hacer las combinaciones a pelicomb.dbf
sele 5
use
kkque='No'
if file("kksali.dbf")
 acce" Uso el kksali.dbf existente(No/Si):" to kkque
endif
if kkque='No'
 copy file modpelis.dbf to kksali.dbf
endif

use kksali alias salida

SELE KKPELI
V_N=RECCOUNT() &&los que hay 5
if v_n>22
 acce" Atencion proceso largo. Intro " to que
endif

V_In=AUXI->COL
@  3,43 say str(v_in,2)+" Ini.time recno. Intro->OUT"
if kkque='No'

 DO WHILE V_In<=V_N
  v_t=1
 *susp
  @  v_in,45 say str(v_in,2)+" Ini."+time()+str(recno())
  @ 19,45 say " Agrupando:"+str( v_in,2)
  v_min=KTE+1 && valor minimo para combinaciones
  DO PELICOMB WITH v_t,V_In  && C5,2 C5,3 C5,4 C5,5
  @ 1,66 say "pelisuma.prg  "
  V_In=V_In+1
  if v_min>kte
   @ 22,45 say v_min  && 01234567890123456789012345678901234567890
   @ 23,42 say          " el minimo de ult.agrupacion >tope"
   exit
  endif
  m_kk=inkey()
  if m_kk=13
   exit
  endif
 ENDDO
 * suma y busqueda del mas ajustado
 sele salida
 @ 10,50 say "indexando "+str(reccount())+" "+time()
 inde on ocupa to kk2
 @ 11,50 say "fin index "+time()
endif && ejecucion anterior

sele salida
set inde to kk2
set exact off
set near on
seek kte
*set filter to ocupa<=kte
*go bott
@ 17,50 say " Filtro x tope:"+str( recno() )
M_tecla=0
do while m_Tecla<>12 && esc
 brow title "Esc,^W(busca)" fiel ocupa,nombre
 m_tecla=readkey()
 if m_Tecla=270 && ^w
  acce "tama¤o a buscar(bytes):" to v_taman
  seek v_taman 
 endif
enddo
for v_l=len(v_dir) to 1 step -1     && c:\mio\tu\loca
 if substr(v_dir,v_l,1)="\"
  exit
 endif
endfor     
v_dirdes=  substr(v_dir,1,v_l)       && c:\mio\tu
***** 2 directorio
for v_l=len(v_dir2) to 1 step -1     && c:\mio\tu\loca
 if substr(v_dir2,v_l,1)="\"
  exit
 endif
endfor     
v_dirdes2=  substr(v_dir2,1,v_l)       && c:\mio\tu

m_mov=NOMBRE        && 1:2:3:4
set print to file kk.bat
set print on

?'REM ' +NOMBRE
do while  .t.
 v_pose=at(':',m_mov)
 if v_pose>0
  v_file=substr(m_mov,1,v_pose-1)           && 1
  m_mov=substr(m_mov,v_pose+1,len(m_mov)-v_pose)  && 2:3:4
  sele kkpeli
  go val(v_file)                          && gorka.avi
*  move file  nombre v_dirdes
  v_name=rtrim(NOMBRE)
  V_posp= at(' ',v_name) && posicion del espacio en blanco
   if v_posp>0
    * nombre corto con . pe: bailan~1 avi -> le falta el punto bailan~1.avi 
    v_name=stuff(v_name,v_posp,1,'.') && 'ghost.  avi'
    v_name=strtran(v_name,' ','')
   else && nombre ok
   endif
  if  kkpeli->sehizo='1'
   v_exe= " move "+v_dir+"\"+v_name+" "+v_dirdes
  else
   v_exe= " move "+v_dir2+"\"+v_name+" "+v_dirdes2
  endif
  ? v_exe
 else
   exit
 endif
enddo
set print to
set print off
sele kkpeli
use
sele 1
