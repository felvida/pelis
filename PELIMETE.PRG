param v_dir,v_bd,V_NOM,V_TAM,K_LON && DIR.TXT, PELIS.DBF ,37,23,13
* POSICION PRIMERA LETRA DEL NOMBRE, DEL TAMA¥O,KTE LONGITUD TAMA¥O
* p.e. dir.txt, pelis, 37,23,13 para meter dir.txt
* p.e. dir.txt, pelis, 1,13,12,0 para agrupar
SET DELE ON                 
set safe off
SELE 3
USE modline
copy stru to kk
use kk
if .not. file(v_dir)
 wait "no existe "+v_dir to que
 return
endif
appe from (v_dir) sdf && dir.txt
SELE 2
USE &v_bd && PELIS
SELE 3 &&KK
@1,68 say"pelimete.prg"
go top
m_llevo=0
*set step on
DO WHILE .NOT.EOF()
* kt=13 && TOPE PARA COGER NUMERO
 M_SIZE=SUBSTR(LIN1,V_TAM,K_LON)
 M_NOME=trim(LIN1 )
 IF V_NOM==1
  M_NAME=SUBSTR(LIN1,V_NOM, 12 ) && 13 fallan fic.de 1200.00000 bytes
 ELSE
  M_NAME=SUBSTR(LIN1,V_NOM, len(m_nome)+1-V_NOM )
 ENDIF
 IF ''<>TRIM(M_NAME)
   m_p1=at('.',m_size)
   m_si1=substr(m_size,1,m_p1-1)+substr(m_size,m_p1+1,K_LON-m_p1)
   m_p2=at('.',m_si1)
   m_si2=substr(m_si1,1,m_p2-1)+substr(m_si1,m_p2+1,K_LON-1-m_p2)
   m_p3=at('.',m_si2)
   IF M_P3>0       && PELIS DE 1.234.567.890
    if len(m_si2)>m_p3 && da error en linea 119 gigas libres en discoduro
     M_SI3=substr(m_si2,1,m_p3-1)+substr(m_si2,m_p3+1,K_LON-1-m_p3)
     M_SI2=M_SI3
    endif
   ENDIF
   M_tama=VAL(M_SI2)
   if len(m_nome)>28
    v_tip=substr(m_nome,22,5)
   else
    v_tip='NADA'
   endif
   v_tip=iif( m_tama=0, v_tip , RIGHT(rtrim(M_NAME),3) )
   v_tip=upper(v_tip) && en posicion 22 esta <dir> si es directorio
   If  v_tip='AVI'  .or. v_tip='MPG'  .or.  v_tip='<DIR>'
      SELE 2 && pelis
      APPE BLAN
      REPLA OCUPA WITH w(m_tama)
      repla dvd with w(auxi->numdvd)
      repla TIP with w(v_tip)
      v_pospunto=at('.',m_name)
      if v_tip='<DIR>'
       REPLA NOMBRE WITH w(m_name),TIP with w('DIR')
      else
       if v_pospunto<2
         if v_nom=1 && lamada para agrupacion de peliculas
          REPLA NOMBRE WITH w(m_name)
         else &6 lamada para meter dir.txt en bd
          ?m_name
          acce"error en nombre " to que
          susp
         endif
       else
        REPLA NOMBRE WITH w( substr(m_name,1,v_pospunto-1) )
       endif
       m_llevo=M_llevo+1
      endif
   Endif
 ENDIF
 SELE 3
 SKIP
ENDDO
sele 2 &&pelis
@ 10,50 say "meti en "+v_bd
@ 12,50 say reccount()
*acce"Intro" to que
sele 2 && pelis en pelismete

*brow
RETURN
